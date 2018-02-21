function plotArrows(previousPrototypes, prototypes)
  k = size(prototypes, 1);
  for i = 1:k
    plot_arrow(previousPrototypes(i, 1), previousPrototypes(i, 2), prototypes(i, 1), prototypes(i, 2)); 
  end
end