function test_delay_callback(inputs, handles)
%TEST_DELAY Summary of this function goes here
%   Detailed explanation goes here

% GUI inputs
version = inputs.version;
station = inputs.station;
ip_address = inputs.ip_address;
ports_combination = inputs.ports;
save_data_checkbox = inputs.save_data;
check_ports = inputs.test_ports;

in_sample_time = gui_inputs.packet_in_rate;
out_sample_time = gui_inputs.packet_out_rate;

model_name = strcat('delay_', station,'_', version);
% open model to get list of blocks and be able to configure them
open(model_name);

%% Setup blocks

regex_pattern = '^udp'; % all blocks for udp communication
list_of_blocks = get_list_of_blocks(model_name, regex_pattern);


% in_sample_time = '0.0001';
% out_sample_time = '0.001';

% in_sample_time = '0.001';
% out_sample_time = '0.01';

configure_parameters(list_of_blocks,ip_address,...
    ports_combination,station,...
    in_sample_time, out_sample_time);

%% Simulation
run_sim = true;
if(check_ports)
    run_sim = test_ports(version, station, ip_address, ports_combination);
end

if(run_sim)
    
    printer = Printer(); % Instantiate an object of class Printer
    
    printer.print_sim_start;
    
    sim_out = sim(model_name, 'ReturnWorkspaceOutputs','on');
    
    printer.print_sim_end;
    
    if(save_data_checkbox)
        
        root_folder = 'measured_data';
        folder_name = create_folder(root_folder, model_name);
        save_measured_data(model_name,...
            folder_name,...
            root_folder,...
            sim_out);
        
        Plotter(folder_name);
        %         plot_data(folder_name);
        printer.print_save_result(folder_name);
        update_gui_listbox(handles);
    end;
    
    printer.print_end;
    
end
end
