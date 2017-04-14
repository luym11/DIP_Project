% part3，同part2

clear direction2 littlemain_direc2 xx yy histo_direc2
k = 8;
for i = 1:b(1)
    xx = xr2_s(i);
    yy = yr2_s(i);            
    for m = 1:2*k+1
            for n = 1:2*k+1
                xx = xr2_s(i) -k-1 + m;
                yy = yr2_s(i) - k - 1 + n;
                if( Gx2_g(xx,yy)>0 )
                    direction2{i}(m, n) =rad2deg(atan( Gy2_g(xx,yy) / Gx2_g(xx,yy) ));
                elseif(Gx2_g(xx,yy) < 0 && Gy2_g(xx,yy) > 0) 
                    direction2{i}(m, n) =180 + rad2deg(atan( Gy2_g(xx,yy) / Gx2_g(xx,yy)  ));
                else 
                    direction2{i}(m, n) =-180 + rad2deg(atan( Gy2_g(xx,yy) / Gx2_g(xx,yy)  )) ;
                end
                
                % set a threshold
                    grad_size2{i}(m,n) = sqrt( Gx2_g(xx,yy) ^2 +Gx2_g(xx,yy)^2 ) ;
                if( grad_size2{i}(m,n) < 2)
                    direction2{i}(m, n) = 361;
                end
                
            end
    end
end

% 寻找主方向
q=  [9 8.5 7.8 6 3.5 1 0.6 0.4 0.2];
col = 8;
for i = 1:b(1)
    histo_direc2{i} = [0 0 0 0 0 0 0 0];
    for m = 1:17
            for n = 1:17
%                 littlemain_direc{i}(m,n) = 1/16 * sum(direction{i}(4*m-3:4*m, 4*n-3:4*n)); 
                for j = 1:col
                    if(direction2{i}(m, n)+180>=mod(-22.5+45*(j-1), 360) & direction2{i}(m,n)+180 < mod(-22.5 + 45*j, 360))
                        if( m == 9 & n == 9 )
                            histo_direc2{i}(j) = histo_direc2{i}(j) + q(1)*grad_size2{i}(m,n);
                        elseif(n<=10 & n >= 8 & m <=10 &m>=8)
                            histo_direc2{i}(j) = histo_direc2{i}(j) + q(2)*grad_size2{i}(m,n);
                        elseif(n<=11 & n >= 7 & m <=11 &m>=7)
                            histo_direc2{i}(j) = histo_direc2{i}(j) +q(3)*grad_size2{i}(m,n);
                        elseif(n<=12 & n >= 6 & m <=12 &m>=6)
                            histo_direc2{i}(j) = histo_direc2{i}(j) + q(4)*grad_size2{i}(m,n);
                        elseif(n<=13 & n >= 5 & m <=13 &m>=5)
                            histo_direc2{i}(j) = histo_direc2{i}(j) + q(5)*grad_size2{i}(m,n);
                        elseif(n<=14 & n >= 4 & m <=14 &m>=4)
                            histo_direc2{i}(j) = histo_direc2{i}(j) + q(6)*grad_size2{i}(m,n);
                        elseif(n<=15 & n >= 3 & m <=15 &m>=3)
                            histo_direc2{i}(j) = histo_direc2{i}(j) + q(7)*grad_size2{i}(m,n);
                        elseif(n<=16 & n >= 2 & m <=16 &m>=2)
                            histo_direc2{i}(j) = histo_direc2{i}(j) + q(8)*grad_size2{i}(m,n);
                        else
                            histo_direc2{i}(j) = histo_direc2{i}(j) + q(9)*grad_size2{i}(m,n);
                        end
                       
                    end
                end
            end
            % 1 for value, 2 for index
            [value2, index2] = max(histo_direc2{i});
            main_direc2{i} = [value2, index2]; %%% KEY
            for o = 1:col
                if(mod(main_direc2{i}(2) -1 +o, col)  == 0)
                    ttt = col;
                else
                    ttt= mod(main_direc2{i}(2) -1 +o, col) ;
                end
                r_histo_direc2{i}(o) = histo_direc2{i}( ttt);
            end
    end
    
end

for i = 1:b(1)
    main_direction2(i) = main_direc2{i}(2);
end

% 2 draw directions
for i = 1:b(1)
    switch main_direction2(i)
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
figure(2);
for i = 1:b(1)
    for j = 1:col
    quiver(yr2_s(i), xr2_s(i), draw_direction_x(i), draw_direction_y(i),  histo_direc2{i}(main_direction2(i)) *1/100  );
    end
end

% 基于主方向，制造128维特征向量
% using direction(a(1)个17*17矩阵) and main_direction (a(1)个值的向量）
qq = [9 8.5 7.8 6 3.5 1 0.6 0.4 0.2];
clear littlemain_direc2 xx yy histo_direc2
col = 8; % 分八个方向统计
for i = 1:b(1)
    for m = 1:17
           for n = 1:17
                    if( m == 9 & n == 9 )
                        weighted_grad_size2{i}(m,n) = qq(1)*grad_size2{i}(m,n);
                    elseif(n<=10 & n >= 8 & m <=10 &m>=8)
                        weighted_grad_size2{i}(m,n) =qq(2)*grad_size2{i}(m,n);
                    elseif(n<=11 & n >= 7 & m <=11 &m>=7)
                        weighted_grad_size2{i}(m,n) = qq(3)*grad_size2{i}(m,n);
                    elseif(n<=12 & n >= 6 & m <=12 &m>=6)
                        weighted_grad_size2{i}(m,n) =  qq(4)*grad_size2{i}(m,n);
                    elseif(n<=13 & n >= 5 & m <=13 &m>=5)
                        weighted_grad_size2{i}(m,n) = qq(5)*grad_size2{i}(m,n);
                    elseif(n<=14 & n >= 4 & m <=14 &m>=4)
                        weighted_grad_size2{i}(m,n) = qq(6)*grad_size2{i}(m,n);
                    elseif(n<=15 & n >= 3 & m <=15 &m>=3)
                        weighted_grad_size2{i}(m,n) = qq(7)*grad_size2{i}(m,n);
                    elseif(n<=16 & n >= 2 & m <=16 &m>=2)
                        weighted_grad_size2{i}(m,n) =  qq(8)*grad_size2{i}(m,n);
                    else
                        weighted_grad_size2{i}(m,n) = qq(9)*grad_size2{i}(m,n);
                    end
           end
    end
end  

for i = 1:b(1)
     noo = 0;
     part_direction2{i} = zeros(1, 128);
     kari_part_direction2{i} = zeros(1, 128);
        for m = 1:4
            for n = 1:4
                % 计算128个位置用
                noo = noo + 1;
                for mm = 4*(m-1)+1 : 4*m
                    for nn = 4*(n-1)+1 : 4*n
                        for j = 1:col
                             if(direction2{i}(m, n)+180>=mod(-22.5+45*(j-1), 360) & direction2{i}(m,n)+180 < mod(-22.5 + 45*j, 360))
                             kari_part_direction2{i}((noo-1)*8 + j ) =  kari_part_direction2{i}((noo-1)*8 + j ) + weighted_grad_size2{i}(mm,nn);
                             end
                        end
                    end
                end
                direc = main_direction2(i);
                for o = 1:col
                    if(mod(direc -1 +o, col)  == 0)
                        ttt = col;
                    else
                        ttt= mod(direc -1 +o, col) ;
                    end
                    part_direction2{i}((noo-1)*8 + o) = kari_part_direction2{i}((noo-1)*8 + ttt);
                end
            end
        end
end