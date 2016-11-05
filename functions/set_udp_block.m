function [] = set_udp_block(block)                
% Helper function, set parameters of simulink UDP blocks

% determine block type
block_name = block.name;
block_info = libinfo(block_name);
block_lib = block_info.Library;

decimal_ip = block.decimal_ip;
port = block.port;
            
% set parameters according to block type
if strcmp(block_lib, 'sldrtlib') || strcmp(block_lib, 'rtwinlib') % real-time libs
    % load general parametrs
    [device_name, miss_ticks, packet_size] = get_general_parameters();
    
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

