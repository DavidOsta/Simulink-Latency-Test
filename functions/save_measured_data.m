function [data_path] = save_measured_data(sim_out)
%SAVE_MEASURED_DATA Summary of this function goes here
%   Detailed explanation goes here

fprintf('\t=== Saving simulation results ===\n');

ws_data = sim_out.get; % workspace names

if(length(ws_data) > 1)
    curr_time_folder = strrep(datestr(now), ':', ';');
    new_dir = sprintf('measured_data/%s', curr_time_folder); % because of windows10
    mkdir(new_dir);
    
    data_struct = struct('delay_A',[],'delay_B', [], 'delay_ref', [],...
                         'response_A', [],'response_B', []);
    
    data_fields = fieldnames(data_struct);
   

    for fl = 1:length(data_fields)
        fl_name = data_fields{fl};
        for ws = 1:length(ws_data)
            ws_name = ws_data{ws};
            if(~isempty(strfind(ws_name,fl_name)))
                data_struct.(fl_name) = sim_out.get(ws_name);
                break;
            end
        end            
    end
    
    save_path = sprintf('%s/%s',new_dir, 'measured_data');
    save(save_path, 'data_struct');
    
    fprintf('\n\tresults are stored in the folder: ''%s''\n', curr_time_folder);
    data_path = curr_time_folder;
else
    fprintf('\n\tno data to be stored\n');
    data_path = '';
end

end

