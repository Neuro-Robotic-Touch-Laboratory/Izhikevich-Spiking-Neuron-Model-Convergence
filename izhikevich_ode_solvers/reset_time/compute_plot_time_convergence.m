clear all, close all


%%
%proviamo a vedere la differenza. Facciamo la distanza euclidea nello
%spazio delle fasi. Metto la linea quando ho convergenza


fsize = 13;
currents = [10 20 30 40 50 60 70 80 90 100];
taus = linspace(1e-4,1e-3,10);
grad_stops = [0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1 1.1];
% ricorda; la cella itera su (correnti grad_stops taus)

load('lancio_10_stops_I=10-100_10_taus_plus_references_fast.mat')

% titolo = 'Regular Spiking';
% color = 'black';
% letter = 'a';
% c = gray(numel(taus));

% titolo = 'Intrinsically Bursting';
% color = 'red';
% letter = 'b';
% c = hot(numel(taus));
% 
% titolo = 'Chattering';
% color = 'blue';
% letter = 'c';
% c = winter(numel(taus));
% 
titolo = 'Fast Spiking';
color = '#D95319';
letter = 'd';
c = autumn(numel(taus));


%% I calculate this time of convergence for every current input to draw statistics 


currents = [10 20 30 40 50 60 70 80 90 100];
taus = linspace(1e-4,1e-3,10);
grad_stops = [0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1 1.1];
% ricorda; la cella itera su (correnti grad_stops taus)

analysis_table = zeros(3000,5);% this is the table for statistics. 3000 because we have all solvers together
index_table = 1;

diffs_rk1 = [];
for k=1:numel(currents) % questa è la corrente che prendo...si consiglia di prendere la quinta
    
    for i=1:10 %itero sui taus
        for j=1:10 % itero sulla durata gradino
            N_stop = grad_stops(j)*1000;
            diff_u=(resample(references_u{k,j},linspace(0,1.5,1500))-resample(us_rk1{k,j,i},linspace(0,1.5,1500)));
            diff_v=(resample(references_v{k,j},linspace(0,1.5,1500))-resample(vs_rk1{k,j,i},linspace(0,1.5,1500)));
            distance=(diff_v.Data-diff_u.Data).^2;
            time_convergence = calculate_time_convergence(distance,1e-03,N_stop,diff_v);
            time_start_conv = diff_v.Time(N_stop);
            diffs_rk1(i,j,k) = time_convergence-time_start_conv;
            analysis_table(index_table,1) = 1;
            analysis_table(index_table,2) = taus(i);
            analysis_table(index_table,3) = grad_stops(j);
            analysis_table(index_table,4) = currents(k);
            analysis_table(index_table,5) = diffs_rk1(i,j,k);
            index_table = index_table+1;
        end
    end
end

diffs_rk2 = [];
for k=1:numel(currents) % questa è la corrente che prendo...si consiglia di prendere la quinta
    
    for i=1:10 %itero sui taus
        for j=1:10 % itero sulla durata gradino
            N_stop = grad_stops(j)*1000;
            diff_u=(resample(references_u{k,j},linspace(0,1.5,1500))-resample(us_rk2{k,j,i},linspace(0,1.5,1500)));
            diff_v=(resample(references_v{k,j},linspace(0,1.5,1500))-resample(vs_rk2{k,j,i},linspace(0,1.5,1500)));
            distance=(diff_v.Data-diff_u.Data).^2;
            time_convergence = calculate_time_convergence(distance,1e-03,N_stop,diff_v);
            time_start_conv = diff_v.Time(N_stop);
            diffs_rk2(i,j,k) = time_convergence-time_start_conv; 
            analysis_table(index_table,1) = 2;
            analysis_table(index_table,2) = taus(i);
            analysis_table(index_table,3) = grad_stops(j);
            analysis_table(index_table,4) = currents(k);
            analysis_table(index_table,5) = diffs_rk2(i,j,k);
            index_table = index_table+1;
        end
    end
end

diffs_rk4 = [];
for k=1:numel(currents) % questa è la corrente che prendo...si consiglia di prendere la quinta
    
    for i=1:10 %itero sui taus
        for j=1:10 % itero sulla durata gradino
            N_stop = grad_stops(j)*1000;
            diff_u=(resample(references_u{k,j},linspace(0,1.5,1500))-resample(us_rk4{k,j,i},linspace(0,1.5,1500)));
            diff_v=(resample(references_v{k,j},linspace(0,1.5,1500))-resample(vs_rk4{k,j,i},linspace(0,1.5,1500)));
            distance=(diff_v.Data-diff_u.Data).^2;
            time_convergence = calculate_time_convergence(distance,1e-03,N_stop,diff_v);
            time_start_conv = diff_v.Time(N_stop);
            diffs_rk4(i,j,k) = time_convergence-time_start_conv; 
            analysis_table(index_table,1) = 4;
            analysis_table(index_table,2) = taus(i);
            analysis_table(index_table,3) = grad_stops(j);
            analysis_table(index_table,4) = currents(k);
            analysis_table(index_table,5) = diffs_rk4(i,j,k);
            index_table = index_table+1;
        end
    end
end

%% AlTERNATIVA MIA NUOVA

minimum = min([min(diffs_rk1,[],'all') min(diffs_rk2,[],'all') min(diffs_rk4,[],'all')])-0.005;
maximum = max([max(diffs_rk1,[],'all') max(diffs_rk2,[],'all') max(diffs_rk4,[],'all')])+0.005;


ylimits = [minimum,maximum];


fig = figure;
tiledlayout(3,1)

h(1) = nexttile(1);
for i=1:numel(taus)
    for k=1:numel(currents)
        plot(1000*taus,mean(diffs_rk1(:,:,k),2),'color',c(k,:),'markersize',1.5*k); %plotto al variare di durata, ogni curva è un tau diverso. DImensione dot è la ampiezza input
        hold on
    end
end
ylim(ylimits);
set(gca,'fontname','times')
set(gca,'Fontsize',fsize);
xticklabels('');

h(2) = nexttile(2);
for i=1:numel(taus)
    for k=1:numel(currents)
        plot(1000*taus,mean(diffs_rk2(:,:,k),2),'color',c(k,:),'markersize',1.5*k); %plotto al variare di durata, ogni curva è un tau diverso. DImensione dot è la ampiezza input
        hold on
    end
end
xticklabels('');
set(gca,'fontname','times')
set(gca,'Fontsize',fsize);
ylim(ylimits);

h(3) = nexttile(3);
for i=1:numel(taus)
    for k=1:numel(currents)
        plot(1000*taus,mean(diffs_rk4(:,:,k),2),'color',c(k,:),'markersize',1.5*k); %plotto al variare di durata, ogni curva è un tau diverso. DImensione dot è la ampiezza input
        hold on
    end
end
xlabel('Discretization Step (ms)');
ylim(ylimits);
set(gca,'fontname','times')
set(gca,'Fontsize',fsize);

colormap autumn
bar = colorbar;
bar.Layout.Tile = 'east'; 
bar.Label.String = 'I (mV/ms)';
fig.Position = [0 0 500 250];
set(gca,'fontname','times');
set(gca,'Fontsize',fsize);

sgtitle(titolo,'color',color,'fontname','times','Fontsize',1.5*fsize);


%% this is to save
cd ../paper_sottomissione/immagini_journal/nuove_2024
exportgraphics(fig,['6' letter '.png'],'Resolution',300)
close(fig)
