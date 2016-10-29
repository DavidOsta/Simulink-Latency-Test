function [success] = test_ports(version, station,...
                                      decimal_ip, ports_combination )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
model_name = strcat('port_checker_', version);
open(model_name);
model_path = strcat(model_name,'/'); % 'plant_PRG/';

%% Setup blocks

block_names = {'udp_in_delay_B'; 'udp_out_delay_B';...
               'udp_in_system_B'; 'udp_out_system_B'}; %...
%                'udp_in_delay_B'; 'udp_out_delay_B';...
%                'udp_in_system_B'; 'udp_out_system_B'};
              
blocks = configure_parameters(block_names, model_name,...
                              decimal_ip, ports_combination,...
                              station, 0, 0);

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
fprintf('\n\t=== Testing connection ports ===\n\n');
sim(model_name)


%% Process data
success = true;
for k = workspace_timeseries_name
    data_loop = eval(k{1}); % fast & dirty - for this purpose ok
    if(isempty(find(data_loop.Data > 0, 1)))
        fprintf('\tConnection to ''%s'' failed\n', k{1});
        success = false;
    else
        fprintf('\tConnection to ''%s'' succeed\n', k{1});
    end
end

if(~success)
   fprintf(['\n\tConnection test failed, try different port combination\n' ...
           '\tor setup new boards\n']);       
end

fprintf('\n\t=== End of ports'' test ===\n');

end

