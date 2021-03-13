function list = badFitList(sweepData,threshold)
    kpLength = size(sweepData,1);
    kiLength = size(sweepData,2);
    fLength = size(sweepData,3);
    stLength = length(sweepData(1,1,1).hybridInfo);
    
    maxsize = kpLength*kiLength*fLength*stLength;
    badFitList = zeros(maxsize,9);
    
    iter = 1;
    for i = 1:kpLength
        for j = 1:kiLength
            for k = 1:fLength
                for l = 1:stLength
                    r2 = sweepData(i,j,k).hybridInfo(l).rsquare;
                    if r2 < threshold
                        badFitList(iter,:) = [sweepData(i,j,k).Kp i sweepData(i,j,k).Ki j ...
                            sweepData(i,j,k).inputFreq k sweepData(i,j,k).hybridInfo(l).switchThresh l...
                            r2];
                        iter = iter + 1;
                    end
                end
            end
        end
    end
    
 list = badFitList(1:iter,:);   
    
end