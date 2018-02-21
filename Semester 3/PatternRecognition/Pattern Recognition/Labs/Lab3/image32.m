function image32()
    %Create a black image with one white pixel
    img = false(50,50);
    img(3:3,4:4) = true;
    img(10:10,10:10) = true;
    img(22:22,4:4) = true;

    %# show the image
    figure,imshow(img)
    title('Original Image (three unalligned white pixels)')
    xlabel('x'), ylabel('y');

    %Generate the accumulator array to find the local maxima values
    [H,T,R] = hough(img);
     figure
     imshow(imadjust(mat2gray(H)),'XData',T,'YData',R,...
           'InitialMagnification','fit');
     title('Hough transform accumulator array (three unaligned pixels)');
     xlabel('\theta'), ylabel('\rho');
     axis on, axis normal, hold on;
     colormap(gca,hot);
end