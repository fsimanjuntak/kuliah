function LVQ1ex3a(etha,noProtA,noProtB)
 %Load data class_a and class_b
    load data_lvq_A.mat
    load data_lvq_B.mat
    
    %Add category label 0=class A, 1=class B
    matA(:,3)=0;
    matB(:,3)=1;
    
    %Concatenate the two matrices
    data=vertcat(matA,matB);
    
    %Randomly permute the rows, so we have an unbiased training data
    data2=data(randperm(length(data(:,1))),:);
    
    %We obtain the final position of the three prototypes after N
    %epochs,where the variation between epochs becomes smaller than the
    %threshold
    [prototype,epochNumber,epochError]=LVQeval(data2, etha,noProtA,noProtB);
    
    %Plot feature2 vs feature1 of both classes
    figure
    scatter(matA(:,1),matA(:,2),20,'DisplayName','Class A');
    axis([0 10 0 10]);
    title('Class distribution scatter plot and LVQ prototypes')
    xlabel('Feature 1')
    ylabel('Feature 2')
    hold on;
    
    scatter(matB(:,1),matB(:,2),20,'DisplayName','Class B');
    
    for(i=1:length(prototype(:,1)))
        
        if(prototype(i,3)==0)
            strLeg='class A prototype';
        else
            strLeg='class B prototype';
        end
        scatter(prototype(i,1),prototype(i,2),50,'filled','DisplayName',strLeg);
    end
    
    legend('show');
    hold off;
    
    x=1:1:length(epochError);
    
    %Plot of the missclasification training error rate
    figure
    plot(x,epochError,'-o');
        %axis([0 10 0 10]);
    title('Missclasification training error rate evolution')
    xlabel('Epoch')
    ylabel('Missclasification training error rate')
    legend('Missclassified training error rate');
    
end

function [prototype,epochNumber,epochError]=LVQeval(data, etha, noProtA, noProtB)
    %Randomly generate the prototype matrix, column 3 identifies the class
    %(A=0, B=1)
    for(i=1:(noProtA+noProtB))
        if(i<=noProtA)
            prototype(i,:)=[rand()*10,rand()*10,0];
        else
            prototype(i,:)=[rand()*10,rand()*10,1];
        end
    end
    
    %Missclasiffied training error
    newMTE=1;
    MTEdiff=1;
    variationThreshold=0.0001;
    errorThreshold=0.45;
    
    epochNumber=0;
    
    %Run epochs until the eror difference becomes smaller than threshold
    %while(MTEdiff>variationThreshold)
    while(MTEdiff>variationThreshold || newMTE>errorThreshold)
        
        epochNumber=epochNumber+1
        oldMTE=newMTE;
        
        [newMTE,prototype]=epoch(data,prototype,etha);
        disp(newMTE)
        MTEdiff=abs(oldMTE-newMTE)
        %We save the missclassified training error for each epoch
        epochError(epochNumber)=newMTE;
        
        strLeg='';
        
        %Animated plotting
        for(i=1:length(prototype(:,1)))
            
            if(prototype(i,3)==0)
                strLeg='class A';
            else
                strLeg='class B';
            end
            
            scatter(prototype(i,1),prototype(i,2),50,'filled','DisplayName',strLeg);
            axis([0 10 0 10]);
            title('LVQ prototype training')
            xlabel('Feature 1')
            ylabel('Feature 2')
            hold on;
            
        end
        
        legend('show');
        hold off
    
       pause(0.10);
    end
end

function [trainingErrorRate,prototype]=epoch(data,prototype,etha)
%Learning phase
    mte=0;
    
    for i=1:1:size(data(:,1))
        
        point=data(i,1:2);
        
        %Find the class of the closest prototype
        closestPrototype=WinnerEuc(point, prototype);
        
        %Compare if they belong to the same class
        if(data(i,3)==prototype(closestPrototype,3))
            prototype(closestPrototype,1:2)=newPosition(prototype(closestPrototype,1:2), point, etha, 1);
        else
            prototype(closestPrototype,1:2)=newPosition(prototype(closestPrototype,1:2), point, etha, -1);
            mte=mte+1;
        end
    end
    trainingErrorRate=mte/length(data(:,1));
end

%Return the closest prototype to the point
function closestPrototypeIndex=WinnerEuc(point, prototype)
    oldD=100;
    for(i=1:length(prototype(:,1)))
        d=pdist2(point, prototype(i,1:2));
        
        if(d<oldD)
            closestPrototypeIndex=i;  
            oldD=d;
        end
    end
end

function w=newPosition(prototype, point, etha, phi)
    w=prototype+(etha*phi*(point-prototype));
end
    