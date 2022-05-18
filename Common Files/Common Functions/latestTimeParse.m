function [latestPath] = latestTimeParse(basePath,tag)
    
    

    %Get all files in basePath
    listing = dir(basePath);
    
    %Init Arrays
    iter = 1;
    
    for i = 1:length(listing)
        %Accumulate all paths that contain the specified tag
        if ~isempty(strfind(listing(i).name,strcat('_',tag,'.mat')))
            
            %Add to list of tagged items
            listing(i).name;
            names(iter) = convertCharsToStrings(listing(i).name);
            iter = iter + 1;
        end
    end
    
    %Find latest file
    tStampKeep = datetime('01-Jan-1900 00:00:00','InputFormat','dd-MMM-yyyy HH:mm:ss');
    namesKeep = '';
    for i = 1:length(names)
        
        tStampTemp = getTimeStamp(names(i));
        if tStampTemp > tStampKeep
            tStampKeep = tStampTemp;
            namesKeep = names(i);
        end
    end
    
    latestPath = strcat(basePath,namesKeep);
end