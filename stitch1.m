% image stitcher code that took a whole week of mine
% holy shit

% part1 读入，做一些前处理，获取高斯模糊后的梯度平方计算出的R值，以及高斯模糊后的梯度。找到重要的角点
clear all;

%读入图片
A=imread('part1.jpeg');
% A=imread('kyoto.jpg');
B=rgb2gray(A);
% B = get_hinge(A);

[h, l, Tsudo] = size(A);


C=double(B);

% gradient
[Gx, Gy] = gradient(C);
R_HeC = zeros(h, l);
% 对需要计算R特征量的矩阵梯度平方做高斯模糊
[Gx_g, Gy_g, Gxy_g] = gaussian_filter(Gx, Gy);
R_HeC = ( Gx_g .* Gy_g  - Gxy_g .^ 2 ) ./ ( Gx_g + Gy_g );
% R_HeC = ( Gx .^2 + Gy .^2  - Gx.*Gy ) ./ ( Gx .^2 + Gy .^2 );

% 再替换成梯度的高斯模糊，后面要用
[Gx_g, Gy_g] = gaussian_p(Gx, Gy);

RR_HeC = R_HeC;

% 去除较小的R的点
R_HeC(R_HeC <= 500) = 0;
% R_HeC(R_HeC <= 1) = 0;
% 边缘变0
R_HeC([1:20, end-20:end], :) = 0;
R_HeC(:,[1:20,end-20:end]) = 0;
% 局部9个之中取最大，其他变0
Y=ordfilt2(R_HeC,900,ones(30,30));
R_HeC(R_HeC~=Y) = 0;
% get'em
[xr, yr, value] = find(R_HeC);



figure, imshow(B);
hold on;
plot(yr, xr, 'r*');

yr_s = yr(yr>l*2/3);
xr_s = xr(yr>l*2/3);
plot(yr_s, xr_s, 'b*');

D=imread('part2.jpeg');
% D=imread('stary2.jpg');
E=rgb2gray(D);
% E = get_hinge(D);

[h2, l2, Tsudo] = size(D);


F=double(E);

% gradient
[Gx2, Gy2] = gradient(F);
R_HeC2 = zeros(h2, l2);

[Gx2_g, Gy2_g, Gxy2_g] = gaussian_filter(Gx2, Gy2);
R_HeC2 = ( Gx2_g .* Gy2_g  - Gxy2_g .^ 2 ) ./ ( Gx2_g + Gy2_g );
% R_HeC2 = ( Gx2 .^2 + Gy2 .^2  - Gx2.*Gy2 ) ./ ( Gx2 .^2 + Gy2 .^2 );
[Gx2_g, Gy2_g] = gaussian_p(Gx2, Gy2);

RR_HeC2 = R_HeC2;

% 去除较小的R的点
R_HeC2(R_HeC2 <= 500) = 0;
% R_HeC2(R_HeC2 <= 1) = 0;
% 边缘变0
R_HeC2([1:20, end-20:end], :) = 0;
R_HeC2(:,[1:20,end-20:end]) = 0;
% 局部9个之中取最大，其他变0
Y2=ordfilt2(R_HeC2,900,ones(30,30));
R_HeC2(R_HeC2~=Y2) = 0;
% get'em
[xr2, yr2, value2] = find(R_HeC2);

figure, imshow(E);
hold on;
plot(yr2, xr2, 'r*');

% 标记出左右1/3的点，用它们计算，因为它们是重合区域
yr2_s = yr2(yr2<l2*1/3);
xr2_s = xr2(yr2<l2*1/3);
plot(yr2_s, xr2_s, 'b*');

a = size(xr_s);
b =size(xr2_s);