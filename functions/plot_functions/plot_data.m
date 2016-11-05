function plot_data(path)
%HELPER Summary of this function goes here
%   Detailed explanation goes here


folder_path = sprintf('measured_data/%s', path);
file_struct = dir(fullfile(folder_path,'*.mat'));
 
files = file_struct.name;

is_plant = ~isempty(strfind(path,'plant') > 0);

if(isempty(strfind(files, 'delay')))
    fig_name = strcat(path, ' - System response');
    
    plot_response(is_plant, fig_name, folder_path, file_struct);
else
    fig_name = strcat(path, ' - Round-trip Delay');
    
    if(is_plant)
        plot_delay(fig_name, folder_path, file_struct);
    end    
end


end

