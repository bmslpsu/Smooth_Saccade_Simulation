function [ftraces,saetraces] = fsigmaplot(sweepData,switchThresh,sinfreqsDecimate,sigs)
siglength = length(sweepData(1,1).hybridInfo);
flength = size(sweepData,2);
fsiggrid = zeros(flength,siglength);

for i = 1:flength
    for j = 1:siglength
        fsiggrid(i,j) = sweepData(1,i).hybridInfo(j).hSAE/1e4;
    end
end

s = surf(switchThresh,sinfreqsDecimate,fsiggrid,'EdgeColor','none');

%%Extract X,Y and Z data from surface plot
x=s.XData;
y=s.YData;
z=s.ZData;

% %%Create vectors out of surface's XData and YData
% x=x(1,:);
% y=y(:,1);

%%Divide the lengths by the number of lines needed
xnumlines = 20;
ynumlines = 30;


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

%Getting trace data
ftraces = zeros(length(sigs),length(y));
saetraces = zeros(length(sigs),size(z,1));
for i = 1:length(sigs)
[~,x_ex_ind] = min(abs(x-sigs(i)));
ftraces(i,:) = y;
saetraces(i,:) = z(:,x_ex_ind);
end

hold off

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
xlabel('\sigma (rad)','FontName','Arial','FontSize',8)
ylabel('f_{in} (Hz)','FontName','Arial','FontSize',8)
zlabel('SAE (rad x 10^4/s)','FontName','Arial','FontSize',8)
box on
caxis([0 8])
zlim([0 8])
pos = ax.YLabel.Position;
ax.YLabel.Position = [pos(1:2) pos(3)+0.75];
pos = ax.XLabel.Position;
ax.XLabel.Position = [pos(1:2) pos(3)+0.75];


end