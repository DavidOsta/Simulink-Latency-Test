function setup_boards(inputs)

% GUI inputs
version = inputs.version;
station = inputs.station;
ip_address = inputs.ip_address;
ports_combination = inputs.ports;

model_name = strcat('boards_', version);

% open model
open(model_name);

regex_pattern = '^udp'; % all blocks for udp communication
list_of_blocks = get_list_of_blocks(model_name, regex_pattern);     
    
% Setup blocks     
in_sample_time = '0.001';
out_sample_time = '0.01';

configure_parameters(list_of_blocks, ip_address,...
                     ports_combination, station,...
                     in_sample_time, out_sample_time);
                 
end
