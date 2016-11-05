packets_ts = data_struct.packets;

packets = packets_ts.Data(packets_ts.Data > 0);

plot(packets)

[uniq_packets,indx,uniq_indx] = unique(packets);

len_packets = length(packets);
len_uniq_packets = length(uniq_packets);

lost_packets = len_packets - len_uniq_packets;

lost_percent = (lost_packets / len_packets) * 100