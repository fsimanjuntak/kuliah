function [classes, prototypesHistory] = kmeans(data, k, is_kmeanspp, initialize_file)
    if nargin < 4
       initialize_file = false;
       if nargin < 3
           is_kmeanspp = false;
       end
    end
    
    function classes = reassign(data, prototypes)
        % Compute distances between every point and prototype
        distances = pdist2(data, prototypes);
        % For every point, get the index of the prototype with min distance
        [~, classes] = min(distances, [], 2);
    end

    function prototype = selectPrototypeDx(Dsq)
        % Selects a prototype x with probability proportional to 
        % D(x, closestPrototype(x))
        sumDistances = sum(Dsq);
        randX = rand*sumDistances; % Get random in range (0, sumDistances)
        i = 1;
        accSum = Dsq(i);
        
        while randX > accSum
            i = i + 1;
            accSum = accSum + Dsq(i);
        end
        
        % Pick prototype in the position X where the cumulative sum is
        % greater than the random. Obviously elements with greater D(x)
        % will span a bigger portion of the range of the random number,
        % and thus the probability of selecting them will be higher
        prototype = data(i, :);
    end

n = size(data, 1);

prototypesHistory = [];

if is_kmeanspp
    % k-means++ prototype initialization
    prototypes = zeros(k, 2);
    prototypes(1, :) = data(randi(n), :);
    diff = data - repmat(prototypes(1, :), n, 1);
    % Not using pdist^2 cause it would be redundant and inneficient
    Dsq = diff(:, 1).^2 + diff(:, 2).^2;
    
    for prototypeIndex = 2:k-1
        prototypes(prototypeIndex, :) = selectPrototypeDx(Dsq);
        classes = reassign(data, prototypes(1:prototypeIndex, :));
        diff = prototypes(classes, :) - data;
        Dsq = diff(:, 1).^2 + diff(:, 2).^2;
    end
        
    if k > 1
        prototypes(k, :) = selectPrototypeDx(Dsq);
    end
elseif initialize_file
    sbrace = @(x,y)(x{y});
    fromfile = @(x)(sbrace(struct2cell(load(x)),1));
    prototypes=fromfile('clusterCentroids.mat');
else
    % Compute initial prototypes selecting k random points from data
    prototypes = data(randi(n, k, 1), :);
    
end

% Assign points to the prototype with minimum distance
classes = reassign(data, prototypes);

someReassigned = true;
it = 1;
while someReassigned
  prototypesHistory(:, :, it) = prototypes;
  it = it + 1;
 
  prototypes = zeros(k, 2); % Assume 2D data
  for i = 1:n % Compute sum vector of all vectors belonging to a specific prototype
      prototypes(classes(i), :) = prototypes(classes(i), :) + data(i, :);
  end
  
  % Compute mean vector dividing the sum vector by the number of points in
  % the prototype
  prototypes = prototypes ./ repmat(hist(classes, 1:k)', 1, 2);
  
  auxClasses = classes;
  classes = reassign(data, prototypes);
  someReassigned = ~isequal(auxClasses, classes);
end
prototypesHistory(:, :, it) = prototypes;

end