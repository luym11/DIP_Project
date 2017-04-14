% 美图秀秀代码。分段使用，注释开相应的部分即可。
% 附属代码：yasuo.m

% point processing
clear all;

p = imread('pp.jpg');
r  = p(:,:,1); 
g = p(:,:,2);
b = p(:,:,3);
[h, l, Tsudo] = size(p);

% % original histogram and pic
% subplot(2,2,1);
% imhist(r);
% subplot(2,2,2);
% imhist(g);
% subplot(2,2,3);
% imhist(b);
% subplot(2,2,4);
% imshow(p);

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % 01 日系滤镜
% % s曲线
% a = 2;
% x = 0:255;
% LUT = 255 ./ (1+exp(-a*(x-127)/64));
% r1 = zeros(h, l);
% g1 = zeros(h, l);
% b1 = zeros(h, l);
% for i = 1:h
%     for j = 1:l
%         r1(i, j) = LUT(r(i, j)+1);
%         g1(i, j) = LUT(g(i, j)+1);
%         b1(i, j) = LUT(b(i, j)+1);
%     end
% end
% p1(:,:,1) = uint8(r1);
% p1(:,:,2) = uint8(g1);
% p1(:,:,3) = uint8(b1);
% % % subplot(1,2,1);
% % % imshow(p);
% % % subplot(1,2,2);
% imshow(p1);

