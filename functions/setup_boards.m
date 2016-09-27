
function setup_boards(ip_address, version, ports )

model_name = strcat('boards_', version);

configure_parameters(model_name, ip_address, ports,...
                     'plant', '0.01', '0.001');
end
