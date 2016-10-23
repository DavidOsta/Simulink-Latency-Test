function [delay_data, response_data] = load_files(path)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

data_path = sprintf('measured_data/%s/measured_data',path);
data = load(data_path);
data_field = fieldnames(data);
field = data_field{1};

% delay
ref_signal = data.(field).delay_ref;
A_signal = data.(field).delay_A;
B_signal = data.(field).delay_B;

if(~isempty(ref_signal))
    delay_data = struct('ref_signal', ref_signal,...
                        'A_signal', A_signal,...
                        'B_signal', B_signal);
else
    delay_data = [];
end

% response
A_response = data.(field).response_A;
B_response = data.(field).response_B;

if(~isempty(A_response))
    response_data = struct('A_response', A_response,...
                           'B_response', B_response);
else
    response_data = [];
end

end

