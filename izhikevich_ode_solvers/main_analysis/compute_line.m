%% ricordarsi di loadare le matrici opportune 

hold on

costo = 3;


r1 = squeeze(DISTANCES_rk1(costo,:,:));
r2 = squeeze(DISTANCES_rk2(costo,:,:));

x = nan(size(r1,2),1);
y = x;
indx = x;
indy = x; 

for z=1:numel(correnti)
    
    flag = 0;
    ind = size(r1,1);
    
    while(~flag)
        
        if(r1(ind,z)<r2(ind,z))
            flag = 1;
            x(z) = correnti(z);
            y(z) = lista_flops(ind);
            indx(z) = z;
            indy(z) = ind;
        end
        
        ind = ind-1;
        
    end
    
    
end

for i = 1:numel(correnti)
    z(i) = r1(indy(i),i)-0.01;
end

plot3(x,indy,z,'linewidth',2,'color','red');
hold on

u = nan(size(r1,2),1);
w = u;
indu = u;
indw = indu; 

for z=1:numel(correnti)
    
    flag = 0;
    ind = 1;
    
    while(~flag)
        
        if(r1(ind,z)>r2(ind,z))
            flag = 1;
            u(z) = correnti(z);
            w(z) = lista_flops(ind);
            indu(z) = z;
            indw(z) = ind;
        end
        
        ind = ind+1;
    end 
end

for i = 1:numel(correnti)
    z(i) = r2(indw(i),i)-0.01;
end

plot3(u,indw,z,'linewidth',2,'color','red');


figure
scatter(x,y);
[a,b] = polyfit(x,y,1);
hold on
plot(x,a(1)*x+a(2));

