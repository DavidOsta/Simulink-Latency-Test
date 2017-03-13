function plot_delay( ws_delay )
%PLOT_DELAY Summary of this function goes here
%   Detailed explanation goes here
%PLOT_DELAY Summary of this function goes here
%   Detailed explanation goes here

%% Processing

delay_signal_data = ws_delay.Data;
delay_signal_time = ws_delay.Time;

lower_bound = 0;
upper_bound = 200;
received_packets = delay_signal_data(delay_signal_data > lower_bound ...
    & delay_signal_data < upper_bound);
lost_packets = delay_signal_data(delay_signal_data == 0);



%% Visualization
latency = subplot(2,1, 1); grid on; hold on;
histo = subplot(2,1,2); hold on;

% plot colors
color_A = [0.8500,0.3250,0.0980];
color_B = [0, 0.4470, 0.7410];


time = 1:1:length(delay_signal_time);
for k = 1:length(delay_signal_data)
    tick = delay_signal_data(k);
    if tick > lower_bound && tick <upper_bound % missed tick
        m = 'o';
        tick_ok = plot(latency, time(k), tick, m, 'LineWidth',1.5,...
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



measured_mean = mean(received_packets);
measured_std = std(received_packets);

if(str2double(version_year(end-4:end)) >= 2014)
    histogram(histo, received_packets,...
        'FaceColor', color_B,...
        'BinMethod', bin_method);
    %               %'BinWidth', 10);
    
else
    hist(histo, received_packets);%, 'b');
end
% set(histo,'xtick',[80:1:200]); grid on

setup_labels(histo,'Delay histogram',...
    '$delay \: (msec)$',...
    '$frequency \: (1)$');

% annotation('textbox','Position',[.8 .85 .1 .05],...
%     'String',{sprintf('mean : %f [msec]', measured_mean),...
%     sprintf('std : %f [msec]', measured_std)});


lost_packets_percent = (length(lost_packets) / length(delay_signal_data)) * 100;
%
fprintf('\t\n%.2f percentage of lost packets\n', lost_packets_percent);

end

