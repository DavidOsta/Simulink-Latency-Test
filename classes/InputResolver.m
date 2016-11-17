classdef InputResolver < handle % making a handle superclass
    %INPUTRESOLVER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties(Access = private)
        handles;
        ip_address;
        version;
        ports;
        station;
        save_data;
        test_ports;
        packet_in_rate;
        packet_out_rate;
        zh_step;
        configuration;
        
        model_type; % simulation 'sim',
        % connection test - 'test',
        % real run - 'real'
        model_name;
        sim_out;
        folder_name
    end
    
    methods(Access = public)
        % Constructor
        function this = InputResolver(handles, model_type)
            if nargin > 0
                this.handles = handles;
                this.model_type = model_type;
                this.check_ip_address();
                this.set_ports();
                this.set_version();
                this.set_station();
                this.set_save_data();
                this.set_packet_rates();
                this.set_configuration();
                this.set_model_name();
            else
                error('constructor argument is missing')
            end
        end
        
        function run_simulink_model(this)
            load_system(this.model_name);
            % load scope windows
            open_system(strcat(this.model_name, '/', 'scope'));
            
            list_of_blocks =...
                this.get_list_of_simulink_blocks(this.model_name, '^udp'); % regex patern
            this.configure_parameters(list_of_blocks);
            this.sim_out = sim(this.model_name, 'ReturnWorkspaceOutputs','on');
            
            if(this.save_data)% if true
                this.save_simulink_results();
                update_gui_listbox(this.handles);
                plotter = Plotter(this.folder_name);
                plotter.plot();
            end;
            
        end
        
        function success = test_ports_connection(this)
            % TODO - break it to smaller functions
            test_model_name = strcat('port_test_', this.configuration,...
                '_', this.version);
            load_system(test_model_name);
            
            list_of_blocks =...
                this.get_list_of_simulink_blocks(test_model_name, '^udp'); % regex patern
            this.configure_parameters(list_of_blocks);
            
            % set name of workspace blocks
            if(strcmp(this.configuration, 'A'))
                set_param(strcat(test_model_name,'/','port_udp_in_system'),'VariableName',...
                    strcat('port_',get_param(strcat(test_model_name,'/','udp_in_system'), 'DrvAddress')));
            else % B
                set_param(strcat(test_model_name,'/','port_udp_in_delay'),'VariableName',...
                    strcat('port_',get_param(strcat(test_model_name,'/','udp_in_delay'), 'localPort')));
                set_param(strcat(test_model_name,'/','port_udp_in_system'),'VariableName',...
                    strcat('port_',get_param(strcat(test_model_name,'/','udp_in_system'), 'localPort')));
            end
            
            % run test
            test_sim_out = sim(test_model_name, 'ReturnWorkspaceOutputs','on');
            
            data_names_ws = test_sim_out.get; % workspace names
            data_names_ws = data_names_ws(1:end-1); % drop tout
            
            fprintf('\n\t=== Testing connection ports ===\n');
            % evaluate test
            success = true; % if any port fails => change to false, otherwise keep true
            for k = 1:length(data_names_ws)
                name_ws = data_names_ws{k};
                if(isempty(find(test_sim_out.get(name_ws).Data > 0, 1)))
                    fprintf('\n\tConnection to ''%s'' failed\n', name_ws);
                    success = false;
                else
                    fprintf('\n\tConnection to ''%s'' succeed\n', name_ws);
                end
            end
            
            if(~success)
                fprintf(['\n\tConnection test failed, try different port combination\n' ...
                    '\tor setup new boards\n']);
            end
            fprintf('\n\t=== End of ports'' test ===\n');
            
        end
        
        
        function ip_address = get_ip_address(this)
            ip_address = this.ip_address;
        end
        
        function ports = get_ports(this)
            ports = this.ports;
        end
        
        function station = get_station(this)
            station = this.station;
        end
        
        function save_data = get_save_data(this)
            save_data = this.save_data;
        end
        
        function packet_in_rate=get_in_packet_rate(this)
            packet_in_rate = this.packet_in_rate;
        end
        
        function packet_out_rate=get_out_packet_rate(this)
            packet_out_rate = this.packet_out_rate;
        end
        
        function zh_step=get_zh_step(this)
            zh_step = this.zh_step;
        end
        
        function configuration=get_configuration(this)
            configuration = this.configuration;
        end
        
        function version = get_version(this)
            version = this.version;
        end
        
        function handles = get_handles(this)
            handles = this.handles;
        end
        
        function folder_name = get_folder_name(this)
            folder_name = this.folder_name;
        end
    end
    
    methods(Access = private)
        
        function check_ip_address(this)
            % resolve - ip addres
            entered_ip_address = get(this.handles.ip_address_edit, 'String');
            % check IP address
            if(regexp(entered_ip_address, '^(?:[0-9]{1,3}\.){3}[0-9]{1,3}$'))
                this.ip_address = entered_ip_address;
            else
                this.ip_address = 'error';
                error('Error. \nEntered IP address, ''%s'' is not valid.',...
                    entered_ip_address)
            end
        end
        
        function set_ports(this)% resolve - ports
            ports_content =  cellstr(get(this.handles.ports_popup, 'String'));
            selected_ports_cell = ports_content(get(this.handles.ports_popup,...
                'Value'));
            this.ports = selected_ports_cell{:}(end);
        end
        
        function set_version(this)% resolve - version
            version_content =  cellstr(get(this.handles.version_popup, 'String'));
            selected_version_cell = version_content(get(this.handles.version_popup,...
                'Value'));
            this.version = selected_version_cell{:};
        end
        
        function set_station(this)% resolve - station
            if(get(this.handles.plant_radio_btn, 'Value') == 1)
                this.station = 'plant';
            else
                this.station = 'controller';
            end;
        end
        
        function set_save_data(this)
            this.save_data = get(this.handles.save_data_checkbox, 'Value');
        end;
        
        function set_packet_rates(this)
            
            this.packet_in_rate = get(this.handles.packet_rec_rate,'String');
            [packet_in_rate_num, in_is_number] = str2num(this.packet_in_rate);
            
            this.packet_out_rate = get(this.handles.packet_send_rate,'String');
            [packet_out_rate_num, out_is_number] = str2num(this.packet_out_rate);
            
            if(~in_is_number)
                error(sprintf('Packet receive rate "%s" is not a number',...
                    this.packet_in_rate));
            elseif(~out_is_number)
                error(sprintf('Packet send rate "%s" is not a number',...
                    this.packet_out_rate));
            else
                this.zh_step = packet_out_rate_num;
            end
        end
        
        function set_configuration(this)
            if(get(this.handles.config_A, 'Value') == 1)
                this.configuration = 'A';
            else
                this.configuration = 'B';
            end;
        end
        
        function set_model_name(this)
            this.model_name = strcat(this.model_type,'_',...
                this.station,'_',...
                this.configuration, '_',...
                this.version);
        end
        
        function udp_block_names = ...
                get_list_of_simulink_blocks(this, simulink_model ,regex_pattern)
            
            udp_block_names =  find_system(simulink_model,...
                'Regexp', 'on',...
                'Name', regex_pattern);
        end
        
        function block_structs = configure_parameters(this, list_of_blocks)
            
            %% Define Parameters
            % select ports
            [selected_ports, ports_diff_config] = this.assign_ports();
            
            num_of_blocks = numel(list_of_blocks);
            % allocate struct
            block_structs(num_of_blocks) = struct('name', [], 'decimal_ip', [],...
                'port', [], 'sample_time', []);
            
            for k = 1:num_of_blocks
                block_name = list_of_blocks{k};
                this.set_udp_block(this.get_block_struct(block_name, selected_ports));
            end
            
        end
        
        function block_struct = get_block_struct(this, block_name, selected_ports)
            %GET_STRUCT_OF_BLOCK Summary of this function goes here
            %   Just helper function for setting up parameters of simulink models
            
            blocks_combination = {'in_delay',...
                'out_delay',...
                'in_system',...
                'out_system'};
            
            port = '';
            sample_time = '';
            
            for k = 1:length(blocks_combination)
                name = blocks_combination{k};
                if(strfind(block_name, name) > 0)
                    port = selected_ports.(name);
                    if(strfind(name, 'in_'))
                        sample_time = this.packet_in_rate;
                    else % out
                        sample_time = this.packet_out_rate;
                    end
                    break; % no need to loop further
                end
            end
            
            block_struct = struct('name', block_name,...
                'port', port,...
                'sample_time', sample_time);
        end
        
        function set_udp_block(this, block)
            % Helper function, set parameters of simulink UDP blocks
            
            % determine block type
            block_name = block.name;
            block_info = libinfo(block_name);
            block_lib = block_info.Library;
            port = block.port;
            
            decimal_ip = this.ip_address;
            
            % set parameters according to block type
            if strcmp(block_lib, 'sldrtlib') || strcmp(block_lib, 'rtwinlib') % real-time libs
                
                device_name = 'Standard_Devices/UDP_Protocol';
                miss_ticks = 'inf';
                integer_ip = convert_ip(decimal_ip);
                ip_and_port = sprintf('[%s %s]', integer_ip, port);
                
                % set_param - simulink's function
                set_param(block_name, 'SampleTime', block.sample_time,...
                    'MaxMissedTicks', miss_ticks,...
                    'DrvName', device_name,...
                    'DrvAddress', port,...
                    'DrvOptions', ip_and_port);%,...
                %                           'PacketSize', packet_size);
                
            elseif strcmp(block_lib, 'dspnetwork')  % dsp lib
                % set
                if(isempty(strfind(block_name, 'in'))) % sending block
                    set_param(block_name, 'remotePort', port, ...
                        'remoteURL' , sprintf('''%s''', decimal_ip));
                else % receiving block
                    set_param(block_name, 'localPort', port, ...
                        'remoteURL' , sprintf('''%s''', decimal_ip),...
                        'sampletime', '0.1');
                end
            else
                fprintf('Block ''%s'' is from invalid library\n', block_name);
            end
            
        end
        
        function save_simulink_results(this)
            
            root_folder = 'measured_data';
            this.folder_name = this.create_folder(root_folder);
            data_names_ws = this.sim_out.get; % workspace names
            
            if(length(data_names_ws) > 1) % something is saved to workspace
                % get workspace data by their names and save them by their names
                for k = 1:length(data_names_ws)
                    name_ws = data_names_ws{k};
                    temp_name = this.sim_out.get(name_ws);
                    eval(sprintf('%s = temp_name;',name_ws)); % i know ...
                end
                
                % save all variables with ws_ (workspace) suffix
                save_path = sprintf('%s/%s/%s', root_folder,...
                    this.folder_name, this.model_name);
                save(save_path, '-regexp', '^ws_');
                
            else
                fprintf('\n\tno data to be stored\n');
            end
        end
        
        function folder_name = create_folder(this,root_folder)
            %CREATE_FOLDER_NAME Summary of this function goes here
            %   Detailed explanation goes here
            current_date = strrep(datestr(now), ':', ';');
            folder_name = strcat(current_date, '-', this.model_name);
            folder_path = sprintf('%s/%s',root_folder, folder_name);
            % because of windows10
            mkdir(folder_path);
        end
        
        function [ ports_A, ports_B ] = assign_ports(this)
            %GET_PORTS Summary of this function goes here
            %   Auxiliary function to set correct ports in simulink models
            %   arg - string of place name, either 'BOS' or 'PRG'
            % TODO REDESIGN
            switch this.ports
                case 'A'
                    % config A
                    port_A1 = '27000';
                    port_A2 = '27500';
                    port_B1 = '28000';
                    port_B2 = '28500';
                    % config B
                    port_C1 = '27010';
                    port_C2 = '27510';
                    port_D1 = '28010';
                    port_D2 = '28510';
                case 'B'
                    % config A
                    port_A1 = '20000';
                    port_A2 = '20500';
                    port_B1 = '21000';
                    port_B2 = '21500';
                    % config B
                    port_C1 = '20010';
                    port_C2 = '20510';
                    port_D1 = '21010';
                    port_D2 = '21510';
                case 'C'
                    % config A
                    port_A1 = '22000';
                    port_A2 = '22500';
                    port_B1 = '23000';
                    port_B2 = '23500';
                    % config B
                    port_C1 = '22010';
                    port_C2 = '22510';
                    port_D1 = '23010';
                    port_D2 = '23510';
                otherwise
                    error('Unexpected ports combination')
            end
            
            
            switch this.station
                case 'controller'
                    % config A
                    ports_A = struct('out_delay', port_A1, 'in_delay', port_B1,...
                        'out_system', port_A2, 'in_system', port_B2);
                    % config B
                    ports_B = struct('out_delay', port_C1, 'in_delay', port_D1,...
                        'out_system', port_C2, 'in_system', port_D2);
                case 'plant'
                    % config A
                    ports_A = struct('out_delay', port_B1, 'in_delay', port_A1,...
                        'out_system', port_B2, 'in_system', port_A2);
                    % config B
                    ports_B = struct('out_delay', port_D1, 'in_delay', port_C1,...
                        'out_system', port_D2, 'in_system', port_C2);
                otherwise
                    error('Invalid place argument')
            end
        end
    end
end