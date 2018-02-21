function LVQ2(etha,noProtA,noProtB)
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
    [prototype,testingError]=LVQeval(data2, etha,noProtA,noProtB);
    
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
    
    x=1:1:length(testingError);
    
    %Plot of the missclasification training error rate
    figure
    plot(x,testingError,'-o');
    axis([1 10 0 20]);
    title('Ten fold testing')
    xlabel('K-Fold')
    ylabel('Missclasification error')
    legend('Missclassified error');
    
    %The test error is the mean of the classification errors
    disp(mean(testingError));
    
end

function [prototype,testingError]=LVQeval(data, etha, noProtA, noProtB)
    %Randomly generate the prototype matrix, column 3 identifies the class
    %(A=0, B=1)
    for(i=1:(noProtA+noProtB))
        if(i<=noProtA)
            prototype(i,:)=[rand()*10,rand()*10,0];
        else
            prototype(i,:)=[rand()*10,rand()*10,1];
        end
    end
    
    indices = crossvalind('Kfold',data(:,3),10);
    data(:,4)=indices;

    %Run ten-fold training validatino
    for(i=1:1:10)
        trainData=[0 0 0];
        testData=[0 0 0];
        for(j=1:1:200)
            if(data(j,4)~=i)
                trainData(length(trainData(:,1))+1,:)=data(j,1:3);
            else
                testData(length(testData(:,1))+1,:)=data(j,1:3);
            end
        end
            
        [testingError(i),prototype]=epoch(trainData,testData,prototype,etha);

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

function [testingError,prototype]=epoch(data,testData,prototype,etha)
%Learning phase
    testingError=0;
    
    for i=2:1:size(data(:,1))
        
        point=data(i,1:2);
        
        %Find the class of the closest prototype
        closestPrototype=WinnerEuc(point, prototype);
        
        %Compare if they belong to the same class
        if(data(i,3)==prototype(closestPrototype,3))
            prototype(closestPrototype,1:2)=newPosition(prototype(closestPrototype,1:2), point, etha, 1);
        else
            prototype(closestPrototype,1:2)=newPosition(prototype(closestPrototype,1:2), point, etha, -1);
        end
    end
    
    for i=2:1:size(testData(:,1))
        point=testData(i,1:2);
        %Find the class of the closest prototype
        closestPrototype=WinnerEuc(point, prototype);
        
        %Compare if they belong to the same class
        if(testData(i,3)~=prototype(closestPrototype,3))
            testingError=testingError+1;
        end
    end
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
    