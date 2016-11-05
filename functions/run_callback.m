function run_callback(gui_inputs,handles)


%% GUI inputs
version = gui_inputs.version;
station = gui_inputs.station;
ip_address = gui_inputs.ip_address;
ports_combination = gui_inputs.ports;
save_data_checkbox = gui_inputs.save_data;
check_ports = gui_inputs.test_ports;
    
in_sample_time = gui_inputs.packet_in_rate;
out_sample_time = gui_inputs.packet_out_rate;

%% setup

run_sim = true;
if(check_ports)
   run_sim = test_ports(version, station, ip_address, ports_combination);
end

%% TODO !!!!!!!!!! Create printer class for print === End ===, === Start ===, etc..

%% simulation

if(run_sim)

    % sim_run = evalin('base', 'sim_run');
    % sim(model_name, [0 sim_run]);
    % ,'SimulationMode','accelerator'); % not a big difference
    
%     in_sample_time = '0.001';
%     out_sample_time = '0.01';

    printer = Printer(); % Instantiate an object of class Printer 
    
    
    printer.print_sim_start;
    
    model_name = strcat(station, '_', version);
    sim_out = start_simulation(gui_inputs, model_name,...
                               in_sample_time, out_sample_time);
                           
    printer.print_sim_end;

    % Configuration UDP send blocks
%     fprintf('\t=== Start of simulation config B ===\n');
%     
%     model_name_B = strcat(station, 'B_', version);
%     sim_out_B = start_simulation(gui_inputs, model_name_B,...
%                                  in_sample_time, out_sample_time);
%     fprintf('\t=== End of simulation ===\n');

    
    
    if(save_data_checkbox)
        
        root_folder = 'measured_data';
        folder_name = create_folder(root_folder, model_name);
        save_measured_data(model_name,...
                         folder_name,...
                         root_folder,...
                         sim_out);
                                         
%         save_measured_data(model_name_B,...
%                           folder_name,...
%                           root_folder,...
%                           sim_out_B);
        
        printer.print_save_result(folder_name);

        Plotter(folder_name);
%         plot_data(folder_name);
        update_gui_listbox(handles);
    end;
        
    printer.print_end;
end

end
