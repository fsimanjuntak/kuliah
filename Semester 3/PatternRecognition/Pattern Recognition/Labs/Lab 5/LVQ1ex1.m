function LVQ1ex1()
    %Load data class_a and class_b
    load data_lvq_A.mat
    load data_lvq_B.mat
    
    %Plot feature2 vs feature1 of both classes
    scatter(matA(:,1),matA(:,2),20);
    title('Class distribution scatter plot')
    xlabel('Feature 1')
    ylabel('Feature 2')
    hold on;
    
    scatter(matB(:,1),matB(:,2),20);
    legend('Class A','Class B');
    hold off;
end