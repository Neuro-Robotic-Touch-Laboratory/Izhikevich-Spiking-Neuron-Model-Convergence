%% ricordarsi di loadare le matrici opportune 

hold on

costo = 3;


r1 = squeeze(DISTANCES_rk1(costo,:,:));
r2 = squeeze(DISTANCES_rk2(costo,:,:));

x = [];
y = x;
indx = x;
indy = x; 

for z=1:numel(correnti)
    
    flag = 0;
    ind = size(r1,1);
    
    for s = 1:size(r1,1)
        
        if(r1(ind-s+1,z)<r2(ind-s+1,z) && flag == 0)
            flag = 1;
            x = [x correnti(z)];
            y = [y lista_flops(ind-s+1)];
            indx = [indx z];
            indy = [indy ind-s+1];
            
        else
            flag = 0;
        end
    end
    
    
end
    
    


for i = 1:numel(correnti)
    z(i) = r1(indy(i),i)-0.01;
end


figure
scatter(x,y);
[a,b] = polyfit(x,y,1);
hold on
plot(x,a(1)*x+a(2));

