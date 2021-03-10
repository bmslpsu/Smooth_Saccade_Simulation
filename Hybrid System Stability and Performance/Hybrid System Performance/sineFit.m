function [sinout,rsquared] = sineFit(y,x)
    yu = max(y);
    yl = min(y);
    yr = (yu-yl);                               % Range of ‘y’
    yz = y-yu+(yr/2);
    zx = x(yz .* circshift(yz,[0 1]) <= 0);     % Find zero-crossings
    per = 2*mean(diff(zx));                     % Estimate period
    ym = mean(y);                               % Estimate offset
    fit = @(b,x)  b(1).*(sin(2*pi*x./b(2) + 2*pi/b(3))) + b(4);    % Function to fit
    fcn = @(b) sum((fit(b,x) - y).^2);                              % Least-Squares cost function
    options = optimset('MaxFunEvals',100,'Display','none');
    s = fminsearch(fcn, [yr;  per;  -1;  ym],options);                       % Minimise Least-Squares
    
    sinout = fit(s,x);
    sstot = sum((y-mean(y)).^2);
    ssres = sum((y-fit(s,x)).^2);
    rsquared = 1 - ssres/sstot;
%     figure(1)
%     plot(x,y,'b',  x,fit(s,x), 'r')
%     grid
end