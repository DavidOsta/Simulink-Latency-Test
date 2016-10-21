function test_ports(version, station,...
                                      decimal_ip, ports_combination )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
model_name = strcat('port_checker_', version);
open(model_name);
model_path = strcat(model_name,'/'); % 'plant_PRG/';

%% Setup blocks
[ports_A, ports_B] = get_ports(station, ports_combination);

udp_in_delay_A = get_block_struct(strcat(model_path, 'udp_in_delay_A'),...
                                    decimal_ip, ports_A.in_delay, 'none');

udp_out_delay_A = get_block_struct(strcat(model_path, 'udp_out_delay_A'),...
                                    decimal_ip, ports_A.out_delay, 'none');

udp_in_system_A = get_block_struct(strcat(model_path, 'udp_in_system_A'),...
                                    decimal_ip, ports_A.in_system, 'none');

udp_out_system_A = get_block_struct(strcat(model_path, 'udp_out_system_A'),...
                                    decimal_ip, ports_A.out_system, 'none');

udp_in_delay_B = get_block_struct(strcat(model_path, 'udp_in_delay_B'),...
                                    decimal_ip, ports_B.in_delay, 'none');

udp_out_delay_B = get_block_struct(strcat(model_path, 'udp_out_delay_B'),...
                                    decimal_ip, ports_B.out_delay, 'none');

udp_in_system_B = get_block_struct(strcat(model_path, 'udp_in_system_B'),...
                                    decimal_ip, ports_B.in_system, 'none');
                                
udp_out_system_B = get_block_struct(strcat(model_path, 'udp_out_system_B'),...
                                 decimal_ip, ports_B.out_system, 'none');
                             
                             % array of blocks
blocks = [udp_in_delay_A, udp_out_delay_A, udp_in_system_A, udp_out_system_A,...
          udp_in_delay_B, udp_out_delay_B, udp_in_system_B, udp_out_system_B];
    
% setup udp block parameters
for b = blocks
    set_udp_block(b);
end

% set workspace name
% receiving blocks send data to workspace
% this is dirty, if you have time redo it
workspace_timeseries_name = {};
for k = 1:length(blocks)
    block_loop = blocks(k);
    if(strfind(block_loop.name,'udp_in') > 0)
        workspace_block_name = strcat(model_path, sprintf('port_%s',...
            get_param(block_loop.name, 'Name')));
        workspace_name = sprintf('port_%s', block_loop.port);
        set_param(workspace_block_name, 'VariableName', workspace_name);
        workspace_timeseries_name{end+1} = workspace_name;
    end
end

%% Run test
sim(model_name)

%% Process data
for k = workspace_timeseries_name
    data_loop = eval(k{1}); % fast & dirty - for this purpose ok
    if(isempty(find(data_loop.Data > 0, 1)))
        fprintf('\tConnection to ''%s'' failed\n', k{1})
    else
        fprintf('\tConnection to ''%s'' succeed\n', k{1})
    end
end


end

