function [ folder_name ] = create_folder(root_folder, model_name)
%CREATE_FOLDER_NAME Summary of this function goes here
%   Detailed explanation goes here

    current_date = strrep(datestr(now), ':', ';');
    folder_name = strcat(current_date, '-', model_name);
    folder_path = sprintf('%s/%s',root_folder, folder_name);
    % because of windows10
    mkdir(folder_path);
end

