function assignment1()
    matr=[4 5 6;6 3 9;8 7 3;7 4 8;4 6 5];
    mn=mean(matr);
    cvr=cov(matr);
    [U,L] = eig(cvr);
    % For N standard deviations spread of data, the radii of the eliipsoid will
    % be given by N*SQRT(eigenvalues).
    N = 1;
    radii = N*sqrt(diag(L));

    % generate data for "unrotated" ellipsoid
    [xc,yc,zc] = ellipsoid(0,0,0,radii(1),radii(2),radii(3));

    % rotate data with orientation matrix U and center M
    a = kron(U(:,1),xc); 
    b = kron(U(:,2),yc); 
    c = kron(U(:,3),zc);
    data = a+b+c; 
    n = size(data,2);
    x = data(1:n,:)+mn(1); 
    y = data(n+1:2*n,:)+mn(2); 
    z = data(2*n+1:end,:)+mn(3);

    % now plot the rotated ellipse
    sc = surf(x,y,z);
    shading interp
    title('Multivariate probability density distribution')
    axis equal
    xlabel('Feature 1');
    ylabel('Feature 2');
    zlabel('Feature 3');
    alpha(0.5)
    
    hold on
    
    scatter3(mn(1),mn(2),mn(3));
    hold off
    %===============================================
    
    %Compute the multivariance probability density function
    x1=[5 5 6];
    x2=[3 5 7];
    x3=[4 6.5 1];
    F1 = mvnpdf(x1,mn,cvr);
    F2 = mvnpdf(x2,mn,cvr);
    F3 = mvnpdf(x3,mn,cvr);
    disp(F1)
    disp(F2)
    disp(F3)

end