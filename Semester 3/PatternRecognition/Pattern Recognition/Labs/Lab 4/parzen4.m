function parzen4(h)

%We load the three categories files
load lab3_3_cat1.mat;
load lab3_3_cat2.mat;
load lab3_3_cat3.mat;

%Initialize the accumulators
sum_theta_u=zeros(3);
sum_theta_v=zeros(3);
sum_theta_w=zeros(3);

%Set the initial points
u=[0.5 1 0];
v=[0.31 1.51 -0.5];
w=[-1.7 -1.7 -1.7];

%For each point we calculate the sum of al the sample values
for i=1:length(x_w1(:,1))
     sum_theta_u(1)=sum_theta_u(1) + theta(h,u, x_w1(i,:));
     sum_theta_u(2)=sum_theta_u(2) + theta(h,u, x_w2(i,:));
     sum_theta_u(3)=sum_theta_u(3) + theta(h,u, x_w3(i,:));
     
     sum_theta_v(1)=sum_theta_v(1) + theta(h,v, x_w1(i,:));
     sum_theta_v(2)=sum_theta_v(2) + theta(h,v, x_w2(i,:));
     sum_theta_v(3)=sum_theta_v(3) + theta(h,v, x_w3(i,:));
     
     sum_theta_w(1)=sum_theta_w(1) + theta(h,w, x_w1(i,:));
     sum_theta_w(2)=sum_theta_w(2) + theta(h,w, x_w2(i,:));
     sum_theta_w(3)=sum_theta_w(3) + theta(h,w, x_w3(i,:));
end

%Normalize theta
norm_theta_u(1)=sum_theta_u(1)/(h*sqrt(2*pi))^3;
norm_theta_u(2)=sum_theta_u(2)/(h*sqrt(2*pi))^3;
norm_theta_u(3)=sum_theta_u(3)/(h*sqrt(2*pi))^3;

norm_theta_v(1)=sum_theta_v(1)/(h*sqrt(2*pi))^3;
norm_theta_v(2)=sum_theta_v(2)/(h*sqrt(2*pi))^3;
norm_theta_v(3)=sum_theta_v(3)/(h*sqrt(2*pi))^3;

norm_theta_w(1)=sum_theta_w(1)/(h*sqrt(2*pi))^3;
norm_theta_w(2)=sum_theta_w(2)/(h*sqrt(2*pi))^3;
norm_theta_w(3)=sum_theta_w(3)/(h*sqrt(2*pi))^3;

%Divide by the number of points
new_theta_u(1)= norm_theta_u(1)/length(x_w1(:,1));
new_theta_u(2)= norm_theta_u(2)/length(x_w2(:,1));
new_theta_u(3)= norm_theta_u(3)/length(x_w3(:,1));

new_theta_v(1)= norm_theta_v(1)/length(x_w1(:,1));
new_theta_v(2)= norm_theta_v(2)/length(x_w2(:,1));
new_theta_v(3)= norm_theta_v(3)/length(x_w3(:,1));

new_theta_w(1)= norm_theta_w(1)/length(x_w1(:,1));
new_theta_w(2)= norm_theta_w(2)/length(x_w2(:,1));
new_theta_w(3)= norm_theta_w(3)/length(x_w3(:,1));

%disp(new_theta_u)
%disp(new_theta_v)
%disp(new_theta_w)

%So far we have the probability function of each class, since we don't know the prior probabilities of the data, but we have the same amount of sample data of each class, we will use 1/3
%for each one
P1=1/3;
P2=1/3;
P3=1/3;

%We calculate the posterior probabilities of each class
PP_c1=[new_theta_u(1) new_theta_v(1) new_theta_w(1)]*P1;
PP_c2=[new_theta_u(2) new_theta_v(2) new_theta_w(2)]*P2;
PP_c3=[new_theta_u(3) new_theta_v(3) new_theta_w(3)]*P3;

disp(PP_c1)
disp(PP_c2)
disp(PP_c3)

function th=theta(h,u, class_data)
th=exp(-((u(1)-class_data(1))^2 + (u(2)-class_data(2))^2 + (u(3)-class_data(3))^2)/2*h^2);