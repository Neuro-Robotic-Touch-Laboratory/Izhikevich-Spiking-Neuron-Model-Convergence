clc, close all, clear all;

%Carico i parametri del modello
prompt_1='Tipo di neurone? C(hattering)/R(egular) \n';
    x = input(prompt_1,'s');
    switch upper(x)
        case 'C'
            load('reference_chattering.mat');
        case 'R'
            load('reference_regular.mat');
        otherwise
            disp('Input must be C or R!')
    end
    
%Scelgo il tipo di ingresso
prompt_2='Tipo di ingresso? C(hirp)/H(eaviside)/R(amp)/S(in) \n';
    x = input(prompt_2,'s');
    switch upper(x)
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

% Definizione parametri globali

STOP = 0.5; % durata simulazione
flop_rk1 = 13; % numero flop RK1?
flop_rk2 = 28; % numero flop RK2?
flop_rk4 = 68; % numero flop RK3?

%definizione costO
prompt_6='costo? \n';
    costs = input(prompt_6);
    
%defizione correnti
prompt_3='corrente? \n';
    correnti = input(prompt_3);
    
%definizione flop
prompt_7='flop? \n';
    lista_flops = input(prompt_7);
    
DISTANCES_rk1 = [];
DISTANCES_rk2 = [];
DISTANCES_rk4 = [];

DATA_RK1 = {};
DATA_RK2 = {};
DATA_RK4 = {};

%Simulink
open_system(model_name);

I = correnti;
tau = 0.5e-06;
[~,~,stamps_ref] = integra_simulink_SENZA_CHIUDERE(model_name,'ode5',c);

tau_rk1 = flop_rk1/lista_flops;
tau_rk2 = flop_rk2/lista_flops;
tau_rk4 = flop_rk4/lista_flops;
 
tau = tau_rk1;
[u_rk1,~,stamps_rk1] = integra_simulink_SENZA_CHIUDERE(model_name,'ode1',c);
tau = tau_rk2;
[u_rk2,~,stamps_rk2] = integra_simulink_SENZA_CHIUDERE(model_name,'ode2',c);
tau = tau_rk4;
[u_rk4,~,stamps_rk4] = integra_simulink_SENZA_CHIUDERE(model_name,'ode4',c);

DATA_RK1 = {tau_rk1,lista_flops,I,stamps_rk1,u_rk1};
DATA_RK2 = {tau_rk2,lista_flops,I,stamps_rk2,u_rk2};
DATA_RK4 = {tau_rk4,lista_flops,I,stamps_rk4,u_rk4};

distances_rk1 = spkd(stamps_rk1,stamps_ref,costs);
distances_rk2 = spkd(stamps_rk2,stamps_ref,costs);
distances_rk4 = spkd(stamps_rk4,stamps_ref,costs);

DISTANCES_rk1 = distances_rk1;
DISTANCES_rk2 = distances_rk2;
DISTANCES_rk4 = distances_rk4;

save_system(model_name);
close_system(model_name);

