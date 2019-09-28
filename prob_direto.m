function output_vector = prob_direto(input_vector, mu)
% PROB_DIRETO - Função que calcula as coordenadas cartesianas
% de um corpo em uma órbita elíptica, tendo como entrada os elementos
% kleperianos que definem a órbita e o parâmetro gravitacional do 
% corpo central.
%
% Entradas:
%   input_vector - vetor de entrada, contendo, nesta ordem:
%       a [m] - semieixo maior da órbita
%       e [adim] - excentricidade da órbita
%       inc [rad] - inclinação da órbita em relação ao equador 
%       omega_upper [rad] - ascenção reta do nodo ascendente
%       omega_lower [rad] - argumento do perigeu
%       M [rad] - anomalia média
%   mu [m³/s] - parâmetro gravitacional
%
% Saída:
%   output_vector - vetor de saída, contendo, nesta ordem:
%       x [m] - posição do corpo no eixo x
%       y [m] - posição do corpo no eixo y
%       z [m] - posição do corpo no eixo z
%       x_dot [m/s] - variação da posição do corpo no eixo x
%       y_dot [m/s] - variação da posição do corpo no eixo y
%       z_dot [m/s] - variação da posição do corpo no eixo z

%% Definição das entradas
a = input_vector(1);
e = input_vector(2);
inc = input_vector(3);
omega_upper = input_vector(4);
omega_lower = input_vector(5);
M = input_vector(6);

%% Equação de Kepler

% u [rad] - anomalia excêntrica
u = kepler_eq(M, e);

%% n [s^(-1)] - movimento médio

n = sqrt(mu/(a^3));

%% r [m] - distância geocêntrica

r = a*(1 - e*cos(u));

%% Coordenadas do plano orbital

% x_orb [m] - coordenada x no plano orbital
x_orb = a*(cos(u) - e);

% y_orb [m] - coordenada y no plano orbital
y_orb = a*sin(u)*sqrt(1 - e^2);

% z_orb [m] - coordenada z no plano orbital
z_orb = 0;

% x_dot_orb [m/s] - variação da coordenada x no plano orbital
x_dot_orb = -n*(a^2)/r*sin(u);

% y_dot_orb [m/s] - variação da coordenada y no plano orbital
y_dot_orb = n*(a^2)/r*cos(u)*sqrt(1 - e^2);

% z_dot_orb [m/s] - variação da coordenada z no plano orbital
z_dot_orb = 0;

%% Matriz de Rotação
% R_z_omega_upper [adim] - matriz de rotação do ângulo -omega_upper em
% torno do eixo z
R_z_omega_upper = [cos(-omega_upper), sin(-omega_upper), 0;
                   -sin(-omega_upper), cos(-omega_upper), 0;
                   0, 0, 1];
               
% R_x_inc [adim] - matriz de rotação do ângulo -inc em
% torno do eixo x
R_x_inc = [1, 0, 0;
           0, cos(-inc), sin(-inc);
           0, -sin(-inc), cos(-inc)];
      
% R_z_omega_lower [adim] - matriz de rotação do ângulo -omega_lower em
% torno do eixo z
R_z_omega_lower = [cos(-omega_lower), sin(-omega_lower), 0;
                   -sin(-omega_lower), cos(-omega_lower), 0;
                   0, 0, 1];     

%% Vetor de Estado
X_vector = R_z_omega_upper*R_x_inc*R_z_omega_lower*([x_orb; y_orb; z_orb]);

x = X_vector(1);
y = X_vector(2);
z = X_vector(3);

X_dot_vector = R_z_omega_upper*R_x_inc*R_z_omega_lower*([x_dot_orb; y_dot_orb; z_dot_orb]);

x_dot = X_dot_vector(1);
y_dot = X_dot_vector(2);
z_dot = X_dot_vector(3);

output_vector = [x, y, z, x_dot, y_dot, z_dot];




    