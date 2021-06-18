function [] = fsigmaplot(sweepData,switchThresh,sinfreqsDecimate,commonPath,grid)
siglength = length(sweepData(1,1).hybridInfo);
flength = size(sweepData,2);
fsiggrid = zeros(flength,siglength);

for i = 1:flength
    for j = 1:siglength
        fsiggrid(i,j) = sweepData(1,i).hybridInfo(j).hSAE;
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
if grid
    xnumlines = 100;
    ynumlines = 30;    
else
    xnumlines = 20;
    ynumlines = 30;
end

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
hold off

ax = gca;
set(gcf, 'Color', 'w');
ax.XAxis.FontSize = 16;
ax.XAxis.FontName = 'Helvetica';
ax.XAxis.Color = 'k';
ax.YAxis.FontSize = 16;
ax.YAxis.FontName = 'Helvetica'; 
ax.YAxis.Color = 'k';
ax.ZAxis.FontSize = 16;
ax.ZAxis.FontName = 'Helvetica';
ax.ZAxis.Color = 'k';
xlabel('\sigma (rad)','FontName','Helvetica','FontSize',18,'FontWeight','bold')
ylabel('f_{in} (Hz)','FontName','Helvetica','FontSize',18,'FontWeight','bold')
zlabel('SAE (rad/s)','FontName','Helvetica','FontSize',18,'FontWeight','bold')
box on


end