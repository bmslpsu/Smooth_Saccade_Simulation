function [] = AnimationPlotter(inputV,outputV,time,savepath)
    deltat = time(2) - time(1);
    
    fig = figure('Renderer', 'painters', 'Position', [10 10 1400 700]);
    theta = 0:pi/500:2*pi;
    circX = cos(theta);
    circY = sin(theta);
    
    
    inputP = 0;
    inputPxy = [0 0];
    
    outputP = 0;
    outputPxy = [0 0];
    
    
    
    for i = 2:250
        subplot(1,2,1)
        plot(circX,circY)
        axis square
        grid on
        hold on
        
        inputP = inputP + inputV(i-1)*deltat;
        inputPxy = [cos(inputP) sin(inputP)];
        plot(inputPxy(1),inputPxy(2),'r.','MarkerSize',36);
        
        
        outputP = outputP + outputV(i-1)*deltat;
        outputPxy = [0.3*cos(outputP) 0.3*sin(outputP)];
        arrow3([0 0],outputPxy)
        
        hold off
        subplot(1,2,2)
        plot(time,inputV,time,outputV,time(i),inputV(i-1),'r.','MarkerSize',24)
        hold on
        plot(time(i),outputV(i-1),'k.','MarkerSize',24)
        xlabel('Time (s)')
        ylabel('Angular Velocity (deg/s)')
        hold off

        F(i-1) = getframe(fig);
    end
    
    v = VideoWriter(savepath);
    v.FrameRate = 10;
    open(v)
    writeVideo(v,F);
    close(v)  
end