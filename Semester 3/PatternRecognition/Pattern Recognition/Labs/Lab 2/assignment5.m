function assignment5()
    syms x1 x2
    g1=(-1*((x1-3)^2)/2-(((x2-5)^2)/8)+log(0.15));
    g2=(-1*((x1-2)^2)/4)-(((x2-1)^2)/2)+log(0.7)-log(sqrt(2));
    
    %Solve the quadratic equations system
    [x1, x2] = solve([g1-g2==0], [x1, x2]);
    x1=real(x1)
    disp(x2)
    
    %Plot the decision boundary
    ezplot((g1-g2))
    title('Decision Boundary')
end