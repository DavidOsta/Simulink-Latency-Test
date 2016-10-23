function block_structs = configure_parameters(...
                                   block_names, name_of_simulink_model, decimal_ip,...
                                   ports_combination, station,...
                                   in_sample_time, out_sample_time)

%% Info

%% Plant Configuration
% name of simulink model
open(name_of_simulink_model);
model_path = strcat(name_of_simulink_model,'/'); % 'plant_PRG/';

%% Define Parameters
% select ports
[ports_A, ports_B] = get_ports(station, ports_combination);

%% Set up blocks
num_of_blocks = numel(block_names);
block_structs(num_of_blocks) = struct('name', [], 'decimal_ip', [],...
                                      'port', [], 'sample_time', []);

for k = 1:num_of_blocks
    block_name = strcat(model_path,char(block_names(k)));
    block_structs(k) = get_block_struct(block_name, decimal_ip,...
                                        ports_A, ports_B,...
                                        in_sample_time, out_sample_time);
end

% setup parameters
for b = block_structs
    set_udp_block(b);
end

end
