function [a,b] = statistica(v1,v2,delay,F)

a = v2(1:F)-v1(1:F);
a = norm(a,1);

indexes = find(v1>delay);
v1_post = v1(indexes);

indexes = find(v2>delay);
v2_post = v2(indexes);


b = v2_post(1:F)-v1_post(1:F);
b = norm(b,1);



end