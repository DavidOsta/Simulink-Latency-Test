function [ transformed_ip ] = convert_ip( decimal_ip )
%   CONVERT_IP 
%   Convert IP Address in dotted decimal notation ('147.3.1.1')
%   Into an integer notation (2466447617)
%   arg - '147.3.1.1' (String)
%   ret - 2466447617 (Double)

decimals = str2double(strsplit(decimal_ip, '.'));

b = 256; % base number
integer_ip  = decimals(1) * b^3 +...
              decimals(2) * b^2 +...
              decimals(3) * b^1 +...
              decimals(4) * b^0 ;
          
 transformed_ip = num2str(integer_ip);
end

