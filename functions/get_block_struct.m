function [ block_struct ] = get_block_struct(block_name, decimal_ip,...
                                             ports_A, ports_B,...
                                             in_sample_time, out_sample_time)
%GET_STRUCT_OF_BLOCK Summary of this function goes here
%   Just helper function for setting up parameters of simulink models

if(strfind(block_name,'A') > 0)
    if(strfind(block_name,'udp_in') > 0)
        if(strfind(block_name,'delay') > 0)
            port = ports_A.in_delay;
        else
            port = ports_A.in_system;
        end
        sample_time = in_sample_time;
    else %out
        if(strfind(block_name,'delay') > 0)
            port = ports_A.out_delay;
        else
            port = ports_A.out_system;
        end
        sample_time = out_sample_time;
    end
else % B
    if(strfind(block_name,'udp_in') > 0)
        if(strfind(block_name,'delay') > 0)
            port = ports_B.in_delay;
        else
            port = ports_B.in_system;
        end
        sample_time = in_sample_time;
    else %out
        if(strfind(block_name,'delay') > 0)
            port = ports_B.out_delay;
        else
            port = ports_B.out_system;
        end
        sample_time = out_sample_time;
    end
end


block_struct = struct('name', block_name, 'decimal_ip', decimal_ip, 'port', port,...
                      'sample_time', sample_time);

end
