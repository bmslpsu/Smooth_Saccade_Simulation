function [savePath] = genFileName(basePath,tag)
    
    %Generate time stamp
    t = datetime('now','Format','yyyy-MM-dd''T''HHmmss');
    S = char(t);
    savePath = strcat(basePath,'\','T.',S,'.T_',tag,'.mat');
end