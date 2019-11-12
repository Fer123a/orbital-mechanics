% time_stamp [dias] - instante de tempo inicial, após J2000
time_stamp = 12733;

% spcraft_pos_2_earth [m] - vetor posição da aeronave em relação à Terra
spcraft_pos_2_earth = [-4632170489; -5436538453; -958608411];

% spcraft_vel_2_earth [m/s] - vetor velocidade da aeronave em relação à Terra
spcraft_vel_2_earth = [180.162; -148.878; -26.251];

% delta_t [s] - tempo de simulação
delta_t = 180*24*3600;

% masses_vector [kg] - vetor contendo a massas dos corpos do sistema
masses_vector = [1.989e30; 5.972e24; 6.417e23; 1.898e27; 2e5];

% mu_sun [m^3/s^2] - parâmetro gravitacional do sol
mu_sun = 1.32712440018e20;

% sun_pos [m] - posição do sol em relação ao referencial inercial 
sun_pos = [0; 0; 0];
% sun_vel [m/s] - velocidade do sol em relação ao referencial inercial
sun_vel = [0; 0; 0];

state_matrix_init = read_position(time_stamp, {'Terra'; 'Marte'; 'Jupiter'});

spcraft_pos_inertial = spcraft_pos_2_earth + state_matrix_init(1:3, 1);
spcraft_vel_inertial = spcraft_vel_2_earth + state_matrix_init(4:6, 1);

state_matrix_dest = read_position(time_stamp + delta_t, {'Terra'; 'Marte'; 'Jupiter'});

[init_vel_vector, fin_vel_vector] = lambert(spcraft_pos_inertial, state_matrix_dest(1:3, 2), delta_t, mu_sun, false);
% [init_vel_vector, fin_vel_vector] = lambert(spcraft_pos_inertial, state_matrix_dest(1:3, 2), delta_t, mu_sun, true);

xinicial = [sun_pos; sun_vel; reshape(state_matrix_init, [], 1); spcraft_pos_inertial; spcraft_vel_inertial + init_vel_vector];

options = odeset('RelTol',1e-5);

[~, xsim] = ode45(@(tsim, xsim) n_body_problem(tsim, xsim, masses_vector), [0, delta_t], xinicial, options);
% [~, xsim] = ode45(@(tsim, xsim) n_body_problem(tsim, xsim, masses_vector), [0, 12*365*24*3600], xinicial, options);

figure(1)
hold on
plot(xsim(:, 1), xsim(:,2), ' y*')
plot(xsim(:, 7), xsim(:,8), ' g')
plot(xsim(:, 13), xsim(:,14), ' r')
plot(xsim(:, 19), xsim(:,20), ' b')
plot(xsim(:, 25), xsim(:,26), ' v')
title('Trajetória de todos os corpos')
legend('Trajetória do Sol','Trajetória da Terra', 'Trajetória de Marte',...
    'Trajetória de Júpiter', 'Trajetória da Espaçonave')
grid on
xlabel('[m]') 
ylabel('[m]') 
axis square
hold off

