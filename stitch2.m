% part2 计算主方向，计算128维特征向量
clear direction littlemain_direc xx yy histo_direc;

% 对每一个关键像素点的周围2k范围内求各个邻居的梯度方向和大小,结果为direction{i}(m,n)和grad_size{i}(m,n)
k = 8;
for i = 1:a(1)
    xx = xr_s(i);
    yy = yr_s(i);            
    for m = 1:2*k+1
            for n = 1:2*k+1
                xx = xr_s(i) -k-1 + m;
                yy = yr_s(i) - k - 1 + n;
               if( Gx_g(xx,yy)>0 )
                    direction{i}(m, n) =rad2deg(atan( Gy_g(xx,yy) / Gx_g(xx,yy) ));
                elseif(Gx_g(xx,yy) < 0 && Gy_g(xx,yy) > 0) 
                    direction{i}(m, n) =180 + rad2deg(atan( Gy_g(xx,yy) / Gx_g(xx,yy)  ));
                else 
                    direction{i}(m, n) =-180 + rad2deg(atan( Gy_g(xx,yy) / Gx_g(xx,yy)  )) ;
                end
                
%                 set a threshold，把梯度绝对值太小的抛弃
                    grad_size{i}(m,n) = sqrt( Gx_g(xx,yy) ^2 +Gx_g(xx,yy)^2 ) ;
                if( grad_size{i}(m,n) < 2)
                    direction{i}(m, n) = 361; % 给出一个不会被算进去的角度
                end
                
            end
    end
end

% 分八个方向，用累加直方图的形式寻找主方向
q=  [9 8.5 7.8 6 3.5 1 0.6 0.4 0.2]; % 模仿高斯的权重
col = 8; % 八个方向 N S E S NE NW SE SW
for i = 1:a(1)
    histo_direc{i} = [0 0 0 0 0 0 0 0];
    for m = 1:17
            for n = 1:17
%                 littlemain_direc{i}(m,n) = 1/16 * sum(direction{i}(4*m-3:4*m, 4*n-3:4*n)); 
                for j = 1:col
                    if(direction{i}(m, n)+180>=mod(-22.5+45*(j-1), 360) & direction{i}(m,n)+180 < mod(-22.5 + 45*j, 360)) % 保证对中
                        if( m == 9 & n == 9 )
                            histo_direc{i}(j) = histo_direc{i}(j) + q(1)*grad_size{i}(m,n);
                        elseif(n<=10 & n >= 8 & m <=10 &m>=8)
                            histo_direc{i}(j) = histo_direc{i}(j) + q(2)*grad_size{i}(m,n);
                        elseif(n<=11 & n >= 7 & m <=11 &m>=7)
                            histo_direc{i}(j) = histo_direc{i}(j) + q(3)*grad_size{i}(m,n);
                        elseif(n<=12 & n >= 6 & m <=12 &m>=6)
                            histo_direc{i}(j) = histo_direc{i}(j) + q(4)*grad_size{i}(m,n);
                        elseif(n<=13 & n >= 5 & m <=13 &m>=5)
                            histo_direc{i}(j) = histo_direc{i}(j) + q(5)*grad_size{i}(m,n);
                        elseif(n<=14 & n >= 4 & m <=14 &m>=4)
                            histo_direc{i}(j) = histo_direc{i}(j) + q(6)*grad_size{i}(m,n);
                        elseif(n<=15 & n >= 3 & m <=15 &m>=3)
                            histo_direc{i}(j) = histo_direc{i}(j) + q(7)*grad_size{i}(m,n);
                        elseif(n<=16 & n >= 2 & m <=16 &m>=2)
                            histo_direc{i}(j) = histo_direc{i}(j) + q(8)*grad_size{i}(m,n);
                        else
                            histo_direc{i}(j) = histo_direc{i}(j) + q(9)*grad_size{i}(m,n);
                        end
                       
                    end
                end
            end
            % 对每个i点得到的八个方向的方向分布，按照最大者为第一其他依次的顺序重新排列
            [value, index] = max(histo_direc{i});
            main_direc{i} = [value, index]; %%% KEY
            for o = 1:col
                if(mod(main_direc{i}(2) -1 +o, col)  == 0)
                    ttt = col;
                else
                    ttt= mod(main_direc{i}(2) -1 +o, col) ;
                end
                r_histo_direc{i}(o) = histo_direc{i}( ttt);
            end
    end
    
end

% 最大方向的编号
for i = 1:a(1)
    main_direction(i) = main_direc{i}(2);
end

