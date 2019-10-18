delta_t = 365*24*3600;

pos_init_sun = [0; 0; 0];
vel_init_sun = [0; 0; 0];

pos_init_earth = [149597870691; 0; 0];
                  
vel_init_earth = [0; 29785; 0];

tinterv = [0, delta_t]; % Intervalo de tempo da simulação
xinicial = [pos_init_sun; pos_init_earth; vel_init_sun; vel_init_earth]; % Valor inicial do vetor de estados

G = 6.674e-11;
m_1 = 1.989e30;
m_2 = 5.972e24;

% Simula o sistema dinâmico
[tsim, xsim] = ode45(@(tsim, xsim) two_body_problem(tsim, xsim, G, m_1, m_2), tinterv, xinicial);

figure(1)
plot(xsim(:, 4), xsim(:,5), xsim(:, 1), xsim(:,2), 'r*')

figure(2)
plot(xsim(:, 1), xsim(:,2), 'r*')

