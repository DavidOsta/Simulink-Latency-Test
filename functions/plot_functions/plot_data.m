function plot_data(path)
%HELPER Summary of this function goes here
%   Detailed explanation goes here

[delay_data, response_data] = load_files(path);

% [delay_data, response_data] = filter_files(get_filenames(path));
resp_is_empty = isempty(response_data);
delay_is_empty = isempty(delay_data);

if(resp_is_empty && delay_is_empty)
    fprintf('\tthere are no data to plot\n');
elseif(resp_is_empty)
    plot_delay(delay_data);
elseif(delay_is_empty)
    plot_response(response_data);
else % plot both
    plot_all(delay_data, response_data);
end

end

