function image36()
    %Create a black image with one white pixel
    img = false(50,50);
    img(20:20,4:4) = true;
    img(20:20,13:13) = true;
    img(20:20,24:24) = true;

    %Generate the accumulator array to find the local maxima values
    [H,T,R] = hough(img);
     figure
     imshow(imadjust(mat2gray(H)),'XData',T,'YData',R,...
           'InitialMagnification','fit');
     title('Hough transform accumulator array (three alligned pixels)');
     xlabel('\theta'), ylabel('\rho');
     axis on, axis normal, hold on;
     colormap(gca,hot);
     
     %Plot the maxima value on the accumulator array map
     P = houghpeaks(H,1,'threshold',ceil(0.1*max(H(:))));
     x = T(P(:,2));
     y = R(P(:,1));
     plot(x,y,'s','color','red');
     hold off
     
     %Auto detect lines on the image, using 
     lines = houghlines(img,T,R,P,'FillGap',100,'MinLength',5);
     
     %DISPLAY ORIGINAL IMAGE WITH LINES %SUPERIMPOSED
     figure, imshow(img), hold on
     max_len = 0;
     for k = 1:length(lines)
         xy = [lines(k).point1; lines(k).point2];
         plot(xy(:,1),xy(:,2),'LineWidth',1,'Color','green');
     end 
     title('Strogest line detected on the image ');
     xlabel('x'), ylabel('y');
end