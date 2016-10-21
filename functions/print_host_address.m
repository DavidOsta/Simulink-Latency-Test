function  print_host_address()
%PRINT_HOST_ADDRESS Summary of this function goes here
%   Detailed explanation goes here
fprintf('%s \n',char(java.net.InetAddress.getLocalHost.getHostAddress))
end

