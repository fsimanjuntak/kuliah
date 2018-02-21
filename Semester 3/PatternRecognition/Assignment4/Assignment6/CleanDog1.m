% Reading the image and normalizing the picture
I = imread('dogGrayRipples.png');
I = double(mat2gray(I));
I = imresize(I, [256 256]);
I=I-mean(I(:));

% Doing a 2D fourier transform on the image and shifting the
% noise frequency to the center of the array
f = fftshift(fft2(I));
fabs=abs(f);

% Here is a notch filter that masks the periodic noise with 0
roi=3;thresh=400;
local_extr = ordfilt2(fabs, roi^2, ones(roi));  % find local maximum within 3*3 range
result = (fabs == local_extr) & (fabs > thresh);
[r, c] = find(result);
for i=1:length(r)
    % periodic noise locates in the position outside the 20-pixel-radius circle
    if (r(i)-128)^2 + (c(i)-128)^2 > 400   
        % zero the frequency components
        f( r(i)-2:r(i)+2 , c(i)-2:c(i)+2)=0;  
    end
end

% Finally reverse shift the frequency spectrum and reverse 2D fourier
% transform
Inew=ifft2(ifftshift(f));
imagesc(real(Inew)),colormap(gray)
