%% Main script for controller (Boston)

%% Add ip address of remote pc, e.g. '147.0.0.0'
remote_ip = '147.32.183.4'; % << replace it

%% uncomment / comment according to your matlab version
% model_name = 'controller_2013B';
% model_name = 'controller_2014B';
model_name = 'controller_2015B';

%% set configuration parameters and run simulink model
addpath('functions', 'sim_models');


zh_step = 0.01; % global for all ZOH
% configure sim model parameters
in_sample_time = '0.001';
out_sample_time = '0.01';
configure_parameters(model_name, remote_ip, 'BOS',...
                     in_sample_time, out_sample_time);

%% Simulink Warmup
% Just for 1st run on slower PCs
warning('off','Simulink:Engine:OutputNotConnected');
fprintf('\n\tStart of simulink warmup\n');
sim_time = 1;
sim(model_name);%'SimulationMode','accelerator', 'SaveOutput', 'on',...
        %'OutputSaveName', 'lool');
fprintf('\n\tEnd of simulink warmup\n');

%% Connection hand-shake
timeout = 120; % 120 seconds
fprintf('\n\tTrying to connect. Timeout in %d (sec)', timeout);
success = udp_handshake_BOS(remote_ip, timeout);

if(success)
    fprintf('\n\tConnection to ''%s'' established\n', remote_ip);

    % run simulink model
    java.lang.Thread.sleep(1000); %sec pause to run plant first, maybe needless

    fprintf('\n\tStart of simulation\n');
    sim_time = 100;
    sim(model_name); %,'SimulationMode','accelerator');


    % save data
    curr_time_folder = strrep(datestr(now), ':', ';');
    new_dir = sprintf('measured_data/%s', curr_time_folder); % because of windows10
    mkdir(new_dir);
    save_path = sprintf('%s/latency_data',new_dir);
    save(save_path, 'ref_signal',...
                     'delayed_signal_A', 'delayed_signal_B',...
                     'delayed_signal_runtime_A', 'delayed_signal_runtime_B',...
                     'plant_response_A', 'plant_response_B');

    fprintf('\n\tEnd of simulation\n');
    % plot results
    % process_and_plot_data(save_path);
    process_and_plot_data(curr_time_folder);
else
    fprintf('\n\tConnection to ''%s'' failed\n', remote_ip);
end
