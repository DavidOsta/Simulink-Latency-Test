function update_gui_listbox(handles)
    folders_struct = dir('measured_data');
    % (3:end) -> skip curr folder '.' and up directory '..'
    folders_struct = folders_struct(3:end);
    
    sub_folders = folders_struct([folders_struct.isdir]);
    num_of_folders = length(sub_folders);
    folders_listbox = cell(1, num_of_folders); % preallocate cell
    
    for k = 1:num_of_folders
        folders_listbox{k} = sub_folders(k).name;
    end
    
    set(handles.measured_data_listbox,'String', folders_listbox);
end

