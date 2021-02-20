clear
% Aerodynamic damping during rapid flight maneuvers in the fruit fly Drosophila
% B. Cheng, S. N. Fry, Q. Huang, X. Deng
% Journal of Experimental Biology 2010 213: 602-612; doi: 10.1242/jeb.038778
Cu = 21e-12;
I = 4.971e-12;
G_plant = tf(Cu,[I 0]); %Torque to Velocity

[filepath,~,~] = fileparts(mfilename('fullpath'));

savePath = genFileName(filepath,'plant');
save(savePath,'G_plant');