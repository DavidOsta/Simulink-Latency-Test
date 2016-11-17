classdef Plotter
    %PLOTER Summary of this class goes here
    %   Detailed explanation goes here

    properties(Access = private)
        plant = 'plant';
        controller = 'controller';
        test = 'test';
        sim = 'sim';
        real = 'real';
        root_folder = 'measured_data';
    end

    properties(Access = public)
        folder_path;
        model_name;
        station_name;
        path;
        file_name;
    end

    methods
        % Constructor
        function this = Plotter(path)
            if nargin > 0
                this.path = path;
                this.folder_path = strcat(this.root_folder, '/', this.path);
                this.model_name = this.extract_model_name();
                this.station_name = this.extract_station_name();
                this.file_name = this.set_file_name();
                
            else
                error('constructor argument is missing')
            end
        end

    end

    % Private methods
    methods(Access = private)
        function m_name = extract_model_name(this)
            if(~isempty(strfind(this.path, this.test)))
                m_name = this.test;
            elseif(~isempty(strfind(this.path, this.real)))
                m_name = this.real;
            else
                m_name = this.sim;
            end
        end

        function s_name = extract_station_name(this)

            if(~isempty(strfind(this.path, this.plant) > 0))
                s_name = this.plant;
            elseif(~isempty(strfind(this.path, this.controller) > 0))
                s_name = this.controller;
            else
                error(sprintf('Invalid station name in file "%s"',path));
            end
        end

        function create_figure(this, sufix)
            fig_name = strcat(this.path,'-', sufix);
            figure('Name',fig_name,'NumberTitle','off');
        end

        function file_name = set_file_name(this)
            file_struct = dir(fullfile(this.folder_path,'*.mat'));
            file_name = file_struct.name;
        end

        function data = load_data(this, file_name)
            file_path = strcat(this.folder_path,'/',file_name);
            data = load(file_path); % load to struct
        end


    end

    methods(Access = public)

        function plot(this)
            data = this.load_data(this.file_name);
            fields = fieldnames(data);
            
            if(find(ismember(fields, 'ws_delay')))
                this.create_figure('delay');
                plot_delay(data.ws_delay);
            end
            
            if(find(ismember(fields, 'ws_response')))
                this.create_figure('response');
                plot_response(data.ws_response);
            end      
          
        end

    end

end
