function [ success ] = udp_handshake_PRG( remote_ip_address, timeout )

%   To check whether connection between PCs has been established
%   Note: I wanted to use TCP protocol but, I do not have
%   Instr_Control_Toolbox.

port_bos = 45000;
port_prg = 35000;

sender = dsp.UDPSender('RemoteIPAddress', remote_ip_address,...
                       'RemoteIPPort', port_bos);

receiver = dsp.UDPReceiver('RemoteIPAddress', remote_ip_address,...
                           'LocalIPPort', port_prg,...
                           'MessageDataType', 'logical');

response = true;
msg_count = 0;

tic;
while(toc < timeout && msg_count < 2)
    
   % listen on the port 
   if(step(receiver)) % sending boolean
       msg_count = msg_count + 1;
       %fprintf('Connection #%d \n',msg_count);
       step(sender, response);
   end
   
   if(msg_count == 2)
       for(i = 1:100) % UDP just for sure
            step(sender, response);
       end
   end
end

% release sockets
release(sender);
release(receiver);

% return
if(msg_count == 2)
    success = true;
else
    success = false;
end


