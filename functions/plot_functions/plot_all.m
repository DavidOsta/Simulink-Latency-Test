function plot_all(delay_data, response_data)

% Process and visualize measured data
% arg - filename in the 'measured_data' folder,
% e.g - process_and_plot_data('testSample')

%% Processing

ref_signal = delay_data.ref_signal;
delayed_signal_B = delay_data.B_signal;

plant_response_B = response_data.B_response;
data_B = process_delay(ref_signal, delayed_signal_B);

B_delay = data_B.B_delay;
B_lost_packets = data_B.B_lost_packets;

upper_bound = 150; % turn off later
lower_bound = 0;

B_delay_filtered = B_delay(upper_bound > B_delay & B_delay > lower_bound);

%% Visualization
response = subplot(3,2, [1,2]); grid on; hold on;
latency = subplot(3,2,[3,4]); grid on; hold on;

histo = subplot(3,2,5); hold on;
ticks = subplot(3,2,6); hold on;

color_A = [0.8500,0.3250,0.0980];
color_B = [0, 0.4470, 0.7410];

% subplot 1st row -  plant response
% plot(response, plant_response_A.Time, plant_response_A.Data,...
%     'LineWidth', 1.5, 'Color', color_A);
plot(response, plant_response_B.Time, plant_response_B.Data,...
    'LineWidth', 1.5, 'Color', color_B);

xlabel(response,'$time \: (s)$', 'interpreter', 'latex','FontSize', 15);
ylabel(response,'$y \: (1)$', 'interpreter', 'latex','FontSize', 15);
title(response,'Plant response - y','FontSize', 15);
legend(response, 'config A', 'config B',...
                 'Location', 'eastoutside' );

time = 1:1:length(B_delay);
for k = 1:length(B_delay)
    tick = B_delay(k);
    if tick <= 0 % missed tick
        m = 'x';
         % I do not want to plot ticks below zero they are just missticks
        B_tick_err = plot(latency, time(k), 0, m, 'LineWidth',1.5,...
                                                  'MarkerSize',5,...
                                                  'Color', color_B);
    else
        m = 'o';
        B_tick_ok = plot(latency, time(k), tick, m, 'LineWidth',1.5,...
                                                    'MarkerSize',5,...
                                                    'Color', color_B);
    end
end

xlabel(latency, '$time \: (s)$', 'interpreter', 'latex','FontSize', 15);
ylabel(latency, '$delay \: (ms)$', 'interpreter', 'latex','FontSize', 15);
ylim_curr = get(latency,'ylim');
if(ylim_curr(1) >= 0); ylim_curr(1) = 0; end;
set(latency,'ylim', ylim_curr); % change lower limit
title(latency, 'Latency during simulation','FontSize', 15);
% legend(latency, [A_tick_ok B_tick_ok A_tick_err B_tick_err],...
%                 'A tick', 'B tick', 'A miss', 'B miss',...
%                 'Location', 'eastoutside' );

% linking subplot 1 and 2
linkaxes([response,latency], 'x');

% subplot 3nd row -  Histogram
[num, date] = version;
bin_method = 'fd'; % because of our sampling resolution we cannot detect
                   % latency lesser than 0.01 seconds

if(str2double(date(end-4:end)) >= 2014)


    histogram(histo, B_delay_filtered,...
              'FaceColor', color_B,...
              'BinMethod', bin_method);

else
    hist(histo, B_delay_filtered, 'FaceColor', color_B);%, 'b');
end

xlabel(histo, '$bins \: (msec)$', 'interpreter', 'latex','FontSize', 15);
ylabel(histo, '$occurence \: (1)$', 'interpreter', 'latex','FontSize', 15);
title(histo, 'Latency histogram','FontSize', 15);

% subplot 4th row -  Missedticks
bar(ticks,2, B_lost_packets,'FaceColor', color_B);
ylabel(ticks, '$count \: (1)$', 'interpreter', 'latex','FontSize', 15);
set(ticks,'xtick',[])
alpha(0.5);
title(ticks, 'Missed ticks','FontSize', 15);

end
