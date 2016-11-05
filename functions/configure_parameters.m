function block_structs = configure_parameters(...
                                   list_of_blocks, decimal_ip,...
                                   ports_combination, station,...
                                   in_sample_time, out_sample_time)

%% Info


%% Define Parameters
% select ports
[ports, ports_diff_config] = get_ports(station, ports_combination);

%% Set up blocks
num_of_blocks = numel(list_of_blocks);

% allocate struct
block_structs(num_of_blocks) = struct('name', [], 'decimal_ip', [],...
                                      'port', [], 'sample_time', []);

for k = 1:num_of_blocks
    block_name = list_of_blocks{k}; 
    block_structs(k) = get_block_struct(block_name, decimal_ip,...
                                        ports,...
                                        in_sample_time, out_sample_time);
                                    
   % it could be an one-liner but for better debugging and readebility                                 
   set_udp_block(block_structs(k));                                 
end

end
