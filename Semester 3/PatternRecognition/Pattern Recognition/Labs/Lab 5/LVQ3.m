function LVQ3(etha,noProtA,noProtB)
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
    [prototype,epochNumber,epochError,testingError,lambda1,lambda2]=LVQeval(data2, etha,noProtA,noProtB);
    
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
    
    %Plot of the clasification error
    x=1:1:length(testingError);
    figure
    plot(x,testingError,'-o');
    axis([1 10 0 20]);
    title('Ten fold testing')
    xlabel('K-Fold')
    ylabel('Missclasification error')
    legend('Missclassified error');
    
    %The test error is the mean of the classification errors
    disp(mean(testingError));
    
    %Plot of the final relevances after each epoch
    x=1:1:length(lambda1);
    figure
    plot(x,lambda1,'-o','DisplayName','Final relevances lambda1');
    title('GRLVQ results after each epoch')
    xlabel('Epoch')
    ylabel('Relevance (lambda)')
    
    hold on;
    
    plot(x,lambda2,'-o','DisplayName','Final relevances lambda2');
    legend('show');
    hold off;
    
end

function [prototype,epochNumber,epochError,testingError,lambda1E,lambda2E]=LVQeval(data, etha, noProtA, noProtB)
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
        
        %Missclasiffied training error
        newMTE=1;
        MTEdiff=1;
        variationThreshold=0.0001;
        errorThreshold=0.25;

        epochNumber=0;

        %Run epochs until the eror difference becomes smaller than threshold
        %while(MTEdiff>variationThreshold)
        while(MTEdiff>variationThreshold || newMTE>errorThreshold)

            epochNumber=epochNumber+1;
            oldMTE=newMTE;

            [newMTE,prototype,testingError(i),lambda1,lambda2]=epoch(trainData,testData,prototype,etha);
            
            MTEdiff=abs(oldMTE-newMTE);
            %We save the missclassified training error for each epoch
            epochError(epochNumber)=newMTE;
            lambda1E(epochNumber)=lambda1;
            lambda2E(epochNumber)=lambda2;
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
end

function [trainingErrorRate,prototype,testingError,lambda1,lambda2]=epoch(data,testData,prototype,etha)
%Learning phase
    mte=0;
    lambda1=0.5;
    lambda2=0.5;
    testingError=0;
    for i=1:1:size(data(:,1))
        
        point=data(i,1:2);
        
        %Find the class of the closest prototype
        closestPrototype=WinnerEuc(point, prototype);
        
        %Compare if they belong to the same class
        if(data(i,3)==prototype(closestPrototype,3))
            [prototype(closestPrototype,1:2),lambda1,lambda2]=newPosition(prototype(closestPrototype,1:2), point, etha, 1,lambda1,lambda2,data(i,3));
        else
            [prototype(closestPrototype,1:2),lambda1,lambda2]=newPosition(prototype(closestPrototype,1:2), point, etha, -1,lambda1,lambda2,data(i,3));
            mte=mte+1;
        end
    end
    trainingErrorRate=mte/length(data(:,1));
    
%Testing phase
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

function [w,lambda1,lambda2]=newPosition(prototype, point, etha, phi, lambda1, lambda2, class)
    if(class==0)
        w=prototype+(etha*phi*lambda1*(point-prototype));
        %Calculate the new lambda
        lambda1=lambda1-etha*phi*pdist2(point,prototype);
        %Enforce
        lambda2=1-lambda1;
    else
        w=prototype+(etha*phi*lambda2*(point-prototype));
        %Calculate the new lambda
        lambda2=lambda2-etha*phi*pdist2(point,prototype);
        %Enforce
        lambda1=1-lambda2;
    end
end
    