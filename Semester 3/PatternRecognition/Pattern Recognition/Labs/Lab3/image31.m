function image31()
    %Create a black image with one white pixel
    img = false(50,50);
    img(3:3,4:4) = true;

    %# show the image
    figure,imshow(img)
    title('Original Image (one white pixel)')
    xlabel('x'), ylabel('y');

    %Generate the accumulator array to find the local maxima values
    [H,T,R] = hough(img);
     figure
     imshow(imadjust(mat2gray(H)),'XData',T,'YData',R,...
           'InitialMagnification','fit');
     title('Hough transform accumulator array (single pixel)');
     xlabel('\theta'), ylabel('\rho');
     axis on, axis normal, hold on;
     colormap(gca,hot);
end