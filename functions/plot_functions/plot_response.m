function plot_response( ws_response )
%PLOT_PLANT Summary of this function goes here
%   Detailed explanation goes here
% plot for plant station
hndl_response = subplot(1,1,1); grid on; hold on;
setup_labels(hndl_response,'Plant response - y',...
    '$time \: (s)$',...
    '$cart \: position (m)$');

plot(hndl_response, ws_response.Time, ws_response.Data,...
    'LineWidth', 1.5);

end

