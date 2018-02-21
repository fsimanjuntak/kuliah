function minvarpartition()
x1=[0 0];
x2=[2 3];
x3=[1 4];
x4=[4 2];
x5=[3 0];

%Scenario1
cluster1=vertcat(x1,x2,x3);
cluster2=vertcat(x4,x5);

mean1=mean(cluster1);
mean2=mean(cluster2);

D=sum(pdist2(cluster1,mean1,'squaredeuclidean'))+sum(pdist2(cluster2,mean2,'squaredeuclidean'))

%Scenario2
cluster1=vertcat(x2,x3,x5);
cluster2=vertcat(x1,x4);

mean1=mean(cluster1);
mean2=mean(cluster2);

D=sum(pdist2(cluster1,mean1,'squaredeuclidean'))+sum(pdist2(cluster2,mean2,'squaredeuclidean'))

%Scenario3
cluster1=vertcat(x4);
cluster2=vertcat(x1,x2,x3,x5);

mean1=x4;%It is only one value so we just copy it, otherwise it will treat them as a single vector
mean2=mean(cluster2);

D=sum(pdist2(cluster1,mean1,'squaredeuclidean'))+sum(pdist2(cluster2,mean2,'squaredeuclidean'))

%Scenario4
cluster1=vertcat(x4,x5);
cluster2=vertcat(x1,x2,x3);

mean1=mean(cluster1);
mean2=mean(cluster2);

D=sum(pdist2(cluster1,mean1,'squaredeuclidean'))+sum(pdist2(cluster2,mean2,'squaredeuclidean'))

%Scenario5
cluster1=vertcat(x3,x5);
cluster2=vertcat(x1,x2,x4);

mean1=mean(cluster1);
mean2=mean(cluster2);

D=sum(pdist2(cluster1,mean1,'squaredeuclidean'))+sum(pdist2(cluster2,mean2,'squaredeuclidean'))

end