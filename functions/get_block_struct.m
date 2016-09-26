function [ block_struct ] = get_block_struct(name, decimal_ip, port,...
                                                sample_time)
%GET_STRUCT_OF_BLOCK Summary of this function goes here
%   Just helper function for setting up parameters of simulink models

block_struct = struct('name', name, 'decimal_ip', decimal_ip, 'port', port,...
                      'sample_time', sample_time);
end

