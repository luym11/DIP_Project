% meituxiuxiu.m 的附属代码
function pout = yasuo(inputImg, x, y)

pin = inputImg;
[h, l, Tsudo] = size(pin);
pout = uint8(zeros(x, y, 3));
x_step = h/x; % 应该向上取整 %还是不取整了
y_step = l/y;
for i = 1:x
    for j = 1:y
        pout(i, j, :) = pin(round(x_step * i), round(y_step * j), :);
    end
end
