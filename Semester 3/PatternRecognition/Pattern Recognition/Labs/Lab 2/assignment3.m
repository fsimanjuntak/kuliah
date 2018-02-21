function assignment3()
    mu = [3 4];
    Sigma = [1 0;0 2];
    x1 = -10:.2:10;
    x2 = -10:.2:10;
    [X,Y] = meshgrid(x1,x2);
    F = mvnpdf([X(:) Y(:)],mu,Sigma);
    F = reshape(F,length(x2),length(x1));

    mesh(X,Y,F)
    xlabel('X')
    ylabel('Y')
    title('Probability Density Function of 2 variables using mesh plot')
    zlabel('Probability Density')
end