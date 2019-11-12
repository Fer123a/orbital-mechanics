%% Two Bodies - Sistema Sol + Terra

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

% m_1 [kg] - Massa do sol
m_1 = 1.989e30;

% m_2 [kg] - Massa da Terra
m_2 = 5.972e24;

m = [m_1, m_2];

options = odeset('RelTol',1e-8);

xinicial = [pos_init_sun; vel_init_sun; pos_init_earth; vel_init_earth]; 

[~, xsim] = ode45(@(tsim, xsim) n_body_problem(tsim, xsim, m), tinterv, xinicial, options);

figure(1)
plot(xsim(:, 7), xsim(:,8), xsim(:, 1), xsim(:,2), 'r*')
title('Trajet�ria de ambos os corpos')
legend('Trajet�ria da Terra','Trajet�ria do Sol')
grid on
xlabel('[m]') 
ylabel('[m]') 
axis square

figure(2)
plot(xsim(:, 1), xsim(:,2), 'r*')
title('Trajet�ria do corpo central')
legend('Trajet�ria do Sol')
grid on
xlabel('[m]') 
ylabel('[m]') 
axis square

%% Three Bodies - Exemplo do Ap�ndice C do Livro

%...Input data
m1 = 1e29; m2 = 1e29; m3 = 1e29;
t0 = 0; tf = 67000;
X1 = 0; Y1 = 0;
X2 = 300000; Y2 = 0;
X3 = 2*X2; Y3 = 0;
VX1 = 0; VY1 = 0;
VX2 = 250; VY2 = 250;
VX3 = 0; VY3 = 0;
%...End input data

m = [m1 m2 m3];

xinicial = 1000*[X1 Y1 0 VX1 VY1 0 X2 Y2 0 VX2 VY2 0 X3 Y3 0 VX3 VY3 0];

tinterv = [t0 tf];

[~, xsim] = ode45(@(tsim, xsim) n_body_problem(tsim, xsim, m), tinterv, xinicial, options);

figure(3)
hold on
plot(xsim(:, 1), xsim(:,2), ' r')
plot(xsim(:, 7), xsim(:,8), ' g')
plot(xsim(:, 13), xsim(:,14), ' b')
title('Trajet�ria de todos os corpos')
legend('Trajet�ria do Corpo 1','Trajet�ria do Corpo 2', 'Trajet�ria do Corpo 3')
grid on
xlabel('[m]') 
ylabel('[m]') 
axis square
