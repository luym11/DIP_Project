p2x = 238;
p2y = 304;
% ͼ2����ͼ1��λ�� a b
a = 738;
b = 1240;
% ����ע�͵�˵��ѡ���ֵ
% ���õ�������������������ֹͣ����

% ����ͼ1
% p = imread('starry_night.jpg');
% p = imread('part1.jpeg');
p = imread('des.jpg');
% r  = p(:,:,1); 
% g = p(:,:,2);
% b = p(:,:,3); % �ͺ���Ĺؼ��������������Ҫʹ�ã������
[h, l, Tsudo] = size(p);

% ����ͼ2
% p2_in = imread('akamon.JPG');
p2_in = imread('untitled.jpg');

% ����ʵ���������ѹ��������������ܷŴ�)
p2 = yasuo(p2_in, p2x, p2y);