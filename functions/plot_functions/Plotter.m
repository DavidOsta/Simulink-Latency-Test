classdef Plotter
    %PLOTER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties(Access = private)
        plant = 'plant';
        controller = 'controller';
        delay = 'delay';
        sim = 'sim';
        real = 'real';
        
        root_folder = 'measured_data';

    end
    
    properties(Access = public)
        folder_path;
        model_name;
        station_name;
        file_names;
    end
    
    methods
        % Constructor
        function obj = Plotter(path)
            if nargin > 0
                obj.folder_path = strcat(obj.root_folder, '/', path);
                obj.model_name = obj.extract_model_name(path);
                obj.station_name = obj.extract_station_name(path);
                
                obj.create_figure(path);
                obj.file_names = obj.get_file_names();
                
                switch obj.model_name
                    case obj.delay
                        obj.plot_delay();
                    case obj.sim
                        obj.plot_sim_reponse()
                    case obj.real
                        fprintf('to be implemented');
                    otherwise
                        error('wrong file name');
                end
                
            else
                error('constructor argument is missing')
            end
        end
        
    end
    
    % Private methods
    methods(Access = private)
        function m_name = extract_model_name(obj, path)
            if(~isempty(strfind(path, obj.delay)))
                m_name = obj.delay;
            elseif(~isempty(strfind(path, obj.real)))
                m_name = obj.real;
            else
                m_name = obj.sim;
            end
        end
        
        function s_name = extract_station_name(obj, path)
            
            if(~isempty(strfind(path, obj.plant) > 0))
                s_name = obj.plant;
            elseif(~isempty(strfind(path, obj.controller) > 0))
                s_name = obj.controller;
            else
                error(sprintf('Invalid station name in file "%s"',path));
            end
        end
        
        function create_figure(obj, path)
            fig_name = strcat(path, sprintf(' - %s', obj.model_name));
            figure('Name',fig_name,'NumberTitle','off');
        end
        
        function file_names = get_file_names(obj)
            file_struct = dir(fullfile(obj.folder_path,'*.mat'));
            file_names = {file_struct.name};
        end
        
        function data = load_data(obj, file_name)
            file_path = strcat(obj.folder_path,'/',file_name);
            data = load(file_path); % load to struct
        end
        
        function plot_plant_resp(obj)
            % plot for plant station
            hndl_response = subplot(1,1,1); grid on; hold on;
            obj.setup_labels(hndl_response,'Plant response - y',...
                '$time \: (s)$',...
                '$cart \: position (m)$');
            for k = 1:length(obj.file_names)
                file_name = obj.file_names{k};
                data = obj.load_data(file_name);
                plot(hndl_response, data.ws_response.Time, data.ws_response.Data,...
                    'LineWidth', 1.5);
            end
        end
        
        function plot_controller_resp(obj)
            
            hndl_response = subplot(2,1, 1); grid on; hold on;
            obj.setup_labels(hndl_response,'Plant response - y',...
                '$time \: (s)$',...
                '$cart \: position (m)$');
            legend(hndl_response, 'config A', 'config B');
            
            hndl_delay = subplot(2,1,2); grid on; hold on;
            obj.setup_labels(hndl_delay,'Delay during simulation',...
                '$simulation time \: (s)$',...
                '$delay \: (ms)$');
            legend('config A', 'config B');
            
            for k = 1:length(obj.file_names)
                
                file_name = obj.file_names{k};
                
                data = obj.load_data(file_name);
                
                plot(hndl_response, data.ws_response.Time, data.ws_response.Data,...
                    'LineWidth', 1.5);hold on
                
                plot(hndl_delay, data.ws_delay_rt.Time, data.ws_delay_rt.Data,...
                    'LineWidth', 1.5);hold on
            end
            
        end
        
        function setup_labels(obj, handle, title_label, x_label, y_label )
            %SETUP_LABELS Summary of this function goes here
            %   Detailed explanation goes here
            
            xlabel(handle, x_label, 'interpreter', 'latex','FontSize', 15);
            ylabel(handle, y_label, 'interpreter', 'latex','FontSize', 15);
            title(handle, title_label,'FontSize', 15);
