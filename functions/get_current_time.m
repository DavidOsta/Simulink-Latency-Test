function [ current_time ] = get_current_time( )
%get_current_time Summary of this function goes here
%   Function for packet delay identification via simulink models

    current_time = str2double(datestr(now,'HHMMssFFF'));
end

