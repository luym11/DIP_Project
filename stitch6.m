% part6 ȡĳ�Ը����ʵĹؼ����࣬2ͼ�ƶ���1ͼ�������ظ�λ�ã��õ�stitched image
AD = zeros(max(h, rotatedsize(1)), l+rotatedsize(2)+aida, 3);
AD(1:h, 1:l,:) = A(:,:,:);
AD(1: rotatedsize(1), l+1+aida: l+rotatedsize(2)+aida,:) = rotated_D(:,:,:);
AD = uint8(AD);
ddY = round(rPoints(2, 2) +aida+l - rY1(2)); % rPoints�ĵڶ��������Ǵӵڼ�������㿪ʼƴ
ddX = round(rPoints(1,2) - rX1(2));
for i = 1: rotatedsize(1)
    for j = round(rPoints(2, 2))+aida+l: l+rotatedsize(2)+aida 
        if( (i-ddX) > 1 & (j - ddY)>1)
        AD(i-ddX, j-ddY, :) = AD(i,j, :);
        AD(i, j, :) = [0 0 0];
        end
    end
end
figure, imshow(AD);     