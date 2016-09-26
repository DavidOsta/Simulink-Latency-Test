function [ success ] = udp_handshake_BOS( remote_ip_address, timeout )

%   To check whether connection between PCs has been established
%   Note: I wanted to use TCP protocol but, I do not have
%   Instr_Control_Toolbox.


port_bos = 45000;
port_prg = 35000;

sender = dsp.UDPSender('RemoteIPAddress', remote_ip_address,...
                       'RemoteIPPort', port_prg);

receiver = dsp.UDPReceiver('RemoteIPAddress', remote_ip_address,...
                           'LocalIPPort', port_bos,...
                           'MessageDataType', 'logical');


msg = true;
msg_count = 0;

tic;
while(toc < timeout && msg_count < 2)
   step(sender, msg);
   if(step(receiver)) % response - boolean
       msg_count = msg_count + 1;
       %fprintf('Message received #%d \n',msg_count); % Debug
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


