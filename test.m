p2x = 238;
p2y = 304;
% 图2置入图1的位置 a b
a = 738;
b = 1240;
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