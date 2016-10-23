function test_delay(inputs)
%TEST_DELAY Summary of this function goes here
%   Detailed explanation goes here

% GUI inputs
version = inputs.version;
station = inputs.station;
ip_address = inputs.ip_address;
ports_combination = inputs.ports;
save_data_checkbox = inputs.save_data;
check_ports = inputs.test_ports;


model_name = strcat('delay_', station,'_', version);
open(model_name);

%% Setup blocks
block_names = {'udp_in_delay_A'; 'udp_out_delay_A';...
               'udp_in_delay_B'; 'udp_out_delay_B';};
              
in_sample_time = '0.0001';
out_sample_time = '0.001';
configure_parameters(block_names, model_name,...
                     ip_address, ports_combination,...
                     station, in_sample_time, out_sample_time);
                 
%% Simulation
run_sim = true;
if(check_ports)
   run_sim = test_ports(version, station, ip_address, ports_combination);
end

if(run_sim)
    fprintf('\t=== Start of simulation ===\n');
    
    sim_out = sim(model_name, 'ReturnWorkspaceOutputs','on');

    fprintf('\t=== End of simulation ===\n'); 
end


% save data - optional 
if(run_sim && save_data_checkbox)
    path = save_measured_data(sim_out);
    plot_data(path);
end;

fprintf('\n\t=== End ===\n');

end

