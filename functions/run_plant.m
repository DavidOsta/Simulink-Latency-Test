function run_plant( remote_ip, model_name )
%RUN_PLANT Summary of this function goes here
%   Main script for plant (Prague)


%% Simulink Warmup
% Just for the first run on slower PCs
% maybe load function instead?
fprintf('\n\tStart of simulink warmup\n');
sim_time = evalin('base', 'sim_warmup');
sim(model_name, [0 sim_time]); %,'SimulationMode','accelerator');

fprintf('\n\tEnd of simulink warmup\n');


%% Connection hand-shake
% timeout = 120;
% fprintf('\n\tTrying to connect. Timeout in %d (sec)\n', timeout);
% success = udp_handshake_PRG(remote_ip, timeout);

%if(success)
%     fprintf('\n\tConnection to ''%s'' established\n', remote_ip);

    % run simulink model
fprintf('\n\tStart of simulation\n');
sim_time = evalin('base', 'sim_run');
sim(model_name, [0 sim_time]); % ,'SimulationMode','accelerator'); % not a big difference

fprintf('\n\tEnd of simulation\n');

% save data
curr_time_folder = strrep(datestr(now), ':', ';');
new_dir = sprintf('measured_data/%s', curr_time_folder); % because of windows10
mkdir(new_dir);
save_path = sprintf('%s/latency_data',new_dir);
save(save_path, 'plant_response_A','plant_response_B');
             
%else
 %   fprintf('\n\tConnection to ''%s'' failed\n', remote_ip);
%end

end

