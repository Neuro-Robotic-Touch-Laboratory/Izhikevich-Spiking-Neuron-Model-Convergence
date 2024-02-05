clear all, close all
load('lancio_10_stops_I=10-100_10_taus_plus_references.mat')

% partiamo con rk1

% for j=1:10 %itero sulle correnti
%     figure
%     for i=1:10 % itero sui flop
%         
%         subplot(10,1,i)
%         plot(references_v{j})
%         hold on
%         plot(vs_rk1{1,j}{1,i})   
%     end
% end

%vedere la differenza. Facciammo la distanza euclidea nello
%spazio delle fasi. Metto la linea quando ho convergenza

fsize = 18;
currents = [10 20 30 40 50 60 70 80 90 100];
taus = linspace(1e-4,1e-3,10);
grad_stops = [0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1 1.1];
% ricorda; la cella itera su (correnti grad_stops taus)

% nota bene giocando coi parametri puoi plottare un po' di tutto, gli
% esponenziali bla bla bla ...vediamo calogero che dice...

for k=1:10 %itero sulle correnti 

diffs = [];


for i=1:1 %itero sui taus
    figure
    for j=1:10 % itero sulla durata gradino
        N_stop = grad_stops(j)*1000;
        subplot(10,1,j)
        diff_u=(resample(references_u{k,j},linspace(0,1.5,1500))-resample(us_rk1{k,j,i},linspace(0,1.5,1500)));
        diff_v=(resample(references_v{k,j},linspace(0,1.5,1500))-resample(vs_rk1{k,j,i},linspace(0,1.5,1500)));
        distance=(diff_v.Data-diff_u.Data).^2;         
        semilogy(diff_v.Time,distance,'linewidth',1,'color','black');
        element_convergence = distance(N_stop:end)<1e-03;
        element_convergence = find(element_convergence);
        if numel(element_convergence) ~= 0
            element_convergence = N_stop + element_convergence(1) -1 ;
            time_convergence = diff_v.Time(element_convergence);
            time_start_conv = diff_v.Time(N_stop);
            xline(time_convergence,'color','red');
            xline(time_start_conv,'color','black');
            
        else
            time_convergence = Inf;
        end
        if j~=10
            set(gca,'xtick',[]);
        end
        if j==10
            xlabel('Time (s)');
        end
        
        set(gca,'fontname','times')
        set(gca,'Fontsize',fsize);
    end
    sgtitle('Regular spiking, Discretization Step = 0.1 ms','fontname','times','Fontsize',fsize)

end

end