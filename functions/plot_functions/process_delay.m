function [ data_A, data_B ] = process_delay(ref_signal,...
                                         delayed_signal_A,...
                                         delayed_signal_B)
%PROCESS_DELAY Summary of this function goes here
%   Detailed explanation goes here

cut = 1; % 401, 1st occur in delayed

ref_data = ref_signal.Data(cut:end-1);
B_data = delayed_signal_B.Data(cut:end-1);

sample_step = delayed_signal_B.Time(2) - delayed_signal_B.Time(1);
split_size = 1 / sample_step;
col_split = length(ref_data) / split_size; % number of columns

% each column represents measured data betwen pulses,
% generated from ref_signal
ref_splited = reshape(ref_data, [], col_split);
B_splited = reshape(B_data, [], col_split);

% suppress warning for missed ticks
warning('off','signal:finddelay:noSignificantCorrelationVector');

to_milisec = sample_step * 1000;

B_delay = finddelay(ref_splited, B_splited) * to_milisec;
B_delay_non_missed = B_delay(B_delay > 0); % ~=
B_lost_packets = length(B_delay) - length(B_delay_non_missed);

data_B = struct('B_delay', B_delay, 'B_lost_packets', B_lost_packets);
% fprintf('Packets %d, lost packets %d \n',length(B_delay), B_lost_packets);


data_A = 0;
end

