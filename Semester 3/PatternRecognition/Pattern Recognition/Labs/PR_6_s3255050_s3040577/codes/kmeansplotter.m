function kmeansplotter(K)
data = load('kmeans1');
data = data.kmeans1;

[classes, prototypesHistory] = kmeans(data, K);
iterations = size(prototypesHistory, 3);

% Plot 1: points and prototypes
figure(1);
scatter(data(:, 1), data(:, 2), 10, classes, 'DisplayName', 'Data points');
hold on;
lastPrototypes = prototypesHistory(:, :, iterations); 
scatter(lastPrototypes(:, 1), lastPrototypes(:, 2), ...
        70, [1:K]', 'filled', 'd', 'MarkerEdgeColor',[0 0 0], 'DisplayName', 'Prototypes');
xlabel('X');
ylabel('Y');
tt = sprintf('%d-Means clustering', K);
title(tt);
legend('show');
hold off;

% Plot 2: prototype movement
figure(2);
scatter(data(:, 1), data(:, 2), 10, classes);
hold on;
firstPrototypes = prototypesHistory(:, :, 1);
firstScatter = scatter(firstPrototypes(:, 1), firstPrototypes(:, 2), ...
        70, [1:K]', 'filled', 'o', 'MarkerEdgeColor',[0 0 0]);
    
for i = 2:iterations-1  
    previousPrototypes = prototypesHistory(:, :, i - 1);
    prototypes = prototypesHistory(:, :, i);
    
    intermediateScatter = scatter(prototypes(:, 1), prototypes(:, 2), ...
                    70, '+', 'MarkerEdgeColor', [0 0 0], 'LineWidth', 1.5);
    plotArrows(previousPrototypes, prototypes);
end

lastScatter = scatter(lastPrototypes(:, 1), lastPrototypes(:, 2), ...
        70, [1:K]', 'filled', 's', 'MarkerEdgeColor', [0 0 0]);
plotArrows(prototypesHistory(:, :, iterations - 1), lastPrototypes);

xlabel('X');
ylabel('Y');
tt = sprintf('%d-Means clustering prototype movement', K);
title(tt);

if K == 1
    legend([firstScatter lastScatter], ...
            'First prototypes', 'Last prototypes', 'Location', 'southwest');
else
    legend([firstScatter intermediateScatter lastScatter], ...
            'First prototypes', 'Intermediate prototypes', 'Last prototypes', 'Location', 'southwest');
end
hold off;
