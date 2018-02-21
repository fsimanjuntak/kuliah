function optimal_k()

load lab3_2.mat;
data = lab3_2;
data_size = size(data, 1);
nr_of_classes = 4;

% Class labels
class_labels = floor( (0:length(data)-1) * nr_of_classes / length(data) );

error_rates = zeros(13, 1);

for K = 1:2:25
    errors = 0;
    for leave_out_index = 1:data_size
        data_copy = data;
        point = data_copy(leave_out_index, :);
        data_copy(leave_out_index, :) = [];
        
        assigned_class = KNN(point, K, data_copy, class_labels);
        real_class = class_labels(leave_out_index);
        is_error = assigned_class ~= real_class;
        
        errors = errors + is_error;
    end
    index = floor(K/2) + 1;
    error_rates(index) = errors/data_size;
end

plot([1:2:25], error_rates, '-o');
title('Error rate for K-nearest neighbor by leave-one-out validation method');
set(gca, 'XTick', [1:2:25]);
axis([1 25 0.2 0.6]);
xlabel('K');
ylabel('Error rate');

