%% ricordarsi di loadare le matrici opportune 

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
hold on
% c = repmat([0.8500 0.3250 0.0980],10,1);
% scatter(x,y,[],c,'*');

scatter(x,y,[],'blue','<');
[a,b] = polyfit(x,y,1);
hold on
plot(x,a(1)*x+a(2),'color','blue');
%%
xlabel('Input Amplitude (mV/ms)');
ylabel('FLOPS');
fsize=13;
set(gca,'fontname','times')
set(gca,'Fontsize',fsize);
title('Line of Separation');
