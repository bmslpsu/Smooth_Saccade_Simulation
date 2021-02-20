function [path] = smoothStabilityPathHelper()
    %The purpose of this function is to provide "mfilename" function
    %capability to the smooth stability Live file.  "mfilename"
    %functionality is only available in script files.  This file MUST be in
    %the same directory as the Stability.mlx file
    
    [path,~,~] = fileparts(mfilename('fullpath'));
end