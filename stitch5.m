% 下面的代码针对性较强，很多数值可能只能适用于作业中的合照。
% part5 根据匹配点对右图进行调整，寻找到变换后的关键点坐标

dY = Y2-Y1;
dX = X2-X1;
clear rY1 rY2 rX1 rX2
% calculate the distance in the  combined image, to get rid of bad points
% 对于一些错误匹配的点，通过计算平均距离以及每一对和平均的偏差，可以发现并去除outliers
ave_d = sqrt(dX.^2 + dY.^2);
right_points = find(ave_d < 1300 & ave_d > 1100);
% get the right points
rp = size(right_points);
%只要正确匹配的点
for i = 1:rp(2)
    rY1(i) = Y1(right_points(i));
    rY2(i) = Y2(right_points(i));
    rX1(i) = X1(right_points(i));
    rX2(i) = X2(right_points(i));
end
rdY = rY2-rY1;
rdX = rX2-rX1;

% 放大缩小比率：计算原图新图在ｘ　ｙ方向上的距离的比值，并求平均，得到缩放比例
for i = 1:rp(2)-1
    dY_in1(i) = rY1(i+1) - rY1(i);
    dX_in1(i) = rX1(i+1) - rX1(i);
end
for i = 1:rp(2)-1
    dY_in2(i) = rY2(i+1) - rY2(i);
    dX_in2(i) = rX2(i+1) - rX2(i);
end
% 去除重复点　发现二对一，去掉一个
quchu = find(dY_in2 + dX_in2 == 0);% 直接用unique 也可以
q = size(quchu); % rp(2)-q(2)是好点的个数
rY1(quchu) = [];
rX1(quchu) = [];
rX2(quchu) = [];
rY2(quchu) = [];
% 重新计算放大缩小比率
clear dX_in1 dX_in2 dY_in1 dY_in2
for i = 1:rp(2)-q(2)-1
    dY_in1(i) = rY1(i+1) - rY1(i);
    dX_in1(i) = rX1(i+1) - rX1(i);
end
for i = 1:rp(2)-q(2) -1
    dY_in2(i) = rY2(i+1) - rY2(i);
    dX_in2(i) = rX2(i+1) - rX2(i);
end
mean1= mean(dY_in2./dY_in1);
mean2 = mean(dX_in2./dX_in1);
% rate = (mean1+mean2)/2;
ji = dX_in2./dX_in1;
rate = mean(ji(end-4:end)); %其实是人工筛选，因为误差有些大 另外两个方向上误差也不同

% 计算旋转角度：通过计算对应点，图内其他点的连线斜率并比较得出合适的角度，然而效果不好，实际数值为人工筛选。
theta = -2.3684;
% delta_tangent1= ( dY_in1 ) ./ ( dX_in1 );
% theta1 = rad2deg(acot(delta_tangent1));
% delta_tangent2=  ( dY_in2 ) ./ ( dX_in2 );
% theta2 = rad2deg(acot(delta_tangent2));
% theta = mean(theta2-theta1);

% beifen
% delta_tangent1= ( rX1(1) - rX1(2) ) / ( rY1(1) - rY1(2) );
% theta1 = rad2deg(atan(delta_tangent1));
% delta_tangent2= ( rX2(1) - rX2(2) ) / ( rY2(1) - rY2(2) );
% theta2 = rad2deg(atan(delta_tangent2));
% theta = theta2-theta1;

%选转并缩放第二章图，确定关键点的新坐标
% xuannnzhuan
biglittled_D = yasuoer(D, 1/rate);
rrX = round(rX2 * 1/rate);
rrY = round((rY2-l-aida) * 1/rate);
% suofang
% rotated_D = rotateer(biglittled_D, theta);
rotated_D = imrotate(biglittled_D, theta);
biglittlesize = size(biglittled_D);
rPoints = [cos(deg2rad(theta)), -sin(deg2rad(theta)); sin(deg2rad(theta)), cos(deg2rad(theta))] * [rrX; rrY];
for i = 1:10
    rPoints(:, i) =  rPoints(:, i)  + [0; -biglittlesize(1) * tan(deg2rad(theta))];
end
% fff
rotatedsize =  size(rotated_D);
% plot(rPoints(2, :), rPoints(1,:), 'yo');

% 画出旋转缩放后的图，并对应起关键点
AD = zeros(max(h, rotatedsize(1)), l+rotatedsize(2)+aida, 3);
AD(1:h, 1:l,:) = A(:,:,:);
AD(1: rotatedsize(1), l+1+aida: l+rotatedsize(2)+aida,:) = rotated_D(:,:,:);
AD = uint8(AD);
figure, imshow(AD);
hold on;
plot(rY1, rX1, 'yo');
plot(rPoints(2, :)+aida+l, rPoints(1,:), 'ro');
for i = 1:10
    line([rY1(i),rPoints(2, i)+aida+l ],[rX1(i), rPoints(1,i)]);
end

