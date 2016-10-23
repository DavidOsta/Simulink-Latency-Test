function plot_delay(data)
%PLOT_DELAY Summary of this function goes here
%   Detailed explanation goes here

%% Processing
ref_signal = data.ref_signal;
delayed_signal_A = data.A_signal;
delayed_signal_B = data.B_signal;

[data_A, data_B ] = ...
    process_delay(ref_signal, delayed_signal_A, delayed_signal_B);

A_delay = data_A.A_delay;
B_delay = data_B.B_delay;

%% Visualization
figure;
latency = subplot(2,1, 1); grid on; hold on;
histo = subplot(2,1,2); hold on;

% plot colors
color_A = [0.8500,0.3250,0.0980];
color_B = [0, 0.4470, 0.7410];

% subplot 1st row -  latency
time = 1:1:length(A_delay);

% time_len = 1:0.001:10000;
upper_bound = 150; % turn off later
lower_bound = 0;
A_delay_filtered = A_delay(upper_bound > A_delay & A_delay > lower_bound);
B_delay_filtered = B_delay(upper_bound > B_delay & B_delay > lower_bound);

% A_time = time_len(200 > A_delay & A_delay > 0);
% 
% figure; hold on; grid on;
% scatter(A_time, A_delay_filtered);
% 
% B_time = time_len(200 > A_delay & B_delay > 0);

% scatter(B_time, B_delay_filtered);

                                                              
% plot(B_delay(B_delay > 0), 'o', 'LineWidth',1.5,...
%                                  'MarkerSize',5,...
%                                  'Color', color_B);                                       
                                                                                  

for k = 1:length(A_delay)
    tick = A_delay(k);
    if tick > lower_bound && tick <upper_bound % missed tick
       m = 'o';
       A_tick_ok = plot(latency, time(k), tick, m, 'LineWidth',1.5,...
                                                    'MarkerSize',5,...
                                                    'Color', color_A);
    end
end

time = 1:1:length(B_delay);
for k = 1:length(B_delay)
    tick = B_delay(k);
    if tick > lower_bound && tick <upper_bound % missed tick
        m = 'o';
        B_tick_ok = plot(latency, time(k), tick, m, 'LineWidth',1.5,...
                                                    'MarkerSize',5,...
                                                    'Color', color_B);
    end
end

xlabel(latency, '$time \: (s)$', 'interpreter', 'latex','FontSize', 15);
ylabel(latency, '$delay \: (ms)$', 'interpreter', 'latex','FontSize', 15);
title(latency, 'Latency during simulation','FontSize', 15);


% subplot 2nd row  -  Histogram
[num, date] = version;
bin_method = 'fd'; % The Freedman-Diaconis rule

if(str2double(date(end-4:end)) >= 2014)
    histogram(histo, A_delay_filtered,...
              'FaceColor', color_A,...
              'BinMethod', bin_method);
              %'BinWidth', 10);

    histogram(histo, B_delay_filtered,...
              'FaceColor', color_B,...
              'BinMethod', bin_method);

else
    hist(histo, A_delay_filtered, 'FaceColor', color_A);%, 'r');
    hist(histo, B_delay_filtered, 'FaceColor', color_B);%, 'b');
end

xlabel(histo, '$bins \: (msec)$', 'interpreter', 'latex','FontSize', 15);
ylabel(histo, '$occurence \: (1)$', 'interpreter', 'latex','FontSize', 15);
title(histo, 'Latency histogram','FontSize', 15);

end

