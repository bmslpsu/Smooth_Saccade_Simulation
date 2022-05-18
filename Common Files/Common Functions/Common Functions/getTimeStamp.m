function [timeStamp] = getTimeStamp(filename)
    
    %Get the time string out of the filename
    splits = split(filename,'.');
    tString = cell2mat(splits(2));
    
    %Convert time string to dateTime
    timeStamp = datetime(tString,'InputFormat','yyyy-MM-dd''T''HHmmss');
    
end