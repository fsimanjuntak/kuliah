function hough1()
    %Load and display the cameraman.tif image
    BW = imread('cameraman.tif');
    figure
    imshow(BW);
    title('Original picture (cameraman.tif)');

    %Calculate the edges using canny's algorithm
    trans = edge(BW,'canny');
    figure
    imshow(trans);
    title('Edge detection map using Canny algorithm');

    %Generate the accumulator array to find the local maxima values
    [H,T,R] = hough(trans);
     figure
     imshow(imadjust(mat2gray(H)),'XData',T,'YData',R,...
           'InitialMagnification','fit');
     title('Hough transform accumulator array, showing top five local maxima values(cameraman.tif)');
     xlabel('\theta'), ylabel('\rho');
     axis on, axis normal, hold on;
     colormap(gca,hot);

     %Calculate the local maxima value
     disp(max(H(:)))

     %Top five
     %Plot the maxima value on the accumulator array map
     P = houghpeaks(H,5,'threshold',ceil(0.835*max(H(:))));
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
     title('Five strogest lines detected on the image (cameraman.tif)');
     
     %Highest value
     %We can use our own function to plot the strongest line
     myhoughline('cameraman.tif', lines(1).rho, lines(1).theta);
     title('Strongest line (cameraman.tif)');
end