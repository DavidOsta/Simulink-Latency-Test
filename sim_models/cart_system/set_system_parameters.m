function [g,m1,T1,f_1s,f_1k,m2,l,f_2k,M_sp,f_1k_lin,f_2k_lin,k1,k2] =...
    set_system_parameters()

%SET_SYSTEM_PARAMETERS Summary of this function goes here
%   Detailed explanation goes here


g = 9.81; % [m.s^-2] grav. acceleration
%cart
m1 = 1.6; % [kg] cart 1
T1 = 2.5;  %[N] - approx. force required to move cart 1 at const. velocity >> friction

f_1s = T1 / (m1 * g); % [N.s.m^-1] -  Static friction between cart1 and framework + belt resistance (odpor remene)!!!
f_1k = f_1s * 0.9; % [N.s.m^-1] - Kinetic friction -  odhad byva mensi nez Coulombovo staticke

%pendulum
m2 = 55/1000; % [kg] pendulum
l_physical = 0.7; %[m] - length of pendulum
l = 2/3 * l_physical; %[m] - reduced pendulum length
f_2k = 0.0062586; %[N.s.m^-1] - pendulum damping
M_sp = 0.0065; % [N.m] - static friction moment


% parameters for linearized model
f_1k_lin = 8; % 5.5
f_2k_lin = 0.01;% 0.015

k1 = -200;
k2 = -5;
end

