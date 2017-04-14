% part 4 计算关键点间距，寻找配对点

clear dis one_r_histo_direc one_r_histo_direc2 unordered first second
% flag一些本身就很小的0量。这些量会在后面计算关键点间距的时候伪装成间距很小的关键点对。
fa = 0;
flag = zeros(1,a(1));
for i = 1:a(1)
    if(sum(part_direction{i}) < 1000)
        fa = fa + 1;
        flag(i) = 1;
    end
end
fb = 0;
flag2 = zeros(1,b(1));
for i = 1:b(1)
    if(sum(part_direction2{i}) < 1000)
        fb = fb + 1;
        flag2(i) = 1;
    end
end

% 据说归一化可以消除光照影响，然而这段代码不是自己写的，感觉有问题，不采用
% for i  =1:a(1)
%     leg=sqrt(sum(part_direction{i}.^2));
%     one_r_histo_direc{i}=bsxfun(@rdivide, part_direction{i},leg); % r_histo_direc{i} part_direction{i}
% end
% for i  =1:b(1)
%     leg=sqrt(sum(part_direction2{i}.^2));
%     one_r_histo_direc2{i}=bsxfun(@rdivide,part_direction{i},leg); %  r_histo_direc2{i} part_direction2{i}
% end

% 对两张图的关键点对一一计算距离
for i = 1:a(1)
    for j = 1:b(1)
%         dis(i, j) = sum( (r_histo_direc{i} - r_histo_direc2{j}).^2 ); %
%         直接用判断主方向后的8维向量（整个17*17的统计结果）：效果不好

%         dis(i, j) = sum( (one_r_histo_direc{i} -
%         one_r_histo_direc2{j}).^2 ); % 归一化后的

        dis(i, j) = sum( (part_direction{i} - part_direction2{j}).^2 );
    end
end

% 将两张图放在一起，准备寻找对应点
aida = 20;
BE = zeros(max(h, h2), l+l2+aida);
BE(1:h, 1:l) = B;
BE(1: h2, l+1+aida: l+l2+aida) = E;
BE = uint8(BE);
figure, imshow(BE);
hold on;

% 用最小/次小 < 0.6的标准选配对点
clear match1x match2x match1y match2y value index
m_i = 1;
for i = 1:a(1)
    if(flag(i) ~= 1) % 不能是本来就很小的点
        [first(i), second(i)] = second_small(dis(i, :));
        unordered(i) = dis(i,first(i)) / dis(i, second(i));
        if(unordered(i) < 0.6 )
             match1x(m_i) = xr_s(i);
             match1y(m_i) = yr_s(i);
             plot(yr_s(i), xr_s(i), 'r*'); % 画左边点
             match2x(m_i) = xr2_s(first(i));
             match2y(m_i) = yr2_s(first(i));
             plot(match2y(m_i)+ aida + l, match2x(m_i), 'b*'); % 画相对应的右边点
             m_i = m_i + 1;

        end
    end
end

% [value, index] = sort(unordered);
% plot(yr_s(index(1:20)), xr_s(index(1:20)), 'g*');
[value, index] = sort(unordered);
start = find(value>0.03); % 再将结果中距离小的可疑的点去掉
plot(yr_s(index(start(1):start(1)+20)), xr_s(index(start(1):start(1)+20)), 'g*'); % 画距离最小的20对点在左图的位置
Start = start(1);

% link them together。连起来
for i = 1:20
    Y1(i) = yr_s(index(Start-1+i));
    Y2(i) = yr2_s(first(index(Start - 1 + i))) +aida + l;
    X1(i) = xr_s(index(Start-1+i));
    X2(i) = xr2_s(first(index(Start - 1 + i)));
end
% plot(Y1(1), X1(1), 'y*');
for i = 1:20
    line([Y1(i), Y2(i)],[X1(i), X2(i)]);
end