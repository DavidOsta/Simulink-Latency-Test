function sim_out = start_simulation(gui_inputs, model_name,...
                                  in_sample_time, out_sample_time)
%RUN_SIMUL Summary of this function goes here
%   Detailed explanation goes here

station = gui_inputs.station;
ip_address = gui_inputs.ip_address;
ports_combination = gui_inputs.ports;

regex_pattern = '^udp'; % all blocks for udp communication

load_system(model_name);
% load scope windows
open_system(strcat(model_name, '/', model_name));


list_of_blocks = get_list_of_blocks(model_name, regex_pattern);

configure_parameters(list_of_blocks, ip_address,...
                     ports_combination, station,...
                     in_sample_time, out_sample_time);

sim_out = sim(model_name, 'ReturnWorkspaceOutputs','on');

% close_system(model_name, 0);

end
