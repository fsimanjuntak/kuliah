function kmeansquantization()
REPETITIONS = 30;

data = load('kmeans1');
data = data.kmeans1;
n = size(data, 1);

k_max = min(10, n);

J = zeros(k_max, 1);
for k = 1:k_max
    for time = 1:REPETITIONS
        [classes, prototypesHistory] = kmeans(data, k);
        lastPrototypes = prototypesHistory(:, :, size(prototypesHistory, 3));
        J(k) = J(k) + quantization_error(data, classes, lastPrototypes);
    end
end

J = J ./ REPETITIONS;

R = J(1).*(1./[1:k]'); % J(1)*k^(-2/d), d=2

D = R./J;

[~, k_opt] = max(D);

% Plot 1, D function with k_opt
figure(1);
d_plot = plot(D);
hold on;
k_opt_plot = plot(k_opt, 0, 'r*');
title('D(k) function');
xlabel('k');
ylabel('D');
xlim([1 10]);
legend([k_opt_plot d_plot], 'k_{opt}', 'D(k)');
hold off;

% Plot 2, R and J function with k_opt
figure(2);
j_plot = plot(J);
hold on;
r_plot = plot(R);
k_opt_plot = plot(k_opt, 0, 'r*');
title('R(k) and J(k) functions');
xlabel('k');
ylabel('f');
xlim([1 10]);
legend([k_opt_plot j_plot r_plot], 'k_{opt}', 'J(k)', 'R(k)');
hold off;
end
