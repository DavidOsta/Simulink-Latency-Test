%% Main script for plant (Prague)

%% Add ip address of remote pc, e.g. '147.0.0.0'
remote_ip = '147.32.183.2'; % << UPDATE THIS

%% uncomment / comment according to your matlab version
% model_name = 'plant_2013B';
% model_name = 'plant_2014B'; 
model_name = 'plant_2015B';

%% set configuration parameters and run simulink model
addpath('functions', 'sim_models');

zh_step = 0.01; % global for all ZOH
in_sample_time = '0.001';
out_sample_time = '0.01';
configure_parameters(model_name, remote_ip, 'PRG',...
                     in_sample_time, out_sample_time);




%% Simulink Warmup
% Just for the first run on slower PCs
% maybe load function instead?
fprintf('\n\tStart of simulink warmup\n');
sim_time = 1;
sim(model_name); %,'SimulationMode','accelerator');
fprintf('\n\tEnd of simulink warmup\n');


%% Connection hand-shake
timeout = 120;
fprintf('\n\tTrying to connect. Timeout in %d (sec)\n', timeout);
success = udp_handshake_PRG(remote_ip, timeout);

if(success)
    fprintf('\n\tConnection to ''%s'' established\n', remote_ip);

    % run simulink model
    fprintf('\n\tStart of simulation\n');
    sim_time = 100;
    sim(model_name); % ,'SimulationMode','accelerator'); % not a big difference

    fprintf('\n\tEnd of simulation\n');
else
    fprintf('\n\tConnection to ''%s'' failed\n', remote_ip);
end
