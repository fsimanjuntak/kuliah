function class_label = KNN(newPoint, K, data, class_labels)
    %We initialize the control variables
    data_size = size(data, 1);
    euclidean_distance = zeros(data_size, 1);
    
    %For any given dimension size of the data matrix, we generate a loop
    %and obtain the euclidean distance of the point of interest compared to
    %all the points given on the data matrix
    for i = 1:data_size
       euclidean_distance(i) = pdist([newPoint; data(i,:)]);
    end
    
    %We then sort the distances in order to obtain the K smallest distances
    [~, I] = sort(euclidean_distance);
    
    %We look for the highest class occurence in the K nearest points
    k_nearest = I(1:K);
    most_frequent_index = mode(k_nearest);
    
    %Return the name of the predominant class, using the class_label vector
    class_label = class_labels(most_frequent_index);
    
       
       
    