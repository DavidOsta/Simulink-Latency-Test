function [ ports_A, ports_B ] = get_ports(place)
%GET_PORTS Summary of this function goes here
%   Auxiliary function to set correct ports in simulink models
%   arg - string of place name, either 'BOS' or 'PRG'

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


if strcmpi(place,'BOS')
    % config A
    ports_A = struct('out_delay', port_A1, 'in_delay', port_B1,...
                     'out_system', port_A2, 'in_system', port_B2);
    % config B
    ports_B = struct('out_delay', port_C1, 'in_delay', port_D1,...
                     'out_system', port_C2, 'in_system', port_D2);
                     
elseif strcmpi(place,'PRG')
    % config A
    ports_A = struct('out_delay', port_B1, 'in_delay', port_A1,...
                     'out_system', port_B2, 'in_system', port_A2);
    % config B
    ports_B = struct('out_delay', port_D1, 'in_delay', port_C1,...
                     'out_system', port_D2, 'in_system', port_C2);

else
    disp('Wrong argument select : BOS or PRG');
end

