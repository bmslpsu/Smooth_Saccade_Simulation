function [ftraces,saetraces] = fsigmaplot(sweepData,switchThresh,sinfreqsDecimate,sigs)
siglength = length(sweepData(1,1).hybridInfo);
flength = size(sweepData,2);
fsiggrid = zeros(flength,siglength);
r2deg = 180/pi;

%Create surface from hybrid SAE
for i = 1:flength
    for j = 1:siglength
        fsiggrid(i,j) = sweepData(1,i).hybridInfo(j).hSAE*r2deg*(1/10000);
    end
end

s = surf(switchThresh.*r2deg,sinfreqsDecimate,fsiggrid,'EdgeColor','none');

%%Extract X,Y and Z data from surface plot
x=s.XData;
y=s.YData;
z=s.ZData;

%%Divide the lengths by the number of lines needed for mesh grid
xnumlines = 20;
ynumlines = 26;
xspacing = round(length(x)/xnumlines);
yspacing = round(length(y)/ynumlines);

%%Plot the mesh lines 
% Plotting lines in the X-Z plane
hold on
for i = 1:yspacing:length(y)
    Y1 = y(i)*ones(size(x)); % a constant vector
    Z1 = z(i,:);
    plot3(x,Y1,Z1,'-k');
end
% Plotting lines in the Y-Z plane
for i = 1:xspacing:length(x)
    X2 = x(i)*ones(size(y)); % a constant vector
    Z2 = z(:,i);
    plot3(X2,y,Z2,'-k');
end

%Getting trace data for 2d plots
ftraces = zeros(length(sigs),length(y));
saetraces = zeros(length(sigs),size(z,1));
for i = 1:length(sigs)
[~,x_ex_ind] = min(abs(x-(sigs(i)*r2deg)));
ftraces(i,:) = y;
saetraces(i,:) = z(:,x_ex_ind);
end

hold off

%Generate plot
ax = gca;
set(gcf, 'Color', 'w');
ax.XAxis.FontSize = 8;
ax.XAxis.FontName = 'Arial';
ax.XAxis.Color = 'k';
ax.YAxis.FontSize = 8;
ax.YAxis.FontName = 'Arial'; 
ax.YAxis.Color = 'k';
ax.ZAxis.FontSize = 8;
ax.ZAxis.FontName = 'Arial';
ax.ZAxis.Color = 'k';
xlabel('\sigma (deg)','FontName','Arial','FontSize',8)
ylabel('f_{in} (Hz)','FontName','Arial','FontSize',8)
zlabel('SAE (deg x 10^4/s)','FontName','Arial','FontSize',8)
box on
caxis([0 4])
zlim([0 4])
pos = ax.YLabel.Position;
ax.YLabel.Position = [pos(1:2) pos(3)+0.75];
pos = ax.XLabel.Position;
ax.XLabel.Position = [pos(1:2) pos(3)+0.75];
zticks([0 2 4])
xlim([0 15])
xticks([0 5 10 15])

end