function plot_delay(fig_name, folder_path, file_struct)
%PLOT_DELAY Summary of this function goes here
%   Detailed explanation goes here

%% Processing

figure('Name',fig_name,'NumberTitle','off');

file_name = file_struct.name;
file_path = sprintf('%s/%s', folder_path, file_name);
data = load(file_path); % load to struct
    
    
ref_signal = data.ws_delay_ref;
delay_signal = data.ws_delay;
delay_rt = data.ws_delay_rt;

measured_delay = process_delay(ref_signal, delay_signal);
delay_of_ref_signal = measured_delay.delay;


%% Visualization
latency = subplot(3,1, 1); grid on; hold on;
delay_real_time = subplot(3,1,2); hold on;
histo = subplot(3,1,3); hold on;

% plot colors
color_A = [0.8500,0.3250,0.0980];
color_B = [0, 0.4470, 0.7410];

% subplot 1st row -  latency
time = 1:1:length(delay_of_ref_signal);

% time_len = 1:0.001:10000;
upper_bound = inf;%150; % turn off later
lower_bound = 0;
delay_filtered =...
    delay_of_ref_signal(upper_bound > delay_of_ref_signal &...
                        delay_of_ref_signal > lower_bound);


time = 1:1:length(delay_of_ref_signal);
for k = 1:length(delay_of_ref_signal)
    tick = delay_of_ref_signal(k);
    if tick > lower_bound && tick <upper_bound % missed tick
        m = 'o';
        B_tick_ok = plot(latency, time(k), tick, m, 'LineWidth',1.5,...
                                                    'MarkerSize',5,...
                                                    'Color', color_B);
    end
end
setup_labels(latency,'Delay from sim results',...
                            '$time \: (s)$',...
                            '$delay \: (ms)$');

% subplot 2nd row  -  Histogram
[num, version_year] = version;
bin_method = 'auto'; % The Freedman-Diaconis rule

measured_mean = mean(delay_filtered);
measured_std = std(delay_filtered);

if(str2double(version_year(end-4:end)) >= 2014)
    histogram(histo, delay_filtered,...
              'FaceColor', color_B,...
              'BinMethod', bin_method);
%               %'BinWidth', 10);

else
    hist(histo, delay_filtered, 'FaceColor', color_B);%, 'b');
end
% set(histo,'xtick',[80:1:200]); grid on

setup_labels(histo,'Delay histogram',...
                    '$delay \: (msec)$',...
                    '$frequency \: (1)$');
                        
annotation('textbox','Position',[.8 .85 .1 .05],...
                     'String',{sprintf('mean : %f [msec]', measured_mean),...
                               sprintf('std : %f [msec]', measured_std)});

                           
% real-time delay                           
plot(delay_real_time, delay_rt.Time, delay_rt.Data,...
    'LineWidth', 1.5, 'Color', color_B);

setup_labels(delay_real_time,'Delay measured during simulation',...
                            '$time \: (s)$',...
                            '$delay \: (ms)$');
% Lost packets                  
packets_ts = data.ws_packets;
packets = packets_ts.Data(packets_ts.Data > 0);
figure
plot(packets)

[uniq_packets,indx,uniq_indx] = unique(packets);

len_packets = length(packets);
len_uniq_packets = length(uniq_packets);

lost_packets = len_packets - len_uniq_packets;
lost_percent = (lost_packets / len_packets) * 100;

fprintf('\t\n%.2f percent of lost packets\n', lost_percent);


end

