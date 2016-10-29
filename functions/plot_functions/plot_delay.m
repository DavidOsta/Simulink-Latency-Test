function plot_delay(data)
%PLOT_DELAY Summary of this function goes here
%   Detailed explanation goes here

%% Processing
ref_signal = data.ref_signal;
delayed_signal_A = []; %data.A_signal;
delayed_signal_B = data.B_signal;

[data_A, data_B ] = ...
    process_delay(ref_signal, delayed_signal_A, delayed_signal_B);

% A_delay = data_A.A_delay;
delay_B = data_B.B_delay;
lost_packets_B = data_B.B_lost_packets;


%% Visualization
latency = subplot(2,1, 1); grid on; hold on;
histo = subplot(2,1,2); hold on;

% plot colors
color_A = [0.8500,0.3250,0.0980];
color_B = [0, 0.4470, 0.7410];

% subplot 1st row -  latency
time = 1:1:length(delay_B);

% time_len = 1:0.001:10000;
upper_bound = inf;%150; % turn off later
lower_bound = 0;
B_delay_filtered = delay_B(upper_bound > delay_B & delay_B > lower_bound);


time = 1:1:length(delay_B);
for k = 1:length(delay_B)
    tick = delay_B(k);
    if tick > lower_bound && tick <upper_bound % missed tick
        m = 'o';
        B_tick_ok = plot(latency, time(k), tick, m, 'LineWidth',1.5,...
                                                    'MarkerSize',5,...
                                                    'Color', color_B);
    end
end

xlabel(latency, '$time \: (s)$', 'interpreter', 'latex','FontSize', 15);
ylabel(latency, '$delay \: (ms)$', 'interpreter', 'latex','FontSize', 15);
title(latency, 'Delay during simulation','FontSize', 15);


% subplot 2nd row  -  Histogram
[num, version_year] = version;
bin_method = 'auto'; % The Freedman-Diaconis rule

mean_B = mean(B_delay_filtered);
std_B = std(B_delay_filtered);

if(str2double(version_year(end-4:end)) >= 2014)
    histogram(histo, B_delay_filtered,...
              'FaceColor', color_B,...
              'BinMethod', bin_method);
%               %'BinWidth', 10);

else
    hist(histo, B_delay_filtered, 'FaceColor', color_B);%, 'b');
end
% set(histo,'xtick',[80:1:200]); grid on
xlabel(histo, '$delay \: (msec)$', 'interpreter', 'latex','FontSize', 15);
ylabel(histo, '$frequency \: (1)$', 'interpreter', 'latex','FontSize', 15);
title(histo, 'Delay histogram','FontSize', 15);
annotation('textbox','Position',[.8 .85 .1 .05],...
                     'String',{sprintf('mean : %f [msec]', mean_B),...
                               sprintf('std : %f [msec]', std_B)});

% Lost packets                  
packets_ts = data.packets;
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
