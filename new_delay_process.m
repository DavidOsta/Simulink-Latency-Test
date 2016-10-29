function [packets_delay, lost_packets] = new_delay_process(ref_signal,del_signal)

% model_name = 'new_signal_generator';
% sim_out = sim(model_name, 'ReturnWorkspaceOutputs','on');
% 
% ws_data = sim_out.get; % workspace names
% ref_signal_name = 'ref_signal'; %ws_data{1};
% ref_signal = sim_out.get(ref_signal_name);
% 
% del_signal_name = 'del_signal';
% del_signal = sim_out.get(del_signal_name);


step_size = 1;
sample_time = 0.0001;
upper_limit = step_size / sample_time;


function updated_data = transfrom_data(data)
    data_len = length(data);
    updated_data = zeros(upper_limit, data_len);
    temp_array = zeros(1, data_len);
    
    step_value = 1;
    for k = 1:upper_limit

        % replace non step value with 0
        % step_value = 3, [1 2 3 4] -> [0 0 3 0]  
        temp_array(1:data_len) = step_value; 
        temp_array(data ~= k) = 0;

        % shift steps [0 0 3 0] -> [3 0 0 0]
        shifted_steps = circshift(temp_array, [0, 1-step_value]);
        % write transformed values
%         updated_data(k,:) = shifted_steps;
        updated_data(k,:) = shifted_steps;


        if(step_value <= upper_limit)
            step_value = step_value + 1;
        else
            step_value = 1;
        end
    end
    
end

ref_data = ref_signal.Data(1:end-1);
ref_up_data = transfrom_data(ref_data);
delay_up_data = transfrom_data(del_signal.Data);


num_of_columns = length(ref_data) / upper_limit;

delays = zeros(num_of_columns,upper_limit);
d_indx = 1;
warning('off','signal:finddelay:noSignificantCorrelationVector');

for left = 1:upper_limit:length(ref_data)
    right = left + upper_limit - 1;
    % left = 1 -> right = left + 1000 - 1
    A = ref_up_data(:, left:right);
    B = delay_up_data(:, left:right);
    delays(d_indx,:) = finddelay(A', B');
    d_indx = d_indx + 1;
end

delays = delays';
packets_delay = delays(:);% delays_unrolled = reshape(v',length(ref_data),1); % or 
lost_packets(del_signal.Data == 0) = 1;

end