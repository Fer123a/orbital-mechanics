function output_vector = prob_inverso(input_vector, mu)
% PROB_INVERSO - Função que calcula os elementos kleperianos que 
% definem uma órbita, tendo como entrada as coordenadas cartesianas
% (vetor de estados) e o parâmetro gravitacional do corpo central.
%
% Entradas:
%   input_vector - vetor de entrada, contendo, nesta ordem:
%       x [m] - posição do corpo no eixo x
%       y [m] - posição do corpo no eixo y
%       z [m] - posição do corpo no eixo z
%       x_dot [m/s] - variação da posição do corpo no eixo x
%       y_dot [m/s] - variação da posição do corpo no eixo y
%       z_dot [m/s] - variação da posição do corpo no eixo z
%   mu [m³/s] - parâmetro gravitacional
%
% Saída:
%   output_vector - vetor de saída, contendo, nesta ordem:
%       a [m] - semieixo maior da órbita
%       e [adim] - excentricidade da órbita
%       inc [rad] - inclinação da órbita em relação ao equador 
%       omega_upper [rad] - ascenção reta do nodo ascendente
%       omega_lower [rad] - argumento do perigeu
%       M [rad] - anomalia média

%% Definição das entradas
x = input_vector(1);
y = input_vector(2);
z = input_vector(3);
x_dot = input_vector(4);
y_dot = input_vector(5);
z_dot = input_vector(6);

%% Semi-eixo maior

% r [m] - módulo do vetor posição
r = sqrt(x^2 + y^2 + z^2);

% v [m/s] - módulo do vetor velocidade
v = sqrt(x_dot^2 + y_dot^2 + z_dot^2);

a = 1/(2/r - (v^2)/mu);

%% Excentricidade

% n [s^(-1)] - movimento médio
n = sqrt(mu/(a^3));

term_1 = (dot([x, y, z],[x_dot, y_dot, z_dot])/(n*a^2));
term_2 = 1 - r/a;

e = sqrt(term_1^2 + term_2^2);

%% Anomalia Média

% u [rad] - anomalia excêntrica
u = atan2(term_1, term_2);

M = u - e*sin(u);

% Conversão para ângulo positivo, quando necessário
if M < 0
    M = M + 2*pi;
end

%% Inclinação

% h [m^2/s] - momento angular específico
h = norm(cross([x, y, z], [x_dot, y_dot, z_dot]));

% h_z [m^2/s] - componente em z do momento angular específico
h_z = x*y_dot - y*x_dot;

inc = acos(h_z/h);

%% Ascenção reta do nodo ascendente

% h_x [m^2/s] - componente em x do momento angular específico
h_x = y*z_dot - z*y_dot;

% h_y [m^2/s] - componente em y do momento angular específico
h_y = z*x_dot - x*z_dot;

omega_upper = atan2(h_x, -h_y);

% Conversão para ângulo positivo, quando necessário
if omega_upper < 0
    omega_upper = omega_upper + 2*pi;
end

%% Argumento do perigeu

% f [rad] - anomalia verdadeira
f = atan2(sin(u)*sqrt(1 - e^2), cos(u) - e); 

% upsilon [rad] - longitude verdadeira
upsilon = atan2(-cos(inc)*sin(omega_upper)*x + cos(inc)*cos(omega_upper)*y + sin(inc)*z, cos(omega_upper)*x + sin(omega_upper)*y);

omega_lower = upsilon - f;

% Conversão para ângulo positivo, quando necessário
if omega_lower < 0
    omega_lower = 2*pi + omega_lower;
end

%% Constrói vetor de saída
output_vector = [a, e, inc, omega_upper, omega_lower, M];


