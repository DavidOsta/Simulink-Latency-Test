function plot_response(is_plant, fig_name, folder_path, file_struct)
%PLOT_RESPONSE Summary of this function goes here
%   Detailed explanation goes here

% color_A = [0.8500,0.3250,0.0980];
% color_B = [0, 0.4470, 0.7410];

figure('Name',fig_name,'NumberTitle','off');


if(~is_plant)
    hndl_response = subplot(2,1, 1); grid on; hold on;
    setup_labels(hndl_response,'Plant response - y',...
                                '$time \: (s)$',...
                                '$cart \: position (m)$');
    legend(hndl_response, 'config A', 'config B');

    hndl_delay = subplot(2,1,2); grid on; hold on;                        
    setup_labels(hndl_delay,'Delay during simulation',...
                                '$simulation time \: (s)$',...
                                '$delay \: (ms)$');                        
    legend('config A', 'config B');

    files = {file_struct.name};
    
    for k = 1:length(files)
        file_name = files{k};
        file_path = sprintf('%s/%s', folder_path, file_name);
        data = load(file_path); % load to struct      

        plot(hndl_response, data.ws_response.Time, data.ws_response.Data,...
            'LineWidth', 1.5);hold on

        plot(hndl_delay, data.ws_delay_rt.Time, data.ws_delay_rt.Data,...
            'LineWidth', 1.5);hold on
    end
else
    
    hndl_response = subplot(1,1,1); grid on; hold on;                        
    setup_labels(hndl_response,'Plant response - y',...
                                '$time \: (s)$',...
                                '$cart \: position (m)$');
   for file = file_struct
        file_name = file.name;
        file_path = sprintf('%s/%s', folder_path, file_name);
        data = load(file_path); % load to struct      

        plot(hndl_response, data.ws_response.Time, data.ws_response.Data,...
            'LineWidth', 1.5);
    end                         
    
end

end

