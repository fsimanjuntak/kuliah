function assignment32()
%Given a mean and a covariance matrix, we generate a set of random numbers
%that fall within the normal distribution curve
mu = [3 4];
sigma = [1 0;0 2];
R = chol(sigma);
X = repmat(mu,100000,1) + randn(100000,2)*R;

%With the new generated values, we calculate the Mahalanobis distance
Y = [10 10;0 0;3 4;6 8];
d1 = mahal(Y,X)
scatter(X(:,1),X(:,2))
hold on
scatter(Y(:,1),Y(:,2),100,d1,'*','LineWidth',2)
xlabel('X')
ylabel('Y')
title('Mahalanobis distance plot')
hb = colorbar;
ylabel(hb,'Mahalanobis Distance')
legend('Sample Data from P.D.F. surface','Testing points','Location','NW');
end