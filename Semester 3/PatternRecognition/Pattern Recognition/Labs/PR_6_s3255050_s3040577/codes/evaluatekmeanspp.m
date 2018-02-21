K = 100;
RUNS = 20;

load checkerboard.mat

data = checkerboard;

J20 = zeros(RUNS, 1);
J20pp = zeros(RUNS, 1);
for i = 1:RUNS
    fprintf('run %d\n', i);
    [classes, prototypesHistory] = kmeans(data, K, false);
    lastPrototypes = prototypesHistory(:, :, size(prototypesHistory, 3));
    J20(i) = quantization_error(data, classes, lastPrototypes);
    
    [classes, prototypesHistory] = kmeans(data, K, true);
    lastPrototypes = prototypesHistory(:, :, size(prototypesHistory, 3));
    J20pp(i) = quantization_error(data, classes, lastPrototypes);
end

% Exercise b)
J20mean = mean(J20);
J20std = std(J20);

J20ppmean = mean(J20pp);
J20ppstd = std(J20pp);

% Exercise c)
[h, p] = ttest2(J20, J20pp, 'Vartype', 'unequal');

disp('Quantization error k-means:');
disp('Mean:');
disp(J20mean);
disp('Std:');
disp(J20std);

disp('Quantization error k-means++:');
disp('Mean:');
disp(J20ppmean);
disp('Std:');
disp(J20ppstd);

disp('p-value');
disp(p);
disp('Is it really better? (with 5% significance):');
if h
    disp('yes');
else
    disp('no');
end



