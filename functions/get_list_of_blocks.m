function [ udp_block_names ] = get_list_of_blocks( model_name, regex_pattern )
%GET_LIST_OF_UDP_BLOCKS Summary of this function goes here
%   Detailed explanation goes here

udp_block_names =  find_system(model_name,...               
                               'Regexp', 'on',...
                               'Name', regex_pattern);
end

