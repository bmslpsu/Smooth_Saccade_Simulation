function [gain,phase,error] = trackingSimHybrid(sinin,sinout,sinfreqsl,Fs,N)

    %FRF Analysis
    ffin = fft(sinin,N);
    ffout = fft(sinout,N);
    ffindex = round(1 + sinfreqsl/(Fs/N));
    magratio = abs(ffout(ffindex))/abs(ffin(ffindex));
    phaseshift = angle(ffout(ffindex))-angle(ffin(ffindex));

    compGain = magratio.*exp(phaseshift*1i);
    perfectGain = 1 + 0*1i;
    error = abs(compGain - perfectGain);
    
    gain = magratio;
    phase = phaseshift;
    
end