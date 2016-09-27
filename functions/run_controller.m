function [curr_time_folder] = run_controller( remote_ip, model_name)
%RUN_CONTROLLER Summary of this function goes here
%   Run sim model of controller


%% Simulink Warmup
% This is just for synchronization purpose (one PC might be very slow)
% I am sure that there is a better way how to do it :)
warning('off','Simulink:Engine:OutputNotConnected');
fprintf('\n\tStart of simulink warmup\n');

sim_time = evalin('base', 'sim_warmup');
sim(model_name, [0 sim_time]);

fprintf('\n\tEnd of simulink warmup\n');

%% Connection hand-shake
timeout = 120; % 120 seconds
fprintf('\n\tTrying to connect. Timeout in %d (sec)', timeout);
success = udp_handshake_BOS(remote_ip, timeout);

if(success)
    fprintf('\n\tConnection to ''%s'' established\n', remote_ip);

    % run simulink model
    %java.lang.Thread.sleep(1000); %sec pause to run plant first, maybe needless

    fprintf('\n\tStart of simulation\n');
    
    sim_time = evalin('base', 'sim_run');
    sim(model_name, [0 sim_time]);



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

else
    fprintf('\n\tConnection to ''%s'' failed\n', remote_ip);
end

end

