function [delay_data, response_data] = load_files(path)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

data_path = sprintf('measured_data/%s/measured_data',path);
data = load(data_path);
data_field = fieldnames(data);
field = data_field{1};

% delay
ref_signal = data.(field).delay_ref;
B_signal = data.(field).delay_B;

packets = data.(field).packets;

if(~isempty(ref_signal))
    delay_data = struct('ref_signal', ref_signal,...
                        'B_signal', B_signal,...
                        'packets', packets);
else
    delay_data = [];
end

% response
% A_response = data.(field).response_A;
B_response = data.(field).response_B;

if(~isempty(B_response))
    response_data = struct('B_response', B_response); %,...
%                            'A_response', A_response);
else
    response_data = [];
end

end

