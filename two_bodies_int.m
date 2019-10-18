delta_t = 365*24*3600;

pos_init_sun = [0; 0; 0];
vel_init_sun = [0; 0; 0];

pos_init_earth = [149597870691; 0; 0];
                  
vel_init_earth = [0; 29785; 0];

tinterv = [0, delta_t]; % Intervalo de tempo da simulação
xinicial = [pos_init_sun; pos_init_earth; vel_init_sun; vel_init_earth]; % Valor inicial do vetor de estados

% Simula o sistema dinâmico
[tsim, xsim] = ode45(@two_bodies_problem, tinterv, xinicial);

figure(1)
plot(xsim(:, 4), xsim(:,5), xsim(:, 1), xsim(:,2), 'r*')

figure(2)
plot(xsim(:, 1), xsim(:,2), 'r*')

