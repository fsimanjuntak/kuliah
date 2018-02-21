function image33()
    %Create a black image with one white pixel
    img = false(50,50);
    img(20:20,4:4) = true;
    img(20:20,13:13) = true;
    img(20:20,24:24) = true;

    %# show the image
    figure,imshow(img)
    title('Original Image (three alligned white pixels)');
    xlabel('x'), ylabel('y');

    %Generate the accumulator array to find the local maxima values
    [H,T,R] = hough(img);
     figure
     imshow(imadjust(mat2gray(H)),'XData',T,'YData',R,...
           'InitialMagnification','fit');
     title('Hough transform accumulator array (three alligned pixels)');
     xlabel('\theta'), ylabel('\rho');
     axis on, axis normal, hold on;
     colormap(gca,hot);
end