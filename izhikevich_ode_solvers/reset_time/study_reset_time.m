clear all, close all

addpath('../funzioni/');
addpath('../references/');
addpath('../simulink_models/');
addpath('../matrici_distanze_VR/');
load('reference_regular.mat');

currents = [10 20 30 40 50 60 70 80 90 100];
taus = linspace(1e-4,2.5e-3,10);
grad_stops = [0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1 1.1];
% ricorda; la cella itera su (correnti grad_stops taus)

STOP = 1.5;        % durata simulazione
references_u = cell(numel(currents),numel(grad_stops));  % vario al variare non della corrente ma della durata del treno
references_v = cell(numel(currents),numel(grad_stops));

us_rk1 = cell(numel(currents),numel(grad_stops),numel(taus));
us_rk2 = us_rk1;
us_rk4 = us_rk1;
vs_rk1 = us_rk1;
vs_rk2 = us_rk1;
vs_rk4 = us_rk1;


for knd=1:numel(currents)
    
    
    for jnd=1:numel(grad_stops)
        
        
        % GENERO REFERENCE
        
        model_name = 'codice_22_SEPT_GRADINO_VARIABILE';
        open_system(model_name);
        
        %% definizione parametri 
        I = currents(knd);   % NB PER IL SENO LA CORRENTE è CAMBIATA A 60, MENTRE PER RAMPA E GRADINO A 30    %%%%%
        grad_stop = grad_stops(jnd);
        
        %%
        
        tau = 1e-05;
        [vref,uref,~] = integra_simulink_SENZA_CHIUDERE(model_name,'ode5',c);
        save_system(model_name);
        close_system(model_name);
        
        references_v{knd,jnd} = vref;
        references_u{knd,jnd} = uref;
        
        % ORA GENERO I VARII TRENI
        
        open_system(model_name);
        
        for i=1:numel(taus)
            
            tau = taus(i);
            
            [v,u,~] = integra_simulink_SENZA_CHIUDERE(model_name,'ode1',c);
            vs_rk1{knd,jnd,i} = v;
            us_rk1{knd,jnd,i} = u;
            
            [v,u,~] = integra_simulink_SENZA_CHIUDERE(model_name,'ode2',c);
            vs_rk2{knd,jnd,i} = v;
            us_rk2{knd,jnd,i} = u;           
            
            [v,u,~] = integra_simulink_SENZA_CHIUDERE(model_name,'ode4',c);
            vs_rk4{knd,jnd,i} = v;
            us_rk4{knd,jnd,i} = u;
            
            fprintf('corrente %d durata %d tau %d',knd,jnd,i);
            
        end
        
        save_system(model_name);
        close_system(model_name);
        
        %% riempio la cell, per quella determinata corrente, con le cell per i potenziali calcolati per ogni tau!
        
        
    end
end

save('lancio_10_stops_I=10-100_10_taus=100-2500_without_references_regular','us_rk1','us_rk2','us_rk4','vs_rk1','vs_rk2','vs_rk4');
