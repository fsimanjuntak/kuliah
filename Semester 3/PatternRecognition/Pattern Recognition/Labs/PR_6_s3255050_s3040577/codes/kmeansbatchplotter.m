function kmeansbatchplotter()
    function plotBatch(epochs)
        batchNG(data, K, epochs);
        xlabel('X');
        ylabel('Y');
        tt = sprintf('Batch Neural Gas clustering, %d epochs', epochs);
        title(tt);
    end

K = 100;

data = load('checkerboard');
data = data.checkerboard;

% Plot for k-means
figure(1);
[~, prototypesHistory] = kmeans(data, K, false, true);
iterations = size(prototypesHistory, 3);
lastPrototypes = prototypesHistory(:, :, iterations); 
plot(data(:,1),data(:,2),'bo','markersize',3)
hold on
plot(lastPrototypes(:,1),lastPrototypes(:,2),'r.','markersize',10,'linewidth',3)  
voronoi(lastPrototypes(:, 1), lastPrototypes(:, 2));
xlabel('X');
ylabel('Y');
tt = sprintf('%d-Means clustering', K);
title(tt);
hold off;
pause;

% Plot for batch neural 20
figure(2);
plotBatch(20);
pause;

% Plot for batch neural 100
figure(3);
plotBatch(100);
pause;

% Plot for batch neural 200
figure(4);
plotBatch(200);
pause;

% Plot for batch neural 500
figure(5);
plotBatch(500);

end