function [] = configure_parameters(name_of_simulink_model, decimal_ip,...
                                   location, in_sample_time, out_sample_time)

%% Info
%  used only in main scripts 'main_PRG', 'main_BOS'

%% Plant Configuration
% name of simulink model
open(name_of_simulink_model);
sim_model = strcat(name_of_simulink_model,'/'); % 'plant_PRG/';

%% Define Parameters
% select ports
[ports_A, ports_B] = get_ports(location);

%% Input/Output blocks


%% Setting blocks
%% config A


%% blocks
%----------------------------- A -----------------------------------------------
udp_in_delay_A = get_block_struct(strcat(sim_model, 'udp_in_delay_A'),...
                                  decimal_ip, ports_A.in_delay,...
                                  in_sample_time);
                    
udp_out_delay_A = get_block_struct(strcat(sim_model, 'udp_out_delay_A'),...
                                   decimal_ip,ports_A.out_delay,...
                                   out_sample_time);

udp_in_system_A = get_block_struct(strcat(sim_model, 'udp_in_system_A'),...
                                   decimal_ip, ports_A.in_system,...
                                   in_sample_time);
                    
udp_out_system_A = get_block_struct(strcat(sim_model, 'udp_out_system_A'),...
                                    decimal_ip, ports_A.out_system,...
                                    out_sample_time);      
%----------------------------- B -----------------------------------------------
udp_in_delay_B = get_block_struct(strcat(sim_model, 'udp_in_delay_B'),...
                                  decimal_ip, ports_B.in_delay,...
                                  in_sample_time);
                    
udp_out_delay_B = get_block_struct(strcat(sim_model, 'udp_out_delay_B'),...
                                   decimal_ip, ports_B.out_delay,'none'); 

udp_in_system_B = get_block_struct(strcat(sim_model, 'udp_in_system_B'),...
                                   decimal_ip, ports_B.in_system,...
                                   in_sample_time);
                    
udp_out_system_B = get_block_struct(strcat(sim_model, 'udp_out_system_B'),...
                                    decimal_ip, ports_B.out_system, 'none');
% array of blocks
blocks = [udp_in_delay_A, udp_out_delay_A, udp_in_system_A, udp_out_system_A,...
          udp_in_delay_B, udp_out_delay_B, udp_in_system_B, udp_out_system_B];
    
% setup parameters
for b = blocks
    set_udp_block(b);
end

end
                
% TODO - Solver Config -> Euler - fixed step 0.001