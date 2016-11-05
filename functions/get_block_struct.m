function [ block_struct ] = get_block_struct(block_name, decimal_ip,...
                                             ports,...
                                             in_sample_time, out_sample_time)
%GET_STRUCT_OF_BLOCK Summary of this function goes here
%   Just helper function for setting up parameters of simulink models

blocks_combination = {'in_delay',...
                'out_delay',...
                'in_system',...
                'out_system'};
            
port = ''; 
sample_time = '';

for k = 1:length(blocks_combination)
    name = blocks_combination{k};
    if(strfind(block_name, name) > 0)
        port = ports.(name);
        if(strfind(name, 'in_'))
            sample_time = in_sample_time;
        else
            sample_time = out_sample_time;
        end

        break; % no need to loop further
    end
end


block_struct = struct('name', block_name, 'decimal_ip', decimal_ip, 'port', port,...
                      'sample_time', sample_time);

end
