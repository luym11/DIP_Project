function [first1, second2] = second_small(a)
[t,index]=sort(a);%������������
index_m=find(t==t(1));%�ҵ�zuixiaoֵռ�е�λ��
firstt = index(t == t(1)); % only need one
first1 = firstt(1);
target=t(index_m(end)+1);%�ҵ��ڶ�xiao��ֵ����ʾ
second = index(t==target);%��ʾ�ڶ�xiao��ֵ��ԭ������λ��
second2 = second(1); % only need one