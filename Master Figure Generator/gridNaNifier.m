function [gout] = gridNaNifier(gin,gx,gy,cx,cy)
cx = cx(2:21);
cy = cy(2:21);
intCurve = interp1(cx,cy,gx,'spline');

%NaNify
for i = 1:length(gx)
    for j = 1:length(gy)
        if gy(j) > intCurve(i)
            gin(j,i) = NaN;
        end
        if gx(i) > cx(end)
            gin(j,i) = NaN;
        end
        if gin(j,i) < 1e-4
            gin(j,i) = 0;
        end
    end
end
gout = gin;            

end