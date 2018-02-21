function myhoughline(img,rho, theta)
    figure
    BW = imread(img);
    imshow(BW);
    title('Original picture');
    hold on;
    
    theta=degtorad(theta);
    %Having the initial data in polar coordinates, we convert them to
    %cartesian values
    [x,y]=pol2cart(theta, rho);
     
    %Considering the initial point is the center (0,0) we calculate the
    %slope of the rho line using the two points
    m = (y)/(x);
     
    %We calculate the perpendicular slope
    m2=(-1/m);
     
    %Given that we know a point in the perpendicular line, we calculate
    %its b value
    b2=y-m2*x;
     
    %Now  we generate a number of x values and plot the line
    xx=-500:10:500;
    yy=m2*xx+b2;
    plot(xx,yy,'Color','r','LineWidth',2)
    
    hold off;
    axis([-300,300,-300,300])
end