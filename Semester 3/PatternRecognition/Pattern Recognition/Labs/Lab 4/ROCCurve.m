function ROCCurve(mean1, sigma)

    mean2=7;
    
    index=1;
    for x=(mean1-3*sigma):0.1:(mean2+3*sigma)
        [array(index,1),array(index,2)]=ROC(mean1,mean2,x);
        index=index+1;    
    end

    plot1=plot(array(:,1),array(:,2),'Displayname','ROC curve (d''=1)');
    hold on
    %======================================
    
    mean2=9;
    
    index=1;
    for x=(mean1-3*sigma):0.1:(mean2+3*sigma)
        [array(index,1),array(index,2)]=ROC(mean1,mean2,x);
        index=index+1;    
    end
    
    plot2=plot(array(:,1),array(:,2),'Displayname','ROC curve (d''=2)');
    %======================================    
    
    mean2=11;
    
    index=1;
    for x=(mean1-3*sigma):0.1:(mean2+3*sigma)
        [array(index,1),array(index,2)]=ROC(mean1,mean2,x);
        index=index+1;    
    end
    
    plot2=plot(array(:,1),array(:,2),'Displayname','ROC curve (d''=3)') ;   
    %======================================
    
    %d'=0
    xx=0:0.1:1;
    title('ROC curve plot');
    xlabel('False alarm (fa)'), ylabel('Hit (h)');
    axis on, axis normal, hold on;
    
    yy=xx;
    plot0=plot(xx,yy,'Displayname','ROC curve (d''=0)');
    
    legend('show','Location','SouthEast')

end