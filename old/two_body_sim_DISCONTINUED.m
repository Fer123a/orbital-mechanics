% delta_t [s] - tempo de simulação
delta_t = 365*24*3600;

% pos_init_sun - Vetor da posição inicial do Sol
pos_init_sun = [0; 0; 0];

% vel_init_sun - Vetor da velocidade inicial do Sol
vel_init_sun = [0; 0; 0];

% pos_init_earth - Vetor da posição inicial da Terra
pos_init_earth = [149597870691; 0; 0];

% vel_init_earth - Vetor da velocidade inicial da Terra
vel_init_earth = [0; 29785; 0];

% tinterv - Vetor do intervalo de tempo da simulação
tinterv = [0, delta_t]; 

% xinicial - Vetor de valores inicial do vetor de estados
xinicial = [pos_init_sun; pos_init_earth; vel_init_sun; vel_init_earth]; 

% G [Nm²/kg²] - Constante da gravitação universal
G = 6.674e-11;

% m_1 [kg] - Massa do sol
m_1 = 1.989e30;

% m_2 [kg] - Massa da Terra
m_2 = 5.972e24;

% Simula o sistema dinâmico
[tsim, xsim] = ode45(@(tsim, xsim) two_body_problem(tsim, xsim, G, m_1, m_2), tinterv, xinicial);

% Plota as trajetórias
figure(1)
plot(xsim(:, 4), xsim(:,5), xsim(:, 1), xsim(:,2), 'r*')
title('Trajetória de ambos os corpos')
legend('Trajetória da Terra','Trajetória do Sol')
axis square

figure(2)
plot(xsim(:, 1), xsim(:,2), 'r*')
title('Trajetória do corpo central')
legend('Trajetória do Sol')
axis square
