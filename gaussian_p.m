function [Ix, Iy] = gaussian_filter(in_Ix, in_Iy)
sigma = 7;
g = fspecial('gaussian',fix(6*sigma), sigma);

Ix = imfilter(in_Ix, g, 'same'); 
Iy = imfilter(in_Iy, g, 'same');