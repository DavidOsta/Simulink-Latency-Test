function save_measured_data(file_name, folder_name,...
                                          root_folder, sim_out)
%SAVE_MEASURED_DATA Summary of this function goes here
%   Detailed explanation goes here


data_names_ws = sim_out.get; % workspace names

if(length(data_names_ws) > 1) % something is saved to workspace

    % get workspace data by their names and save them by their names
    for k = 1:length(data_names_ws)
        name_ws = data_names_ws{k};
        temp_name = sim_out.get(name_ws);
        eval(sprintf('%s = temp_name;',name_ws)); % i know ...
    end

    % save all variables with ws_ (workspace) suffix
    save_path = sprintf('%s/%s/%s', root_folder, folder_name, file_name);
    save(save_path, '-regexp', '^ws_');


else
    fprintf('\n\tno data to be stored\n');
%     save_path = '';
end

end
