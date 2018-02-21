close all;

% Read, resize and normalize the image for further filters
I = imread('dogGrayRipples.png');
I = double(mat2gray(I));
I = imresize(I, [256 256]);
[m,n] = size(I);

% We use the fourier transform for a 2D image
% fftshift is used to move the zero-frequency components to the center
f = fftshift(fft2(I));

% Filter the image using the notch filter on every pixel of the image
filter=ones(m,n);
for i=1:m-1
  for j=1:n-1
      limit =128;
  threshold = (i-limit)^2 + (j-limit)^2 <= 32^2 && (i-limit)^2 + (j-limit)^2 >=20^2; 
      if threshold
         filter(i,j)=0;
      end

  end
end
Filtered = f.*filter;

% We reverse transform the image to the original domain using ifft2 and
% resize it to its orginal form
G = abs(ifft2(ifftshift(Filtered)));
G = imresize(G, [300 332]);
figure,imshow(G,[]);
