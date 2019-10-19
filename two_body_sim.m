% delta_t [s] - tempo de simula��o
delta_t = 365*24*3600;

% pos_init_sun - Vetor da posi��o inicial do Sol
pos_init_sun = [0; 0; 0];

% vel_init_sun - Vetor da velocidade inicial do Sol
vel_init_sun = [0; 0; 0];

% pos_init_earth - Vetor da posi��o inicial da Terra
pos_init_earth = [149597870691; 0; 0];

% vel_init_earth - Vetor da velocidade inicial da Terra
vel_init_earth = [0; 29785; 0];

% tinterv - Vetor do intervalo de tempo da simula��o
tinterv = [0, delta_t]; 

% xinicial - Vetor de valores inicial do vetor de estados
xinicial = [pos_init_sun; pos_init_earth; vel_init_sun; vel_init_earth]; 

% G [Nm�/kg�] - Constante da gravita��o universal
G = 6.674e-11;

% m_1 [kg] - Massa do sol
m_1 = 1.989e30;

% m_2 [kg] - Massa da Terra
m_2 = 5.972e24;

% Simula o sistema din�mico
[tsim, xsim] = ode45(@(tsim, xsim) two_body_problem(tsim, xsim, G, m_1, m_2), tinterv, xinicial);

% Plota as trajet�rias
figure(1)
plot(xsim(:, 4), xsim(:,5), xsim(:, 1), xsim(:,2), 'r*')
title('Trajet�ria de ambos os corpos')
legend('Trajet�ria da Terra','Trajet�ria do Sol')
axis square

figure(2)
plot(xsim(:, 1), xsim(:,2), 'r*')
title('Trajet�ria do corpo central')
legend('Trajet�ria do Sol')
axis square
