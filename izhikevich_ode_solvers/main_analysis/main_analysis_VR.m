%% ricordarsi di loadare le matrici opportune 
addpath('../matrici_distanze_VR');
costo = 7;

load('rh.mat');

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
figure
% c = repmat([0.8500 0.3250 0.0980],10,1);
% scatter(x,y,[],c,'*');

scatter(x,y,[],'black','.');
[a,b] = polyfit(x,y,1);
hold on
plot(x,a(1)*x+a(2),'color','black');
gof_rs = corrcoef(y,a(1)*x+a(2));
gof_rs = gof_rs(2,1)^2;     % it is goodness of fit, namely r squared 
slope_rs = a(1);
avg_rs = mean(y); % We do also a zero order regression, so the average value where RK2 starts outperforming RK1
%%

load('ih.mat');

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

scatter(x,y,[],'red','o');
[a,b] = polyfit(x,y,1);
hold on
plot(x,a(1)*x+a(2),'color','red');
gof_ib = corrcoef(y,a(1)*x+a(2));
gof_ib = gof_ib(2,1)^2;
slope_ib = a(1);
avg_ib = mean(y);
%%

load('ch.mat');

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
gof_ch = corrcoef(y,a(1)*x+a(2));
gof_ch = gof_ch(2,1)^2;
slope_ch = a(1);
avg_ch = mean(y);

%%

load('fh.mat');

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

c = repmat([0.8500 0.3250 0.0980],10,1);
scatter(x,y,[],c,'*');
[a,b] = polyfit(x,y,1);
hold on
plot(x,a(1)*x+a(2),'color','#D95319');
gof_fs = corrcoef(y,a(1)*x+a(2));
gof_fs = gof_fs(2,1)^2;
slope_fs = a(1);
avg_fs = mean(y);

%%
xlabel('Input Amplitude (mV/ms)');
ylabel('FLOPS');
fsize=18;
set(gca,'fontname','times')
set(gca,'Fontsize',fsize);
title(sprintf('Line of Separation, Van Rossum, t = %d ms',1000*round(costs(costo),2)));
legend(sprintf('RS, r^2=%.3f, slope = %.1d (ms/mV)',gof_rs,slope_rs),'',sprintf('IB, r^2=%.3f, slope = %.1d (ms/mV)',gof_ib,slope_ib),'',sprintf('CH, r^2=%.3f, slope = %.1d (ms/mV)',gof_ch,slope_ch),'',sprintf('FS, r^2=%.3f, slope = %.1d (ms/mV)',gof_fs,slope_fs),'');

