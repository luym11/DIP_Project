% image fusion 已封装并附说明
% 20160430: 还需要修订。感觉不是118行边缘部分也要迭代，
% 就是除邻居个数也应该是4.总之在初值是原图的时候有点不太好。
% 附属代码：无
clear all;
% 需要输入的东西：
% 两张图片 p p2_in 
% 压缩后p2的新大小 p2x p2y
p2x = 278;
p2y = 198;
% 图2置入图1的位置 a b
a = 818;
b = 1320;
% 根据注释的说明选择初值
% 设置迭代次数，或者其他的停止条件

% 读入图1
% p = imread('starry_night.jpg');
% p = imread('part1.jpeg');
p = imread('des.jpg');
% r  = p(:,:,1); 
% g = p(:,:,2);
% b = p(:,:,3); % 和后面的关键变量重名，如果要使用，需改名
[h, l, Tsudo] = size(p);

% 读入图2
% p2_in = imread('akamon.JPG');
p2_in = imread('untitled.jpg');

% 按照实际情况进行压缩（这个函数不能放大)
p2 = yasuo(p2_in, p2x, p2y);
% p2 = yasuo(p2_in, 403, 420); doge's
% p2 = yasuo(p2_in, 420, 438); alison's
% 270, 180 hwk's
% 313， 209
% 270, 180

% r2  = p2(:,:,1); 
% g2 = p2(:,:,2);
% b2 = p2(:,:,3);
[h2, l2, Tsudo2] = size(p2);

% set up a mask，标记寸照中的白色背景，对于普通图可能会无效。
p2_mask = p2(:,:,1);
p2_mask(p2_mask <= 250) = 1;
p2_mask(p2_mask>250) = 0;
p2_mask(p2_mask == 1) = 255;

% add a gild to p2，按照算法要求，先给图2加一层图1值的外框，到时候写循环方便

% 造一个新的pp2代替p2，填充除了外框的部分
pp2 = uint8(zeros(h2 + 2, l2 + 2, 3));
pp2(2:h2+1, 2:l2+1, :) = p2(:,:,:);
% 选择图2置入图1的左上角位置
% a = 850;
% b = 1265;
% hwk's
% a = 760;
% b = 1857;
% % alison's
% a = 190;
% b = 330;
% % doge‘是
% a = 204;
% b = 338;

% 加外框
for i = 1:3
    pp2(1:h2 + 2, 1, i) = p(a:a+h2 + 2 -1, b - 1, i);
    pp2(1:h2 + 2, l2 + 2, i) = p(a:a+h2 + 2 -1, b + l2 + 1 - 1, i);
    pp2(1, 1:l2 + 2, i) = p(a - 1, b:b + l2 + 2 -1, i);
    pp2(h2 + 2, 1:l2 + 2, i) = p(a + h2 + 1 - 1, b:b + l2 + 2 -1, i);
end 

% 开一个新的用来放处理后的图2
p3 = uint8(zeros(h2 + 2, l2 + 2, 3));
% 对迭代算法取初值：超重要！！！
%%% 初值啊！！！想和背景融合例如星空，就要取背景的相应位置为初值；想加一个人脸，就要取图2自身的颜色为初值。
% 背景初值
% p3(1:h2+2,1:l2+2,:) = p(a:a+h2+1, b:b+l2+1, :);
% 自身初值
p3(1:h2+2,1:l2+2,:) = pp2(1:h2+2, 1:l2+2, :);

% 本段按需索取，本段用来给mask后除掉的区域填充背景作为初值
for i = 2:h2+1
    for j = 2:l2+1
        if(p2_mask(i-1, j-1) == 255)
            p3(i, j, :) = pp2(i, j, :);
        else
            p3(i, j, :) = p(a-1+i, b-1+j, :);
        end
    end
end

% p3加框
for i = 1:3
    p3(1:h2 + 2, 1, i) = p(a:a+h2 + 2 -1, b - 1, i);
    p3(1:h2 + 2, l2 + 2, i) = p(a:a+h2 + 2 -1, b + l2 + 1 - 1, i);
    p3(1, 1:l2 + 2, i) = p(a - 1, b:b + l2 + 2 -1, i);
    p3(h2 + 2, 1:l2 + 2, i) = p(a + h2 + 1 - 1, b:b + l2 + 2 -1, i);
end

% 拿衣服！这种玩意能用吗
% RR3 = fminsearch(@sigma_minGrad, R3, [], R2);

% iteratively solve the equation
% 分RGB三个通道递推求解paper中的方程

% 分通道
R2 = double(pp2(:,:,1));
R3 = double(p3(:,:,1));
G2 = double(pp2(:,:,2));
G3 = double(p3(:,:,2));
B2 = double(pp2(:,:,3));
B3 = double(p3(:,:,3));
ss([1:1000], 1) = 0;

