function [sinout,rsquared] = sineFitMod(y,x,freq)
    ymax = max(y);
    ymin = min(y);
    ymean = (ymax-ymin)/2;      

    fit = @(b,x)  b(1).*(sin(2*pi*freq*x + b(2)));
    fcn = @(b) sum((fit(b,x) - y).^2);
    options = optimset('MaxFunEvals',100,'Display','none');

    s = fminsearch(fcn, [ymean;  0;],options);        
    
    sinout = fit(s,x);
    sstot = sum((y-mean(y)).^2);
    ssres = sum((y-fit(s,x)).^2);
    rsquared = 1 - ssres/sstot;
%     figure(1)
%     plot(x,y,'b',  x,fit(s,x), 'r')
%     grid
end