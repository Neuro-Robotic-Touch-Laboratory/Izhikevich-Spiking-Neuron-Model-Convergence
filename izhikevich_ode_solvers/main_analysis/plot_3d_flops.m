%% qua plotto tutto 

% nota bene per andare avanti seleziona un costo (q) di riferimento
titolo = 'Regular Spiking';
color = 'Black';

costo = 1; % dove 3 non significa che q = 3 ma che è il terzo elemento del 
           % vettore "costs", come si vede alla riga 168

x=correnti;
y=lista_flops;

N=numel(correnti);
M=numel(lista_flops);

color1=zeros(M,N,3);
color2=zeros(M,N,3);
color4=zeros(M,N,3); 

color1(:,:,1)=0.3010*ones(M,N);
color1(:,:,2)=0.7450*ones(M,N);
color1(:,:,3)=0.9330*ones(M,N);

color2(:,:,1)=0.4660*ones(M,N);
color2(:,:,2)=0.6740*ones(M,N);
color2(:,:,3)=0.1880*ones(M,N);

color4(:,:,1)=0.4940*ones(M,N);
color4(:,:,2)=0.1840*ones(M,N);
color4(:,:,3)=0.5560*ones(M,N);

figure
surf(x,y,squeeze(DISTANCES_rk1(costo,:,:)),color1);
hold on
surf(x,y,squeeze(DISTANCES_rk2(costo,:,:)),color2);
hold on
surf(x,y,squeeze(DISTANCES_rk4(costo,:,:)),color4);

title(titolo,'color',color);
legend('euler','rk2','rk4');

ylabel('FLOPS');
xlabel('current');

set(gca,'zscale','log');
set(gca,'fontname','times')
%% qua plotto tutto con asse y logaritmico


x=correnti;
y=lista_flops;

N=numel(correnti);
M=numel(lista_flops);

figure
surf(x,1:M,squeeze(DISTANCES_rk1(costo,:,:)),color1);
hold on
surf(x,1:M,squeeze(DISTANCES_rk2(costo,:,:)),color2);
hold on
surf(x,1:M,squeeze(DISTANCES_rk4(costo,:,:)),color4);

% qua usando una funzione xticklabels bisogna metter i labels ai tick
% in modo logaritmico

% ### come si vede in questo plot logaritmico le tacche vengono con questi
% numeri tutti strani, anche questo è da aggiustare !
% anche perchè essendo logaritmico ste tacche dovrebbero essere
% logaritmiche
y = round(y,0);
tacche = (2:4:M); % prendo come tacche una ogni due 
yticks(tacche);
yticklabels(cellstr(num2str(y(tacche)','%.0e')));


title(titolo,'color',color);
legend('euler','rk2','rk4');

xlabel('Input Amplitude (mV/ms)')
ylabel('FLOPS')
zlabel('VPD')
set(gca,'zscale','log');
set(gca,'fontname','times')