end
    end
    
    methods(Access = public)
        
        function plot_delay(obj)
            %PLOT_DELAY Summary of this function goes here
            %   Detailed explanation goes here
            
            file_name = obj.file_names{1}; % only one files
            data = obj.load_data(file_name);
            
            
            %% Processing
            
            ref_signal = data.ws_delay_ref;
            delay_signal = data.ws_delay;
            delay_rt = data.ws_delay_rt;
            
            measured_delay = process_delay(ref_signal, delay_signal);
            delay_of_ref_signal = measured_delay.delay;
            
            
            %% Visualization
            latency = subplot(3,1, 1); grid on; hold on;
            delay_real_time = subplot(3,1,2); hold on;
            histo = subplot(3,1,3); hold on;
            
            % plot colors
            color_A = [0.8500,0.3250,0.0980];
            color_B = [0, 0.4470, 0.7410];
            
            % subplot 1st row -  latency
            time = 1:1:length(delay_of_ref_signal);
            
            % time_len = 1:0.001:10000;
            upper_bound = inf;%150; % turn off later
            lower_bound = 0;
            delay_filtered =...
                delay_of_ref_signal(upper_bound > delay_of_ref_signal &...
                delay_of_ref_signal > lower_bound);
            
            
            time = 1:1:length(delay_of_ref_signal);
            for k = 1:length(delay_of_ref_signal)
                tick = delay_of_ref_signal(k);
                if tick > lower_bound && tick <upper_bound % missed tick
                    m = 'o';
                    B_tick_ok = plot(latency, time(k), tick, m, 'LineWidth',1.5,...
                        'MarkerSize',5,...
                        'Color', color_B);
                end
            end
            obj.setup_labels(latency,'Delay from sim results',...
                '$time \: (s)$',...
                '$delay \: (ms)$');
            
            % subplot 2nd row  -  Histogram
            [num, version_year] = version;
            bin_method = 'auto'; % The Freedman-Diaconis rule
            
            measured_mean = mean(delay_filtered);
            measured_std = std(delay_filtered);
            
            if(str2double(version_year(end-4:end)) >= 2014)
                histogram(histo, delay_filtered,...
                    'FaceColor', color_B,...
                    'BinMethod', bin_method);
                %               %'BinWidth', 10);
                
            else
                hist(histo, delay_filtered, 'FaceColor', color_B);%, 'b');
            end
            % set(histo,'xtick',[80:1:200]); grid on
            
            obj.setup_labels(histo,'Delay histogram',...
                '$delay \: (msec)$',...
                '$frequency \: (1)$');
            
            annotation('textbox','Position',[.8 .85 .1 .05],...
                'String',{sprintf('mean : %f [msec]', measured_mean),...
                sprintf('std : %f [msec]', measured_std)});
            
            
            % real-time delay
            plot(delay_real_time, delay_rt.Time, delay_rt.Data,...
                'LineWidth', 1.5, 'Color', color_B);
            
            obj.setup_labels(delay_real_time,'Delay measured during simulation',...
                '$time \: (s)$',...
                '$delay \: (ms)$');
            % Lost packets
            packets_ts = data.ws_packets;
            packets = packets_ts.Data(packets_ts.Data > 0);
            figure
            plot(packets)
            
            [uniq_packets,indx,uniq_indx] = unique(packets);
            
            len_packets = length(packets);
            len_uniq_packets = length(uniq_packets);
            
            lost_packets = len_packets - len_uniq_packets;
            lost_percent = (lost_packets / len_packets) * 100;
            
            fprintf('\t\n%.2f percent of lost packets\n', lost_percent);
            
            
        end
        
        function plot_sim_reponse(obj)
            if(strcmp(obj.plant, obj.station_name))
                obj.plot_plant_resp();
            else
                obj.plot_controller_resp();
            end
        end
              
    end
    
end