% %%%%%%%%%%%%%%%%%%%%%%%%%%
% % 02 Increase brigtness
% x = 0:255;
% LUT = x + 60;
% LUT(LUT > 255) = 255;
% r2 = zeros(h, l);
% g2 = zeros(h, l);
% b2 = zeros(h, l);
% for i = 1:h
%     for j = 1:l
%         r2(i, j) = LUT(r(i, j)+1);
%         g2(i, j) = LUT(g(i, j)+1);
%         b2(i, j) = LUT(b(i, j)+1);
%     end
% end
% p2(:,:,1) = uint8(r2);
% p2(:,:,2) = uint8(g2);
% p2(:,:,3) = uint8(b2);
% % subplot(1,2,1);
% % imshow(p);
% % subplot(1,2,2);
% imshow(p2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 03 Decrease brigtness
x = 0:255;
LUT = x - 60;
LUT(LUT < 0) = 0;
r3 = zeros(h, l);
g3 = zeros(h, l);
b3 = zeros(h, l);
% for i = 1:h
%     for j = 1:l
%         r3(i, j) = LUT(r(i, j)+1);
%         g3(i, j) = LUT(g(i, j)+1);
%         b3(i, j) = LUT(b(i, j)+1);
%     end
% end
r3(:, :) = LUT(r(:, :)+1);
g3(:, :) = LUT(g(:, :)+1);
b3(:, :) = LUT(b(:, :)+1);

p3(:,:,1) = uint8(r3);
p3(:,:,2) = uint8(g3);
p3(:,:,3) = uint8(b3);
% subplot(1,2,1);
% imshow(p);
% subplot(1,2,2);
imshow(p3);

% %%%%%%%%%%%%%%%%%%%%%%%%%
% % 04 Increase Contrast
% x = 0:255;
% LUT = 2*(x-127) + 127;
% LUT(LUT > 255) = 255;
% LUT(LUT < 0) = 0;
% r4 = zeros(h, l);
% g4 = zeros(h, l);
% b4 = zeros(h, l);
% % for i = 1:h
% %     for j = 1:l
% %         r4(i, j) = LUT(r(i, j)+1);
% %         g4(i, j) = LUT(g(i, j)+1);
% %         b4(i, j) = LUT(b(i, j)+1);
% %     end
% % end
% r4(:, :) = LUT(r(:, :)+1);
% g4(:, :) = LUT(g(:, :)+1);
% b4(:, :) = LUT(b(:, :)+1);
% 
% p4(:,:,1) = uint8(r4);
% p4(:,:,2) = uint8(g4);
% p4(:,:,3) = uint8(b4);
% % subplot(1,2,1);
% % imshow(p);
% % subplot(1,2,2);
% imshow(p4);



% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % 06 histogram equalization
% % get the CDF 
% hr = imhist(r);
% hg = imhist(g);
% hb = imhist(b);
% 
% C_r(1) = hr(1, 1);
% for i = 2:256
%     C_r(i) = C_r(i-1) + hr(i, 1);
% end
% CDF_r = C_r / C_r(256);
% 
% C_g(1) = hg(1, 1);
% for i = 2:256
%     C_g(i) = C_g(i-1) + hg(i, 1);
% end
% CDF_g = C_g / C_g(256);
% 
% C_b(1) = hb(1, 1);
% for i = 2:256
%     C_b(i) = C_b(i-1) + hb(i, 1);
% end
% CDF_b = C_b / C_b(256);
% % equlization
% x = 0:255;
% r6 = zeros(h, l);
% g6 = zeros(h, l);
% b6 = zeros(h, l);
% % for i = 1:h
% %     for j = 1:l
% %         r6(i, j) = 255*CDF_r(r(i, j)+1);
% %         g6(i, j) = 255*CDF_g(g(i, j)+1);
% %         b6(i, j) = 255*CDF_b(b(i, j)+1);
% %     end
% % end
% 
% r6(:, :) = 255*CDF_r(r(:, :)+1);
% g6(:, :) = 255*CDF_g(g(:, :)+1);
% b6(:, :) = 255*CDF_b(b(:, :)+1);
%         
% p6(:,:,1) = uint8(r6);
% p6(:,:,2) = uint8(g6);
% p6(:,:,3) = uint8(b6);
% % subplot(1,2,1);
% % imshow(p);
% % subplot(1,2,2);
% imshow(p6);

% % 06.5 draw the histogram 画一下均质化以后的histogram
% Lu_p = 0.299*imhist(r) + 0.587*imhist(g) + 0.114*imhist(b);
% Lu_p6 = uint8(0.299*imhist(uint8(r6)) + 0.587*imhist(uint8(g6)) + 0.114*imhist(uint8(b6)));
% subplot(1,2,1);
% plot(Lu_p);
% subplot(1,2,2);
% plot(Lu_p6);

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % 07  histogram matching
% % get a paradigm of matching
% p_mat = imread('starry_night.jpg');
% r_mat  = p_mat(:,:,1); 
% g_mat = p_mat(:,:,2);
% b_mat = p_mat(:,:,3);
% [h_mat, l_mat, Tsudo_mat] = size(p_mat);
% 
% % get the CDF
% hr_mat = imhist(r_mat);
% hg_mat = imhist(g_mat);
% hb_mat = imhist(b_mat);
% 
% C_mat_r(1) = hr_mat(1, 1);
% for i = 2:256
%     C_mat_r(i) = C_mat_r(i-1) + hr_mat(i, 1);
% end
% CDF_mat_r = C_mat_r / C_mat_r(256);
% 
% C_mat_g(1) = hg_mat(1, 1);
% for i = 2:256
%     C_mat_g(i) = C_mat_g(i-1) + hg_mat(i, 1);
% end
% CDF_mat_g = C_mat_g / C_mat_g(256);
% 
% C_mat_b(1) = hb_mat(1, 1);
% for i = 2:256
%     C_mat_b(i) = C_mat_b(i-1) + hb_mat(i, 1);
% end
% CDF_mat_b = C_mat_b / C_mat_b(256);
% 
% % matching
% x = 0:255;
% LUT_m_r = zeros(256);
% LUT_m_g = zeros(256);
% LUT_m_b = zeros(256);
% for i = 2:256
%     for j = 2:256
%         if((CDF_r(i) >= CDF_mat_r(j-1)) && (CDF_r(i) < CDF_mat_r(j)))
%             LUT_m_r(i) = j;
%         end
%         if((CDF_g(i) >= CDF_mat_g(j-1)) && (CDF_g(i) < CDF_mat_g(j)))
%             LUT_m_g(i) = j;
%         end
%         if((CDF_b(i) >= CDF_mat_b(j-1)) && (CDF_b(i) < CDF_mat_b(j)))
%             LUT_m_b(i) = j;
%         end
%     end
% end
% 
% r7 = zeros(h, l);
% g7 = zeros(h, l);
% b7 = zeros(h, l);
% 
% % for i = 1:h
% %     for j = 1:l
% %         r7(i, j) = LUT_m_r(r(i, j)+1);
% %         g7(i, j) = LUT_m_g(g(i, j)+1);
% %         b7(i, j) = LUT_m_b(b(i, j)+1);
% %     end
% % end
% r7(:, :) = LUT_m_r(r(:, :)+1);
% g7(:, :) = LUT_m_g(g(:, :)+1);
% b7(:, :) = LUT_m_b(b(:, :)+1);
% 
% p7(:,:,1) = uint8(r7);
% p7(:,:,2) = uint8(g7);
% p7(:,:,3) = uint8(b7);
% subplot(1,2,1);
% imshow(p_mat);
% subplot(1,2,2);
% imshow(p7);

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % 08 Amaro Filter
% % increase brightness and contrast
% 
% % Increase brigtness
% x = 0:255;
% LUT = x + 30;
% LUT(LUT > 255) = 255;
% r8 = zeros(h, l);
% g8 = zeros(h, l);
% b8 = zeros(h, l);
% for i = 1:h
%     for j = 1:l
%         r8(i, j) = LUT(r(i, j)+1);
%         g8(i, j) = LUT(g(i, j)+1);
%         b8(i, j) = LUT(b(i, j)+1);
%     end
% end
% p8(:,:,1) = uint8(r8);
% p8(:,:,2) = uint8(g8);
% p8(:,:,3) = uint8(b8);
% % 
% % Decrease Contrast
% LUT = 0.8*(x-127) + 127;
% LUT(LUT > 255) = 255;
% LUT(LUT < 0) = 0;
% r9 = zeros(h, l);
% g9 = zeros(h, l);
% b9 = zeros(h, l);
% for i = 1:h
%     for j = 1:l
%         r9(i, j) = LUT(r8(i, j)+1);
%         g9(i, j) = LUT(g8(i, j)+1);
%         b9(i, j) = LUT(b8(i, j)+1);
%     end
% end
% p9(:,:,1) = uint8(r9);
% p9(:,:,2) = uint8(g9);
% p9(:,:,3) = uint8(b9);
% 
% % get the CDF_original
% hr = imhist(r);
% hg = imhist(g);
% hb = imhist(b);
% 
% C_r(1) = hr(1, 1);
% for i = 2:256
%     C_r(i) = C_r(i-1) + hr(i, 1);
% end
% CDF_r = C_r / C_r(256);
% 
% C_g(1) = hg(1, 1);
% for i = 2:256
%     C_g(i) = C_g(i-1) + hg(i, 1);
% end
% CDF_g = C_g / C_g(256);
% 
% C_b(1) = hb(1, 1);
% for i = 2:256
%     C_b(i) = C_b(i-1) + hb(i, 1);
% end
% CDF_b = C_b / C_b(256);
% 
% 
% % match the blue's histogram
% % get the CDF
% hr_mat = imhist(r);
% hg_mat = imhist(g);
% hb_mat = imhist(b);
% 
% C_mat_r(1) = hr_mat(1, 1);
% for i = 2:256
%     C_mat_r(i) = C_mat_r(i-1) + hr_mat(i, 1);
% end
% CDF_mat_r = C_mat_r / C_mat_r(256);
% 
% C_mat_g(1) = hg_mat(1, 1);
% for i = 2:256
%     C_mat_g(i) = C_mat_g(i-1) + hg_mat(i, 1);
% end
% CDF_mat_g = C_mat_g / C_mat_g(256);
% 
% C_mat_b(1) = hb_mat(1, 1);
% for i = 2:256
%     C_mat_b(i) = C_mat_b(i-1) + hb_mat(i, 1);
% end
% CDF_mat_b = C_mat_b / C_mat_b(256);
% 
% % matching
% x = 0:255;
% LUT_m_r = zeros(256);
% LUT_m_g = zeros(256);
% LUT_m_b = zeros(256);
% for i = 2:256
%     for j = 2:256
%         if((CDF_r(i) >= CDF_mat_r(j-1)) && (CDF_r(i) < CDF_mat_r(j)))
%             LUT_m_r(i) = j;
%         end
%         if((CDF_g(i) >= CDF_mat_g(j-1)) && (CDF_g(i) < CDF_mat_g(j)))
%             LUT_m_g(i) = j;
%         end
%         if((CDF_b(i) >= CDF_mat_b(j-1)) && (CDF_b(i) < CDF_mat_b(j)))
%             LUT_m_b(i) = j;
%         end
%     end
% end
% 
% r10 = zeros(h, l);
% g10 = zeros(h, l);
% b10 = zeros(h, l);
% r9 = p9(:,:,1);
% g9 = p9(:,:,2);
% b9 = p9(:,:,3);
% % for i = 1:h
% %     for j = 1:l
% %         r10(i, j) = LUT_m_b(r9(i, j)+1);
% %         g10(i, j) = LUT_m_b(g9(i, j)+1);
% %         b10(i, j) = LUT_m_b(b9(i, j)+1);
% %     end
% % end
% r10(:, :) = LUT_m_b(r9(:, :)+1);
% g10(:, :) = LUT_m_b(g9(:, :)+1);
% b10(:, :) = LUT_m_b(b9(:, :)+1);
% 
% p10(:,:,1) = uint8(r10);
% p10(:,:,2) = uint8(g10);
% p10(:,:,3) = uint8(b10);
% 
% % vignette effect
% p11 = funcVignettingEffect(p10, 0.6);
% 
% % subplot(1,2,1);
% % imshow(p);
% % subplot(1,2,2);
% imshow(p11);