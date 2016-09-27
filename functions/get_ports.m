function [ ports_A, ports_B ] = get_ports(place, combination)
%GET_PORTS Summary of this function goes here
%   Auxiliary function to set correct ports in simulink models
%   arg - string of place name, either 'BOS' or 'PRG'

switch combination
    case 'A' 
         % config A
        port_A1 = '27000';
        port_A2 = '27500';
        port_B1 = '28000';
        port_B2 = '28500';
        % config B
        port_C1 = '27010';
        port_C2 = '27510';
        port_D1 = '28010';
        port_D2 = '28510';  
    case 'B'
        % config A
        port_A1 = '20000';
        port_A2 = '20500';
        port_B1 = '21000';
        port_B2 = '21500';
        % config B
        port_C1 = '20010';
        port_C2 = '20510';
        port_D1 = '21010';
        port_D2 = '21510';
    case 'C'
        % config A
        port_A1 = '22000';
        port_A2 = '22500';
        port_B1 = '23000';
        port_B2 = '23500';
        % config B
        port_C1 = '22010';
        port_C2 = '22510';
        port_D1 = '23010';
        port_D2 = '23510';
    otherwise
        error('Unexpected ports combination')
end


switch place
    case 'controller'
        % config A
        ports_A = struct('out_delay', port_A1, 'in_delay', port_B1,...
                        'out_system', port_A2, 'in_system', port_B2);
        % config B
        ports_B = struct('out_delay', port_C1, 'in_delay', port_D1,...
                        'out_system', port_C2, 'in_system', port_D2);
    case 'plant'
        % config A
        ports_A = struct('out_delay', port_B1, 'in_delay', port_A1,...
                         'out_system', port_B2, 'in_system', port_A2);
        % config B
        ports_B = struct('out_delay', port_D1, 'in_delay', port_C1,...
                         'out_system', port_D2, 'in_system', port_C2);
    otherwise
        error('Invalid place argument') 
end

end