% 见公式。分别是边缘的和内部的。边缘部分分别考虑在角上和不在角上。
% 边缘部分。此部分不用迭代
for i = 2:h2+1
        for j = 2:l2+1
                if( i == 2 || j == 2 || i == h2+1 || j == l2+1)
                    if( i == 2 && j ==2)
                        R3(i, j) = ( ( R3(i+1, j) + R3(i, j+1) ) + ( R3(i, j-1) + R3(i-1, j) ) + ( 2 * R2(i, j) - R2(i+1, j) - R2(i, j+1) ) )/2;
                        G3(i, j) = ( ( G3(i+1, j) + G3(i, j+1) ) + ( G3(i, j-1) + G3(i-1, j) ) + ( 2 * G2(i, j) - G2(i+1, j) - G2(i, j+1) ) )/2;
                        B3(i, j) = ( ( B3(i+1, j) + B3(i, j+1) ) + ( B3(i, j-1) + B3(i-1, j) ) + ( 2 * B2(i, j) - B2(i+1, j) - B2(i, j+1) ) )/2;
                    elseif( i == 2 && j == l2+1)
                        R3(i, j) = ( ( R3(i+1, j) + R3(i, j-1) ) + ( R3(i, j+1) + R3(i-1, j) ) + ( 2 * R2(i, j) - R2(i+1, j) - R2(i, j-1) ) )/2;
                        G3(i, j) = ( ( G3(i+1, j) + G3(i, j-1) ) + ( G3(i, j+1) + G3(i-1, j) ) + ( 2 * G2(i, j) - G2(i+1, j) - G2(i, j-1) ) )/2;
                        B3(i, j) = ( ( B3(i+1, j) + B3(i, j-1) ) + ( B3(i, j+1) + B3(i-1, j) ) + ( 2 * B2(i, j) - B2(i+1, j) - B2(i, j-1) ) )/2;
                    elseif( i == h2+1 && j == 2)
                        R3(i, j) = ( ( R3(i-1, j) + R3(i, j+1) ) + ( R3(i, j-1) + R3(i+1, j) ) + ( 2 * R2(i, j) - R2(i-1, j) - R2(i, j+1) ) )/2;
                        G3(i, j) = ( ( G3(i-1, j) + G3(i, j+1) ) + ( G3(i, j-1) + G3(i+1, j) ) + ( 2 * G2(i, j) - G2(i-1, j) - G2(i, j+1) ) )/2;
                        B3(i, j) = ( ( B3(i-1, j) + B3(i, j+1) ) + ( B3(i, j-1) + B3(i+1, j) ) + ( 2 * B2(i, j) - B2(i-1, j) - B2(i, j+1) ) )/2;
                    elseif(i == h2+1 && j == l2+1)
                        R3(i, j) = ( ( R3(i-1, j) + R3(i, j-1) ) + ( R3(i, j+1) + R3(i+1, j) ) + ( 2 * R2(i, j) - R2(i-1, j) - R2(i, j-1) ) )/2;
                        G3(i, j) = ( ( G3(i-1, j) + G3(i, j-1) ) + ( G3(i, j+1) + G3(i+1, j) ) + ( 2 * G2(i, j) - G2(i-1, j) - G2(i, j-1) ) )/2;
                        B3(i, j) = ( ( B3(i-1, j) + B3(i, j-1) ) + ( B3(i, j+1) + B3(i+1, j) ) + ( 2 * B2(i, j) - B2(i-1, j) - B2(i, j-1) ) )/2;
                    elseif( i == 2)
                        R3(i, j) = ( ( R3(i, j+1) + R3(i+1, j) + R3(i, j-1) ) + R3(i-1, j) + ( 3* R2(i, j) - R2(i, j+1) -R2(i+1, j) - R2(i, j-1) ) )/3;
                        G3(i, j) = ( ( G3(i, j+1) + G3(i+1, j) + G3(i, j-1) ) + G3(i-1, j) + ( 3* G2(i, j) - G2(i, j+1) - G2(i+1, j) - G2(i, j-1) ) )/3;
                        B3(i, j) = ( ( B3(i, j+1) + B3(i+1, j) + B3(i, j-1) ) + B3(i-1, j) + ( 3* B2(i, j) - B2(i, j+1) - B2(i+1, j) - B2(i, j-1) ) )/3;
                    elseif( i == h2+1)
                        R3(i, j) = ( ( R3(i, j+1) + R3(i-1, j) + R3(i, j-1) ) + R3(i+1, j) + ( 3* R2(i, j) - R2(i, j+1) - R2(i-1, j) - R2(i, j-1) ) )/3;
                        G3(i, j) = ( ( G3(i, j+1) + G3(i-1, j) + G3(i, j-1) ) + G3(i+1, j) + ( 3* G2(i, j) - G2(i, j+1) - G2(i-1, j) - G2(i, j-1) ) )/3;
                        B3(i, j) = ( ( B3(i, j+1) + B3(i-1, j) + B3(i, j-1) ) + B3(i+1, j) + ( 3* B2(i, j) - B2(i, j+1) - B2(i-1, j) - B2(i, j-1) ) )/3;
                    elseif( j == 2)
                        R3(i, j) = ( ( R3(i, j+1) + R3(i+1, j) + R3(i-1, j) ) + R3(i, j-1) + ( 3* R2(i, j) - R2(i, j+1) - R2(i+1, j) - R2(i-1, j) ) )/3;
                        G3(i, j) = ( ( G3(i, j+1) + G3(i+1, j) + G3(i-1, j) ) + G3(i, j-1) + ( 3* G2(i, j) - G2(i, j+1) - G2(i+1, j) - G2(i-1, j) ) )/3;
                        B3(i, j) = ( ( B3(i, j+1) + B3(i+1, j) + B3(i-1, j) ) + B3(i, j-1)+ ( 3* B2(i, j) - B2(i, j+1) - B2(i+1, j) - B2(i-1, j) ) )/3;
                    else %(j == l2+1)
                        R3(i, j) = ( ( R3(i, j-1) + R3(i+1, j) + R3(i-1, j) ) + R3(i, j+1) + ( 3* R2(i, j) - R2(i, j-1) - R2(i+1, j) - R2(i-1, j) ))/3;
                        G3(i, j) = ( ( G3(i, j-1) + G3(i+1, j) + G3(i-1, j) ) + G3(i, j+1) + ( 3* G2(i, j) - G2(i, j-1) - G2(i+1, j) - G2(i-1, j) ) )/3;
                        B3(i, j) = ( ( B3(i, j-1) + B3(i+1, j) + B3(i-1, j) ) + B3(i, j+1)+ ( 3* B2(i, j) - B2(i, j-1) - B2(i+1, j) - B2(i-1, j) ) )/3;
                    end
                end
        end
