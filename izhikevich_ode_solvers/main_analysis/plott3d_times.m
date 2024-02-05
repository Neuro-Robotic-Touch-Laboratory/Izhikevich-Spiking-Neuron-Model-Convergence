%% qua plotto tutto in lineare 

% nota bene per andare avanti seleziona un costo (q) di riferimento

costo = 3; % dove 3 non significa che q = 3 ma che è il terzo elemento del 
           % vettore "costs", come si vede alla riga 168

titolo = 'Intrinsically Bursting';
color = 'red';
           
x=correnti;
y=lista_tau_rk1;

N=numel(correnti);
M=numel(y);

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

ylabel('tau');
xlabel('current');
set(gca,'fontname','times')
