function hcapplication()
load provinces.mat

%Apply z transformation
z=zscore(provinces)

%Dissimilarity matrix
D=pdist(z);
%We then transform the resulting vector to a squareform
squareform(D)

%Generate the dendrogram
link = linkage(D,'single');
dendrogram(link);
title('Dendrogram Nederlands provinces');
xlabel('Province number')
ylabel('Distance')
legend('show','location','northeastoutside');
end