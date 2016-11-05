function measured_delay = process_delay(ref_signal, delay_signal)
%PROCESS_DELAY Summary of this function goes here
%   Detailed explanation goes here

cut = 1; % 401, 1st occur in delayed

ref_data = ref_signal.Data(cut:end-1);
delay_data = delay_signal.Data(cut:end-1);

sample_step = delay_signal.Time(2) - delay_signal.Time(1);
split_size = 1 / sample_step;
col_split = length(ref_data) / split_size; % number of columns

% each column represents measured data betwen pulses,
% generated from ref_signal
ref_splited = reshape(ref_data, [], col_split);
delay_splited = reshape(delay_data, [], col_split);

% suppress warning for missed ticks
warning('off','signal:finddelay:noSignificantCorrelationVector');
to_milisec = sample_step * 1000;

found_delay = finddelay(ref_splited, delay_splited) * to_milisec;
delay_non_missed = found_delay(found_delay > 0); % ~=
lost_packets = length(found_delay) - length(delay_non_missed);

measured_delay = struct('delay', found_delay,...
                          'lost_packets', lost_packets);
                      
% fprintf('Packets %d, lost packets %d \n',length(B_delay), B_lost_packets);

end