% draw directions，对每一个角点，画出主方向向量
for i = 1:a(1)
    switch main_direction(i)
        case 1
            draw_direction_x(i) = -1;
            draw_direction_y(i) = 0;
        case 2
            draw_direction_x(i) = -1;
            draw_direction_y(i) = -1;
        case 3
            draw_direction_x(i) = 0;
            draw_direction_y(i) = -1;
        case 4
            draw_direction_x(i) = 1;
            draw_direction_y(i) = -1;
        case 5
            draw_direction_x(i) = 1;
            draw_direction_y(i) = 0;
        case 6
            draw_direction_x(i) = 1;
            draw_direction_y(i) = 1;
        case 7
            draw_direction_x(i) = 0;
            draw_direction_y(i) = 1;
        case 8
            draw_direction_x(i) = -1;
            draw_direction_y(i) = 1;
    end
end

figure(1);
for i = 1:a(1)
    for j = 1:col
    quiver(yr_s(i), xr_s(i), draw_direction_x(i), draw_direction_y(i),  histo_direc{i}(main_direction(i)) *1/100  );
    end
end


% 基于主方向，制造128维特征向量
% 这次把1：16，1：16的矩阵分成16小块每块16个像素分别做八方向统计（在下一步已经赋权），然后用8*16=128维向量作为该点的特征向量，用来在下一步里比较距离
% using direction(a(1)个17*17矩阵【其实只用到16×16】) and main_direction (a(1)个值的向量）
qq = [9 8.5 7.8 6 3.5 1 0.6 0.4 0.2];
clear littlemain_direc xx yy histo_direc
col = 8; % 分八个方向统计
% 先按照离中心远近赋权
for i = 1:a(1)
    for m = 1:17
           for n = 1:17
                    if( m == 9 & n == 9 )
                        weighted_grad_size{i}(m,n) = qq(1)*grad_size{i}(m,n);
                    elseif(n<=10 & n >= 8 & m <=10 &m>=8)
                        weighted_grad_size{i}(m,n) = qq(2)*grad_size{i}(m,n);
                    elseif(n<=11 & n >= 7 & m <=11 &m>=7)
                        weighted_grad_size{i}(m,n) = qq(3)*grad_size{i}(m,n);
                    elseif(n<=12 & n >= 6 & m <=12 &m>=6)
                        weighted_grad_size{i}(m,n) =  qq(4)*grad_size{i}(m,n);
                    elseif(n<=13 & n >= 5 & m <=13 &m>=5)
                        weighted_grad_size{i}(m,n) = qq(5)*grad_size{i}(m,n);
                    elseif(n<=14 & n >= 4 & m <=14 &m>=4)
                        weighted_grad_size{i}(m,n) = qq(6)*grad_size{i}(m,n);
                    elseif(n<=15 & n >= 3 & m <=15 &m>=3)
                        weighted_grad_size{i}(m,n) = qq(7)*grad_size{i}(m,n);
                    elseif(n<=16 & n >= 2 & m <=16 &m>=2)
                        weighted_grad_size{i}(m,n) =  qq(8)*grad_size{i}(m,n);
                    else
                        weighted_grad_size{i}(m,n) = qq(9)*grad_size{i}(m,n);
                    end
           end
    end
end  

for i = 1:a(1)
     noo = 0;
     part_direction{i} = zeros(1, 128);
     kari_part_direction{i} = zeros(1, 128);
        for m = 1:4
            for n = 1:4
                % 计算128个位置用
                noo = noo + 1;
                for mm = 4*(m-1)+1 : 4*m
                    for nn = 4*(n-1)+1 : 4*n
                        for j = 1:col
                             if(direction{i}(m, n)+180>=mod(-22.5+45*(j-1), 360) & direction{i}(m,n)+180 < mod(-22.5 + 45*j, 360))
                             kari_part_direction{i}((noo-1)*8 + j ) =  kari_part_direction{i}((noo-1)*8 + j ) + weighted_grad_size{i}(mm,nn);
                             end
                        end
                    end
                end
                % 将kari_part_direction中的新加的8位数字按照主方向在先重新排列，填入part_direction
                direc = main_direction(i);
                for o = 1:col
                    if(mod(direc -1 +o, col)  == 0)
                        ttt = col;
                    else
                        ttt= mod(direc -1 +o, col) ;
                    end
                    part_direction{i}((noo-1)*8 + o) = kari_part_direction{i}((noo-1)*8 + ttt);
                end
            end
        end
end
                
                
                
                
                
                
                
                
                