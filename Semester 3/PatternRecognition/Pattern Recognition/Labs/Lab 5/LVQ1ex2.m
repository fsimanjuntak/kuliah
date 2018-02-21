function LVQ1ex2(etha)
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
    [prototype1A,prototype2A,prototype1B,epochNumber,epochError]=LVQeval(data2, etha);
    
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

function [prototype1A,prototype2A,prototype1B,epochNumber,epochError]=LVQeval(data, etha)
    %Randomly generate two prototypes for class A
    prototype1A=[rand()*4,rand()*9];
    prototype2A=[6+rand()*4,rand()*9];
    
    %Randomly generate one prototype for class B
    prototype1B=[rand()*10,rand()*9];
   
    %Missclasiffied training error
    newMTE=1;
    MTEdiff=1;
    variationThreshold=0.0001;
    errorThreshold=0.25;
    
    epochNumber=0;
    
    %Run epochs until the eror difference becomes smaller than threshold
    while(MTEdiff>variationThreshold || newMTE>errorThreshold)
        
        epochNumber=epochNumber+1;
        oldMTE=newMTE;
        
        [newMTE,prototype1A,prototype2A,prototype1B]=epoch(data,prototype1A,prototype2A,prototype1B,etha);

        MTEdiff=abs(oldMTE-newMTE);
        %We save the missclassified training error for each epoch
        epochError(epochNumber)=newMTE;
        
        %Animated plotting
        scatter(prototype1A(1),prototype1A(2),20,'filled');
        axis([0 10 0 10]);
        title('LVQ prototype training')
        xlabel('Feature 1')
        ylabel('Feature 2')
        hold on;

        scatter(prototype2A(1),prototype2A(2),20,'filled');
        scatter(prototype1B(1),prototype1B(2),20,'filled');
        legend('Prototype 1(class A)','Prototype 2(class A)','Prototype 1(class B)');
        hold off
        
       pause(0.10);
    end
end

function [trainingErrorRate,prototype1A,prototype2A,prototype1B]=epoch(data,prototype1A,prototype2A,prototype1B,etha)
%Learning phase
    mte=0;
    
    for i=1:1:size(data(:,1))
        
        point=data(i,1:2);
        
        %Find the class of the closest prototype
        closestPrototype=WinnerEuc(point, prototype1A, prototype2A, prototype1B);
        
        switch closestPrototype
            case '1A'
                %Compare if they belong to the same class
                if(data(i,3)==0)
                    prototype1A=newPosition(prototype1A, point, etha, 1);
                else
                    prototype1A=newPosition(prototype1A, point, etha, -1);
                    mte=mte+1;
                end
            case '2A'
                %Compare if they belong to the same class
                if(data(i,3)==0)
                    prototype2A=newPosition(prototype2A, point, etha, 1);
                else
                    prototype2A=newPosition(prototype2A, point, etha, -1);
                    mte=mte+1;
                end
            case '1B'
                %Compare if they belong to the same class
                if(data(i,3)==1)
                    prototype1B=newPosition(prototype1B, point, etha, 1);
                else
                    prototype1B=newPosition(prototype1B, point, etha, -1);
                    mte=mte+1;
                end
        end
    end
    trainingErrorRate=mte/length(data(:,1));
end

%Return the closest prototype to the point
function minD=WinnerEuc(point, prototype1A, prototype2A, prototype1B)
    d1A=pdist2(point, prototype1A);
    minD='1A';
    
    d2A=pdist2(point, prototype2A);
    if(d2A<d1A)
        minD='2A';
    end
    
    d1B=pdist2(point, prototype1B);
    if(d1B<d1A & d1B<d2A)
        minD='1B';
    end
end

function w=newPosition(prototype, point, etha, phi)
    w=prototype+(etha*phi*(point-prototype));
end
    