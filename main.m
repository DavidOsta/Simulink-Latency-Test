function main(ip_address, version, ports, station )


in_sample_time = '0.001';
out_sample_time = '0.01';

if(strcmp(station,'plant'))
    model_name = strcat('plant_', version);
    
    configure_parameters(model_name, ip_address, ports,...
                         'plant', in_sample_time, out_sample_time);
                     
    run_plant(ip_address, model_name);
          
else % controller
    model_name = strcat('controller_', version);
    configure_parameters(model_name, ip_address, ports,...
                         'controller', in_sample_time, out_sample_time);
    results = run_controller(ip_address, model_name);
    
    % plot results
    % plot_data(results);
end


end

