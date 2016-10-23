function main(inputs)


%% GUI inputs
version = inputs.version;
station = inputs.station;
ip_address = inputs.ip_address;
ports_combination = inputs.ports;
save_data_checkbox = inputs.save_data;
check_ports = inputs.test_ports;

%% setup

run_sim = true;
if(check_ports)
   run_sim = test_ports(version, station, ip_address, ports_combination);
end

%% TODO !!!!!!!!!! Create printer class for print === End ===, === Start ===, etc..

in_sample_time = '0.001';
out_sample_time = '0.01';

block_names = {'udp_in_delay_A'; 'udp_out_delay_A';...
               'udp_in_system_A'; 'udp_out_system_A';...
               'udp_in_delay_B'; 'udp_out_delay_B';...
               'udp_in_system_B'; 'udp_out_system_B'};

%% simulation

if(run_sim)
    model_name = strcat(station, '_', version);
    
    configure_parameters(block_names, model_name,...
                         ip_address, ports_combination,...
                         station, in_sample_time, out_sample_time);
         
    % sim_run = evalin('base', 'sim_run');
    % sim(model_name, [0 sim_run]);

    % ,'SimulationMode','accelerator'); % not a big difference                 
                     
    fprintf('\t=== Start of simulation ===\n');
    % simulation time - from GUI base workspace -> 'sim_run'
    sim_out = sim(model_name, 'ReturnWorkspaceOutputs','on');
    fprintf('\t=== End of simulation ===\n'); 
end

%% save data - optional 
if(run_sim && save_data_checkbox) 
    path = save_measured_data(sim_out);
    plot_data(path);
end;

fprintf('\n\t=== End ===\n');

end

