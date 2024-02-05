clc, close all, clear all;

addpath('../funzioni/');
addpath('../references/');
addpath('../simulink_models/');
addpath('../matrici_distanze/');

%Carico i parametri del modello
prompt_1='Tipo di neurone? C(hattering)/R(egular)/F(ast)/I(ntrinsically) \n';
x = input(prompt_1,'s');
switch upper(x)
    case 'C'
        load('reference_chattering.mat');
    case 'R'
        load('reference_regular.mat');
    case 'F'
        load('reference_fast.mat');
    case 'I'
        load('reference_intrinsically.mat');
        
    otherwise
        disp('Input must be C or R or I or F!')
end

%Scelgo il tipo di ingresso
prompt_2='Tipo di ingresso? C(hirp)/H(eaviside)/R(amp)/S(in) \n';
xx = input(prompt_2,'s');
switch upper(xx)
    case 'C'
        model_name = 'codice_22_SEPT_CHIRP';
    case 'H'
        model_name = 'codice_22_SEPT_GRADINO';
    case 'R'
        model_name = 'codice_22_SEPT_RAMPA';
    case 'S'
        model_name = 'codice_22_SEPT_SENO';
    otherwise
        disp('Input must be C,H.R or S!')
end

% per titolo dei futuri dati concateno prima tipo di neurone e poi tipo
% di input con questo titolo salvero tutto

title = [x xx];

% Definizione parametri globali

STOP = 0.5; % durata simulazione
flop_rk1 = 13; % numero flop RK1?
flop_rk2 = 28; % numero flop RK2?
flop_rk4 = 68; % numero flop RK3?

%definizione costi
costs = [1 2 5 10 20 50 100 150 200 300];
n_costs = numel(costs);

%defizione correnti
prompt_3='#correnti? \n';
n_correnti = input(prompt_3);
correnti = linspace(10,100,n_correnti);

%definizione limiti flop
min_flops = 1e04;
max_flops = 7e06;

%defizione tempi di discretizzazione (attenzione qui è diverso)
prompt_4='#tempi? \n';
n_tempi = input(prompt_4);

prompt_5='Flops Log/Lin? \n';
x = input(prompt_5,'s');
switch upper(x)
    case 'LOG'
        lista_flops= logspace(log10(min_flops),log10(max_flops),n_tempi);
    case 'LIN'
        lista_flops= linspace(min_flops,max_flops,n_tempi);
    otherwise
        disp('Input must be Log or Lin!')
end

DISTANCES_rk1 = [];
DISTANCES_rk2 = [];
DISTANCES_rk4 = [];

DATA_RK1 = {};
DATA_RK2 = {};
DATA_RK4 = {};

%Simulink
open_system(model_name);

for z=1:n_correnti
    
    %creo il reference
    I = correnti(z);
    tau = 0.5e-06;
    [~,~,stamps_ref] = integra_simulink_SENZA_CHIUDERE(model_name,'ode5',c);
    
    
    distances_rk1 = zeros(n_costs,n_tempi);   % ogni riga con i grafici richiesti per ogni costo
    distances_rk2 = zeros(n_costs,n_tempi);
    distances_rk4 = zeros(n_costs,n_tempi);
    
    for i=1:n_tempi
        
        
        tau_rk1 = flop_rk1/lista_flops(i);
        tau_rk2 = flop_rk2/lista_flops(i);
        tau_rk4 = flop_rk4/lista_flops(i);
        
        tau = tau_rk1;
        [u_rk1,~,stamps_rk1] = integra_simulink_SENZA_CHIUDERE(model_name,'ode1',c);
        tau = tau_rk2;
        [u_rk2,~,stamps_rk2] = integra_simulink_SENZA_CHIUDERE(model_name,'ode2',c);
        tau = tau_rk4;
        [u_rk4,~,stamps_rk4] = integra_simulink_SENZA_CHIUDERE(model_name,'ode4',c);
        
        % COLLEZIONO IL DATASET
        % FACCIO UNA CELLA CON 1 TAU, 2 FLOPS, 3 CORRENTE, 4 I TIME STAMPS, 5 IL POTENZIALE
        
        
        DATA_RK1{i+(z-1)*n_tempi} = {tau_rk1,lista_flops(i),I,stamps_rk1,u_rk1};
        DATA_RK2{i+(z-1)*n_tempi} = {tau_rk2,lista_flops(i),I,stamps_rk2,u_rk2};
        DATA_RK4{i+(z-1)*n_tempi} = {tau_rk4,lista_flops(i),I,stamps_rk4,u_rk4};
        
        % RIEMPIO LA MATRICE DEI COSTI, PER OGNI I FACCIO TUTTI I COSTI
        
        for j=1:n_costs
            distances_rk1(j,i) = spkd(stamps_rk1,stamps_ref,costs(j));
            distances_rk2(j,i) = spkd(stamps_rk2,stamps_ref,costs(j));
            distances_rk4(j,i) = spkd(stamps_rk4,stamps_ref,costs(j));
        end
        
        fprintf('iterazione z = %d i = %d \n',z,i);
        
    end
    
    DISTANCES_rk1(:,:,z) = distances_rk1;   % NELLA MATRICE 3D INFINE CI METTO PURE LA CORRENTE
    DISTANCES_rk2(:,:,z) = distances_rk2;
    DISTANCES_rk4(:,:,z) = distances_rk4;
    
end

save_system(model_name);
close_system(model_name);

save(['../matrici_distanze/' title '.mat'],'correnti','costs','lista_flops','DISTANCES_rk1','DISTANCES_rk2','DISTANCES_rk4');

