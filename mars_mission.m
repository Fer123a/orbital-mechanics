%{ 
Avalia��o da Manobra:

O valor de DeltaV necess�rio para a realiza��o da trajet�ria curta � (em m/s): 
   1.0e+03 *

   1.820978157201787
  -5.196245428569979
  -2.428248884573358

O valor de DeltaV necess�rio para a realiza��o da trajet�ria longa � (em m/s): 
   1.0e+04 *

   4.591605930155880
   4.272909130743785
   0.240548614936760

---------------------------------------------------------------------------

Posi��o final de marte (em metros): 
   1.0e+11 *

   1.037590859952625  -1.997518340511027  -0.067374992367839

Posi��o final do ve�culo - trajet�ria curta (em metros): 
   1.0e+11 *

   1.039521252471833  -1.993824377602123  -0.066867487552994

Dist�ncia entre os corpos (em metros): 
     4.198730568595989e+08

Posi��o final do ve�culo - trajet�ria longa (em metros): 
   1.0e+11 *

   1.035906781443406  -1.998536866426599  -0.067534472402336

Dist�ncia entre os corpos (em metros): 
     1.974575738559238e+08


Visto que o raio de Marte � de 3389.5 km, a dist�ncia do ve�culo at� o solo
para o caso da trajet�ria curta � de 4.164835568595989e+08 metros (416483.5 km).
Para o caso da trajet�ria longa, a dist�ncia do ve�culo at� o solo � de 
1.940680738559238e+08 metros (194068 km).

Ou seja, embora no plot da trajet�ria, a impress�o � de que o ve�culo
chegou no planeta de destino, nenhuma das trajet�rias fez com que de fato
o ve�culo conseguisse chegar a Marte.
%}

%% Defini��es Iniciais

% time_stamp [dias] - instante de tempo inicial, ap�s J2000
time_stamp = 12733;

% spcraft_pos_2_earth [m] - vetor posi��o da aeronave em rela��o � Terra
spcraft_pos_2_earth = [-4632170489; -5436538453; -958608411];

% spcraft_vel_2_earth [m/s] - vetor velocidade da aeronave em rela��o � Terra
spcraft_vel_2_earth = [180.162; -148.878; -26.251];

% delta_t [dias] - tempo de simula��o em dias
delta_t = 180;

% delta_t_s [s] - tempo de simula��o em segundos
delta_t_s = delta_t*24*3600;

% masses_vector [kg] - vetor contendo a massas dos corpos do sistema
masses_vector = [1.989e30; 5.972e24; 6.417e23; 1.898e27; 2e5];

% mu_sun [m^3/s^2] - par�metro gravitacional do sol
mu_sun = 1.32712440018e20;

% sun_pos [m] - posi��o do sol em rela��o ao referencial inercial 
sun_pos = [0; 0; 0];
% sun_vel [m/s] - velocidade do sol em rela��o ao referencial inercial
sun_vel = [0; 0; 0];

%% L� no database a posi��o dos planetas no instante de tempo inicial e final

% state_matrix_init - matrix onde cada coluna corresponde ao vetor de
% estados de um planeta no instante inicial
state_matrix_init = read_position(time_stamp, {'Terra'; 'Marte'; 'Jupiter'});

% spcraft_pos_inertial [m] - posi��o inicial da aeronave em rela��o ao sistema inercial 
spcraft_pos_inertial = spcraft_pos_2_earth + state_matrix_init(1:3, 1);

% spcraft_vel_inertial [m/s] - velocidade inicial da aeronave em rela��o ao sistema inercial
spcraft_vel_inertial = spcraft_vel_2_earth + state_matrix_init(4:6, 1);

% state_matrix_dest - vetor de estados de Marte no instante final de integra��o 
state_matrix_dest = read_position(time_stamp + delta_t, {'Marte'});

%% Calcula as velocidades iniciais e finais da aeronave,
% utilizando o Problema de Lambert, para as trajet�rias curta e longa.

