function plot_response( response_data )
%PLOT_RESPONSE Summary of this function goes here
%   Detailed explanation goes here

figure; grid on; hold on;

plant_response_A = response_data.A_response;
plant_response_B = response_data.B_response;

color_A = [0.8500,0.3250,0.0980];
color_B = [0, 0.4470, 0.7410];

% subplot 1st row -  plant response
plot(plant_response_A.Time, plant_response_A.Data,...
    'LineWidth', 1.5, 'Color', color_A);
plot(plant_response_B.Time, plant_response_B.Data,...
    'LineWidth', 1.5, 'Color', color_B);

xlabel('$time \: (s)$', 'interpreter', 'latex','FontSize', 15);
ylabel('$y \: (1)$', 'interpreter', 'latex','FontSize', 15);
title('Plant response - y','FontSize', 15);
legend('config A', 'config B');
end

