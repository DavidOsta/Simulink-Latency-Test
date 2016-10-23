function [ data_A, data_B ] = process_delay(ref_signal,...
                                         delayed_signal_A,...
                                         delayed_signal_B)
%PROCESS_DELAY Summary of this function goes here
%   Detailed explanation goes here

cut = 1; % 401, 1st occur in delayed

ref_data = ref_signal.Data(cut:end-1);
A_data = delayed_signal_A.Data(cut:end-1);
B_data = delayed_signal_B.Data(cut:end-1);

sample_step = delayed_signal_A.Time(2) - delayed_signal_B.Time(1);
split_size = 1 / sample_step;
col_split = length(ref_data) / split_size; % number of columns

% each column represents measured data betwen pulses,
% generated from ref_signal
ref_splited = reshape(ref_data, [], col_split);
A_splited = reshape(A_data, [], col_split);
B_splited = reshape(B_data, [], col_split);

% suppress warning for missed ticks
warning('off','signal:finddelay:noSignificantCorrelationVector');

to_milisec = sample_step * 1000;

A_delay = finddelay(ref_splited, A_splited) * to_milisec;
B_delay = finddelay(ref_splited, B_splited) * to_milisec;

A_delay_non_missed = A_delay(A_delay > 0); % ~=
A_missed_ticks = length(A_delay) - length(A_delay_non_missed);

B_delay_non_missed = B_delay(B_delay > 0); % ~=
B_missed_ticks = length(B_delay) - length(B_delay_non_missed);

data_A = struct('A_delay', A_delay, 'A_missticks', A_missed_ticks);
data_B = struct('B_delay', B_delay, 'B_missticks', B_missed_ticks);

end