end

% 内部的点。迭代算法。设置了两种停止条件，目前使用的是迭代150次
k = 0;
while(1)
    R33 = R3;
    G33 = G3;
    B33 = B3;
    k = k + 1;
    for i = 3:h2
        for j = 3:l2
                Np = 4;
                R3(i, j) = ( ( R2(i, j) * Np - R2(i+1, j) - R2(i-1, j) - R2(i, j+1) - R2(i, j-1) ) + ( R33(i+1, j) + R33(i-1, j) + R33(i, j+1) + R33(i, j-1) ) )/Np;
                G3(i, j) = ( ( G2(i, j) * Np - G2(i+1, j) - G2(i-1, j) - G2(i, j+1) - G2(i, j-1) ) + ( G33(i+1, j) + G33(i-1, j) + G33(i, j+1) + G33(i, j-1) ) )/Np;
                B3(i, j) = ( ( B2(i, j) * Np - B2(i+1, j) - B2(i-1, j) - B2(i, j+1) - B2(i, j-1) ) + ( B33(i+1, j) + B33(i-1, j) + B33(i, j+1) + B33(i, j-1) ) )/Np;
         end
    end
%另一种停止条件。两次的结果相差较小时停止
%     if(abs(sum(R3(:)) - sum(R3(:))) <= 1)
%     ss(k) = abs(sum(R3(:)) - sum(R33(:)));
    if( k ==150)
        break;
    end
end


% 转换为uint8
p3(:,:,1) = uint8(R3);
p3(:,:,2) = uint8(G3);
p3(:,:,3) = uint8(B3);

% 使边缘不那么明显，进行高斯模糊
H = fspecial('gaussian', [3,3]);

% 和原图的背景融合，把mask的部分填回背景图的颜色值
for i = 2:h2+1
    for j = 2:l2+1
        if(p2_mask(i-1, j-1) == 255)
            p3(i-1:i+1, j-1:j+1, :) = imfilter(p3(i-1:i+1, j-1:j+1, :), H, 'replicate');
            % p3(i, j, :) = pp2(i, j, :);
        else
            p3(i, j, :) = p(a-1+i, b-1+j, :);
            %p3(i-1:i+1, j-1:j+1, :) = imfilter(p3(i-1:i+1, j-1:j+1, :), H, 'replicate');
        end
    end
end


% 按照给出的替换位置进行替换，把p过的图2叠到p1上去
for i = 1:h2+2
    for j = 1:l2+2
         p(a-2+i, b-2+j, :) = p3(i, j, :);
    end
end
figure,imshow(p);

