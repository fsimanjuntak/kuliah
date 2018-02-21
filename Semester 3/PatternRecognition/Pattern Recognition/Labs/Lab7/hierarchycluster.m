%method input variable
%1=min, 2=max, 3=avg, 4=mean
function hierarchycluster(method)
    c=4; %number of groups
    load cluster_data.mat;
    
    switch method
        case 1
            Z = linkage(cluster_data,'single');
            %T = clusterdata(cluster_data,'linkage','single','maxclust',4);
        case 2
            Z = linkage(cluster_data,'complete');
            %T = clusterdata(cluster_data,'linkage','complete','maxclust',4);
        case 3
            Z = linkage(cluster_data,'average');
            %T = clusterdata(cluster_data,'linkage','average','maxclust',4);
        case 4
            Z = linkage(cluster_data,'median');
            %T = clusterdata(cluster_data,'linkage','median','maxclust',4);
    end
    
    %Define to which cluster the point belongs to
    class = cluster(Z,'maxclust',4);
    
    %Concatenate the two matrices
    dataCluster = [cluster_data class];
   
    %Split matrix into 4 to calculate the mean of each one
    cluster1=dataCluster(dataCluster(:,3) == 1, 1:2);
    cluster2=dataCluster(dataCluster(:,3) == 2, 1:2);
    cluster3=dataCluster(dataCluster(:,3) == 3, 1:2);
    cluster4=dataCluster(dataCluster(:,3) == 4, 1:2);

    %Compute the four means
    centroid1=mean(cluster1);
    centroid2=mean(cluster2);
    centroid3=mean(cluster3);
    centroid4=mean(cluster4);
    
    %Plot the clusters with centroids
    figure
    scatter(cluster1(:,1),cluster1(:,2),3,'DisplayName','Cluster 1');
    hold on;
    scatter(cluster2(:,1),cluster2(:,2),3,'DisplayName','Cluster 2');
    hold on;
    scatter(cluster3(:,1),cluster3(:,2),3,'DisplayName','Cluster 3');
    hold on;
    scatter(cluster4(:,1),cluster4(:,2),3,'DisplayName','Cluster 4');
    hold on;
    
    %Plot centroids
    scatter(centroid1(:,1),centroid1(:,2),20,'filled','DisplayName','Centroid 1');
    hold on;
    scatter(centroid2(:,1),centroid2(:,2),20,'filled','DisplayName','Centroid 2');
    hold on;
    scatter(centroid3(:,1),centroid3(:,2),20,'filled','DisplayName','Centroid 3');
    hold on;
    scatter(centroid4(:,1),centroid4(:,2),20,'filled','DisplayName','Centroid 4');
    hold on;
    
    switch method
        case 1
            title('Agglomerative hierarchical clustering min distance')
        case 2
            title('Agglomerative hierarchical clustering max distance')
        case 3
            title('Agglomerative hierarchical clustering avg distance')
        case 4
            title('Agglomerative hierarchical clustering mean distance')
    end
    xlabel('x value')
    ylabel('y value')
    legend('show','location','northeastoutside');
    hold off;
    
    %Plot the dendogram
    figure
    dendrogram(Z);
    switch method
        case 1
            title('Dendrogram min distance')
        case 2
            title('Dendrogram max distance')
        case 3
            title('Dendrogram avg distance')
        case 4
            title('Dendrogram mean distance')
    end
    xlabel('Observations')
    ylabel('Distance')
    legend('show','location','northeastoutside');
end