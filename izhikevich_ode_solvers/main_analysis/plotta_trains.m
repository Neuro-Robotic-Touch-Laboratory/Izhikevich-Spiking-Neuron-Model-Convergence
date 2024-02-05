
clearvars

addpath('../funzioni/');
addpath('../references/');
addpath('../simulink_models/');
addpath('../matrici_distanze/');

prompt_1='Tipo di neurone? C(hattering)/R(egular) \n';
type = input(prompt_1,'s');
switch upper(type)
    case 'C'
        load('reference_chattering.mat');
    case 'R'
        load('reference_regular.mat');
    otherwise
        disp('Input must be C or R!')
end

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

prompt_3='Corrente? \n';
I = input(prompt_3,'s');
I = str2double(I);

prompt_4='Flops o tau? (0 vs 1) \n';
scelta = input(prompt_4,'s');
scelta = str2double(scelta);





if ~scelta
    
    
    
    prompt_5='Flops ?  \n';
    flops = input(prompt_5,'s');
    flops = str2double(flops);
    
    
    STOP = 0.5;
    flop_rk1 = 13;
    flop_rk2 = 28;
    flop_rk4 = 68;
    
    %Simulink
    open_system(model_name);
    
    tau = 0.5e-06; % ### tau me lo sto definendo nel workspace non mi piace
    [u_ref,~,stamps_ref] = integra_simulink_SENZA_CHIUDERE(model_name,'ode5',c);
    
    
    
    
    
    tau_rk1 = flop_rk1/flops;
    tau_rk2 = flop_rk2/flops;
    tau_rk4 = flop_rk4/flops;
    
    tau = tau_rk1; % ### definisco esternamente il tempo di campion.
    [u_rk1,~,stamps_rk1] = integra_simulink_SENZA_CHIUDERE(model_name,'ode1',c); % ### invece vorrei poterlo definire qui dentro!
    tau = tau_rk2;
    [u_rk2,~,stamps_rk2] = integra_simulink_SENZA_CHIUDERE(model_name,'ode2',c);
    tau = tau_rk4;
    [u_rk4,~,stamps_rk4] = integra_simulink_SENZA_CHIUDERE(model_name,'ode4',c);
    
    
    
    
    save_system(model_name);
    close_system(model_name);
    
    figure
    
    plot(u_ref);
    hold on
    plot(u_rk1);
    hold on
    plot(u_rk2);
    hold on
    plot(u_rk4);
    
    legend('ref','rk1','rk2','rk4');
    title(sprintf('FLOPS = %d',flops));
    
    
else
    
    prompt_5='Tau ?  \n';
    tempo = input(prompt_5,'s');
    tempo = str2double(tempo);
    
    
    STOP = 0.5;
    flop_rk1 = 13;
    flop_rk2 = 28;
    flop_rk4 = 68;
    
    %Simulink
    open_system(model_name);
    
    tau = 0.5e-06; % ### tau me lo sto definendo nel workspace non mi piace
    [u_ref,~,stamps_ref] = integra_simulink_SENZA_CHIUDERE(model_name,'ode5',c);
    
    
    tau = tempo;
    
    
    [u_rk1,~,stamps_rk1] = integra_simulink_SENZA_CHIUDERE(model_name,'ode1',c);
    [u_rk2,~,stamps_rk2] = integra_simulink_SENZA_CHIUDERE(model_name,'ode2',c);
    [u_rk4,~,stamps_rk4] = integra_simulink_SENZA_CHIUDERE(model_name,'ode4',c);
    
    
    save_system(model_name);
    close_system(model_name);
    
    figure
    
    plot(u_ref);
    hold on
    plot(u_rk1);
    hold on
    plot(u_rk2);
    hold on
    plot(u_rk4);
    
    legend('ref','rk1','rk2','rk4');
    title(sprintf('TAU = %d',tempo));
    
    
end



