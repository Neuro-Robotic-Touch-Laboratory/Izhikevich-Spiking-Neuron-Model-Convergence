
function [u,w,stamps] = integra_simulink_SENZA_CHIUDERE (model_name,metodo,c)  

% open_system(model_name);

activeConfigObj = getActiveConfigSet(model_name);
set_param(activeConfigObj,'Solver',metodo);
simOut = sim(model_name,'SaveOutput','on'); 

u = simOut.potenziale;
w = simOut.recovery;


stamps = genera_stamps(u,w,c);  

    
end