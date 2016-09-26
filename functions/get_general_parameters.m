function [ device_name, miss_ticks, packet_size] = get_general_parameters()
% Setting parameters valid for both models (PRG/BOS)

device_name = 'Standard_Devices/UDP_Protocol';
miss_ticks = 'inf';
packet_size = '8'; % or '32/4'

end

