function pout = yasuoer(inputImg, rate)

pin = inputImg;
[h, l, Tsudo] = size(pin);
pout = uint8(zeros(round(h*rate), round(l*rate), 3));
x_step = 1/rate; % 应该向上取整 %还是不取整了
y_step = 1/rate;
for i = 1:round(h*rate)
    for j = 1:round(l*rate)
        pout(i, j, :) = pin(round(x_step * i), round(y_step * j), :);
    end
end
