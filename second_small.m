function [first1, second2] = second_small(a)
[t,index]=sort(a);%向量升序排序
index_m=find(t==t(1));%找到zuixiao值占有的位置
firstt = index(t == t(1)); % only need one
first1 = firstt(1);
target=t(index_m(end)+1);%找到第二xiao的值并显示
second = index(t==target);%显示第二xiao的值在原向量的位置
second2 = second(1); % only need one