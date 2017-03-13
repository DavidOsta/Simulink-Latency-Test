clear;clc

%% Plot trace route from prague to boston

% Tracing route to neu-re-nox1sumgw1.nox.org [207.210.143.102]
% over a maximum of 18 hops:
% 
%   1    <1 ms    <1 ms    <1 ms  cat6506r.fsid.cvut.cz [147.32.160.1]
%   2     2 ms    11 ms    <1 ms  147.32.252.51
%   3     1 ms    <1 ms     1 ms  cvut-r92.cesnet.cz [195.113.144.173]
%   4     1 ms     2 ms     2 ms  195.113.235.89
%   5    <1 ms    <1 ms    <1 ms  cesnet.mx1.pra.cz.geant.net [62.40.124.29]
%   6     7 ms     7 ms     7 ms  ae9.mx1.fra.dk.geant.net [62.40.98.75]
%   7    15 ms    15 ms    15 ms  ae1.mx1.gen.ch.geant.net [62.40.98.108]
%   8    22 ms    22 ms    22 ms  ae4.mx1.par.fr.geant.net [62.40.98.152]
%   9    92 ms    92 ms    92 ms  et-3-1-0.102.rtsw.newy32aoa.net.internet2.edu [198.71.45.236]
%  10    99 ms    97 ms    98 ms  nox300gw1-i2-re.nox.org [192.5.89.221]
%  11    97 ms    97 ms    97 ms  192.5.89.22
%  12    97 ms    97 ms    97 ms  neu-re-nox1sumgw1.nox.org [207.210.143.102]
%  13    97 ms   105 ms    97 ms  core-sl-1-vlan64.cne.neu.edu [129.10.128.10]
%  14    98 ms    97 ms    98 ms  129.10.131.51
% 
% Trace complete.

%%
hop1 = {'SOURCE : cat6506r.fsid.cvut.cz [147.32.160.1]',1};

hop2 = {'147.32.252.51', 1};

hop3 = {'cvut-r92.cesnet.cz [195.113.144.173]', 1};

hop4 = {'195.113.235.89', 2};

hop5 = {'cesnet.mx1.pra.cz.geant.net [62.40.124.29]', 3};

hop6 = {'ae9.mx1.fra.dk.geant.net [62.40.98.75]', 7};

hop7 = {'ae1.mx1.gen.ch.geant.net [62.40.98.108]', 15};

hop8 = {'ae4.mx1.par.fr.geant.net [62.40.98.152]', 22};

hop9 = {'et-3-1-0.102.rtsw.newy32aoa.net.internet2.edu [198.71.45.236]', 92};

hop10 = {'nox300gw1-i2-re.nox.org [192.5.89.221]', 98};

hop11 = {'192.5.89.22', 97};

hop12 = {'neu-re-nox1sumgw1.nox.org [207.210.143.102]', 97};

hop13 = {'core-sl-1-vlan64.cne.neu.edu [129.10.128.10]', 100};

hop14 = {'DESTINATION : 129.10.131.51', 98};

hops = [hop1; hop2; hop3; hop4; hop5; hop6; hop7; hop8; hop9; hop10; hop11;...
    hop12; hop13; hop14];


latency = [];
hop_dest = {};

for k = 1:length(hops)
    hop_dest{end+1} = hops{k,1};
    latency(end+1) = hops{k,2};
end

color_A = [0.8500,0.3250,0.0980];
figure; hold on;

bar(latency, 'FaceColor', color_A); grid on;
set(gca, 'XTickLabel',hop_dest, 'XTick',1:numel(hop_dest));

ax = gca; 
ax.XTickLabelRotation = 30;

ylabel('packet''s round-trip (msec)','FontSize', 18);
xlabel('remote nodes', 'FontSize', 15);
title('Packet''s path from Prague to Boston','FontSize', 18);


