
function setup_boards(inputs)

% GUI inputs
version = inputs.version;
station = inputs.station;
ip_address = inputs.ip_address;
ports_combination = inputs.ports;


model_name = strcat('boards_', version);

%% Setup blocks
block_names = {'udp_in_delay_A'; 'udp_out_delay_A';...
               'udp_in_system_A'; 'udp_out_system_A';...
               'udp_in_delay_B'; 'udp_in_system_B';};
              
in_sample_time = '0.001';
out_sample_time = '0.01';

configure_parameters(block_names, model_name,...
                     ip_address, ports_combination,...
                     station, in_sample_time, out_sample_time);
                 
end
