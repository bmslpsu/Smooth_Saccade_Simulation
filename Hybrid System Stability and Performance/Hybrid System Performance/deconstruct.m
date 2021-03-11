function [hybridOut,hFit,hGain,hPhase,hError,smoothOut,sGain,sPhase,sError] = deconstruct(sweepData)

timeLength = length(sweepData(1,1,1).hybridInfo(1).hybridOut);
kpLength = size(sweepData,1);
kiLength = size(sweepData,2);
fLength = size(sweepData,3);
stLength = length(sweepData(1,1,1).hybridInfo);

smoothOut = zeros(kpLength,kiLength,fLength,timeLength);
sGain = zeros(kpLength,kiLength,fLength);
sPhase = sGain;
sError = sGain;

hybridOut = zeros(kpLength,kiLength,fLength,stLength,timeLength);
hFit = hybridOut;
hGain = zeros(kpLength,kiLength,fLength,stLength);
hPhase = hGain;
hError = hGain;

for i = 1:kpLength
    for j = 1:kiLength
        for k = 1:fLength
            smoothOut(i,j,k,:) = sweepData(i,j,k).smoothOut;
            sGain(i,j,k) = sweepData(i,j,k).sGain;
            sPhase(i,j,k) = sweepData(i,j,k).sPhase;
            sError(i,j,k) = sweepData(i,j,k).sError;
            
            for l = 1:stLength
                hybridOut(i,j,k,l,:) = sweepData(i,j,k).hybridInfo(l).hybridOut;
                hFit(i,j,k,l,:) = sweepData(i,j,k).hybridInfo(l).hFit;
                hGain(i,j,k,l) = sweepData(i,j,k).hybridInfo(l).hGain;
                hPhase(i,j,k,l) = sweepData(i,j,k).hybridInfo(l).hPhase;
                hError(i,j,k,l) = sweepData(i,j,k).hybridInfo(l).hError;
            end
        end
    end
end



end