[init_vel_vector_short, fin_vel_vector_short] = lambert(spcraft_pos_inertial, state_matrix_dest(1:3, 1), delta_t_s, mu_sun, false);
[init_vel_vector_long, fin_vel_vector_long] = lambert(spcraft_pos_inertial, state_matrix_dest(1:3, 1), delta_t_s, mu_sun, true);

disp('O valor de DeltaV necess�rio para a realiza��o da trajet�ria curta �: ')
disp(init_vel_vector_short - spcraft_vel_inertial)
disp('O valor de DeltaV necess�rio para a realiza��o da trajet�ria longa �: ')
disp(init_vel_vector_long - spcraft_vel_inertial)

%% Constr�i o vetor de entrada para o integrador e utiliza Problema de N Corpos para calcular trajet�rias

xinicial_short = [sun_pos; sun_vel; reshape(state_matrix_init, [], 1); spcraft_pos_inertial; init_vel_vector_short];
xinicial_long = [sun_pos; sun_vel; reshape(state_matrix_init, [], 1); spcraft_pos_inertial; init_vel_vector_long];

options = odeset('RelTol',1e-5);

[~, xsim_short] = ode45(@(tsim, xsim) n_body_problem(tsim, xsim, masses_vector), [0, delta_t_s], xinicial_short, options);
[~, xsim_long] = ode45(@(tsim, xsim) n_body_problem(tsim, xsim, masses_vector), [0, delta_t_s], xinicial_long, options);

%% Plota trajet�rias
figure(1)
hold on
plot(xsim_short(:, 1), xsim_short(:,2), 'y*')
plot(xsim_short(:, 7), xsim_short(:,8), 'g')
plot(xsim_short(:, 13), xsim_short(:,14), 'r')
plot(xsim_short(:, 19), xsim_short(:,20), 'b')
plot(xsim_short(:, 25), xsim_short(:,26), 'cv')
title('Trajet�ria de todos os corpos - Trajet�ria Curta')
legend('Trajet�ria do Sol','Trajet�ria da Terra', 'Trajet�ria de Marte',...
    'Trajet�ria de J�piter', 'Trajet�ria Curta da Espa�onave')
grid on
xlabel(' X [m]') 
ylabel(' Y [m]') 
axis square
hold off

disp('Posi��o final de marte: ')
disp([xsim_short(end, 13), xsim_short(end, 14), xsim_short(end, 15)])
disp('Posi��o final do ve�culo - trajet�ria curta: ')
disp([xsim_short(end, 25), xsim_short(end, 26), xsim_short(end, 27)])
disp('Dist�ncia entre os corpos: ')
disp(norm([xsim_short(end, 25) - xsim_short(end, 13),...
           xsim_short(end, 26) - xsim_short(end, 14),...
           xsim_short(end, 27) - xsim_short(end, 15)]))




figure(2)
hold on
plot(xsim_short(:, 1), xsim_short(:,2), 'y*')
plot(xsim_short(:, 7), xsim_short(:,8), 'g')
plot(xsim_short(:, 13), xsim_short(:,14), 'r')
plot(xsim_short(:, 19), xsim_short(:,20), 'b')
plot(xsim_long(:, 25), xsim_long(:,26), 'm^')
title('Trajet�ria de todos os corpos - Trajet�ria Longa')
legend('Trajet�ria do Sol','Trajet�ria da Terra', 'Trajet�ria de Marte',...
    'Trajet�ria de J�piter', 'Trajet�ria Longa da Espa�onave')
grid on
xlabel(' X [m]') 
ylabel(' Y [m]') 
axis square
hold off

disp('Posi��o final do ve�culo - trajet�ria longa: ')
disp([xsim_long(end, 25), xsim_long(end,26), xsim_long(end,27)])
disp('Dist�ncia entre os corpos: ')
disp(norm([xsim_long(end, 25) - xsim_short(end, 13),...
           xsim_long(end, 26) - xsim_short(end, 14),...
           xsim_long(end, 27) - xsim_short(end, 15)]))
