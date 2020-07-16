clc
clear all

% Position Error
% A,B,C,D,E,F,G,H
El_pos_land = [68 63 28 25 35 14 15 15]';
Eh_pos_land = [83 66 113 64 89 66 51 51]';
El_pos = [63 63 27 24 38 16 20 20]';
Eh_pos = [81 65 118 55 86 62 50 54]';
El_pos_sim = [64 63 28 24 36 13 21 21]'; 
Eh_pos_sim = [81 65 128 60 82 55 52 51]';

% Velosity Error
% A,B,C,D,G,H
El_vel_land = [106 65 58 47 58 58]';
Eh_vel_land = [124 76 186 107 69 69]';
El_vel = [102 65 49 42 58 58]';
Eh_vel = [128 77 214 105 70 84]';
El_vel_sim = [102 65 48 41 58 58]';
Eh_vel_sim = [128 77 227 109 70 79]';

% Smooth System
x1 = categorical({'PSM = 3 VSM = 0','PSM = 0 VSM = 0.6','PSM = 11 VSM = 0','PSM = 11 VSM = 0.6'});
x1 = reordercats(x1,{'PSM = 3 VSM = 0','PSM = 0 VSM = 0.6','PSM = 11 VSM = 0','PSM = 11 VSM = 0.6'});
p1 = [El_pos_land(1:4) El_pos(1:4) El_pos_sim(1:4) Eh_pos_land(1:4) Eh_pos(1:4) Eh_pos_sim(1:4)];
v1 = [El_vel_land(1:4) El_vel(1:4) El_vel_sim(1:4) Eh_vel_land(1:4) Eh_vel(1:4) Eh_vel_sim(1:4)];

figure('units','normalized','outerposition',[0 0 0.6 0.7])
bar(x1,p1);
title('Tracking Error of Smooth System')
ylabel('Position Error/%')
legend('0.5-1Hz Land','0.5-1Hz Math','0.5-1Hz Sim','1-3Hz Land','1-3Hz Math','1-3Hz Sim')

savefig(gcf,'position_error_SMS.fig')
saveas(gcf,'position_error_SMS.jpg')
close(gcf)

figure('units','normalized','outerposition',[0 0 0.6 0.7])
bar(x1,v1);
title('Tracking Error of Smooth System')
ylabel('Velocity Error/%')
legend('0.5-1Hz Land','0.5-1Hz Math','0.5-1Hz Sim','1-3Hz Land','1-3Hz Math','1-3Hz Sim')

savefig(gcf,'velosity_error_SMS.fig')
saveas(gcf,'velocity_error_SMS.jpg')
close(gcf)

% Saccadic System
x2 = categorical({'PSA = 1 VSM = 0','PSM = 1 VSM = 0.1'});
x2 = reordercats(x2,{'PSA = 1 VSM = 0','PSM = 1 VSM = 0.1'});
p2 = [El_pos_land(5:6) El_pos(5:6) El_pos_sim(5:6) Eh_pos_land(5:6) Eh_pos(5:6) Eh_pos_sim(5:6)];

figure('units','normalized','outerposition',[0 0 0.6 0.7])
bar(x2,p2);
title('Tracking Error of Saccadic System')
ylabel('Position Error/%')
legend('0.5-1Hz Land','0.5-1Hz Math','0.5-1Hz Sim','1-3Hz Land','1-3Hz Math','1-3Hz Sim')

savefig(gcf,'position_error_SAS.fig')
saveas(gcf,'position_error_SAS.jpg')
close(gcf)

% Total
x3 = categorical({'a','b','c','d','e','f','g','h'});
x3 = reordercats(x3,{'a','b','c','d','e','f','g','h'});
p3 = [El_pos_land El_pos El_pos_sim Eh_pos_land Eh_pos Eh_pos_sim];

figure('units','normalized','outerposition',[0 0 0.6 0.7])
bar(x3,p3);
title('Tracking Error of Hybrid System')
ylabel('Position Error/%')
legend('0.5-1Hz Land','0.5-1Hz Math','0.5-1Hz Sim','1-3Hz Land','1-3Hz Math','1-3Hz Sim')

savefig(gcf,'position_error_HYS.fig')
saveas(gcf,'position_error_HYS.jpg')
close(gcf)

x4 = categorical({'a','b','c','d','g','h'});
x4 = reordercats(x4,{'a','b','c','d','g','h'});
v4 = [El_vel_land El_vel El_vel_sim Eh_vel_land Eh_vel Eh_vel_sim];

figure('units','normalized','outerposition',[0 0 0.6 0.7])
bar(x4,v4);
title('Tracking Error of Hybrid System')
ylabel('Velocity Error/%')
legend('0.5-1Hz Land','0.5-1Hz Math','0.5-1Hz Sim','1-3Hz Land','1-3Hz Math','1-3Hz Sim')

savefig(gcf,'velocity_error_HYS.fig')
saveas(gcf,'velocity_error_HYS.jpg')
close(gcf)