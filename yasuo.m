% meituxiuxiu.m �ĸ�������
function pout = yasuo(inputImg, x, y)

pin = inputImg;
[h, l, Tsudo] = size(pin);
pout = uint8(zeros(x, y, 3));
x_step = h/x; % Ӧ������ȡ�� %���ǲ�ȡ����
y_step = l/y;
for i = 1:x
    for j = 1:y
        pout(i, j, :) = pin(round(x_step * i), round(y_step * j), :);
    end
end
