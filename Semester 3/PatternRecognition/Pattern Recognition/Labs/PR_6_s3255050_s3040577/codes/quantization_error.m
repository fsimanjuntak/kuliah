function qe = quantization_error(data, classes, prototypes)
    % I do not use pdist because it would be redundant and inefficient to
    % square a sqrt
    qe = sum((data(:, 1) - prototypes(classes, 1)).^2 + ... 
                             (data(:, 2) - prototypes(classes, 2)).^2)/2;
end