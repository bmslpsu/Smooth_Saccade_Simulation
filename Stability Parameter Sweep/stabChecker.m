%This function takes in an array of sim outputs from the simulink model and
%determines the stability of each of them.  It then organizes them into
%two arrays of gain,freq pairs - one for stable points, and one for
%unstable points.

function [stability] = stabChecker(simOutput)
P_out = simOutput.P_out;


end