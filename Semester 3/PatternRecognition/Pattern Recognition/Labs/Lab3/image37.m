function image37()
    BW = imread('chess.jpg');
    BW=rgb2gray(BW);

    %Calculate the edges using canny's algorithm
    trans = edge(BW,'canny');

    %Generate the accumulator array to find the local maxima values
    [H,T,R] = hough(trans);
     figure
     imshow(imadjust(mat2gray(H)),'XData',T,'YData',R,...
           'InitialMagnification','fit');
     title('Hough transform accumulator array, showing top fifteen local maxima values(chess.jpg)');
     xlabel('\theta'), ylabel('\rho');
     axis on, axis normal, hold on;
     colormap(gca,hot);

     %Calculate the local maxima value
     disp(max(H(:)))

     %Top fifteen
     %Plot the maxima value on the accumulator array map
     P = houghpeaks(H,15,'threshold',ceil(0.5*max(H(:))));
     x = T(P(:,2));
     y = R(P(:,1));
     plot(x,y,'s','color','black');

     %Auto detect lines on the image, using 
     lines = houghlines(BW,T,R,P,'FillGap',100,'MinLength',80);
    
     %DISPLAY ORIGINAL IMAGE WITH LINES %SUPERIMPOSED
     figure, imshow(BW), hold on
     max_len = 0;
     for k = 1:length(lines)
         xy = [lines(k).point1; lines(k).point2];
         plot(xy(:,1),xy(:,2),'LineWidth',1,'Color','green');
     end 
     title('Fifteen strogest lines detected on the image (chess.jpg)');
     
end