function output_vector = prob_inverso(input_vector, mu)
% PROB_INVERSO - Fun��o que calcula os elementos kleperianos que 
% definem uma �rbita, tendo como entrada as coordenadas cartesianas
% (vetor de estados) e o par�metro gravitacional do corpo central.
%
% Entradas:
%   input_vector - vetor de entrada, contendo, nesta ordem:
%       x [m] - posi��o do corpo no eixo x
%       y [m] - posi��o do corpo no eixo y
%       z [m] - posi��o do corpo no eixo z
%       x_dot [m/s] - varia��o da posi��o do corpo no eixo x
%       y_dot [m/s] - varia��o da posi��o do corpo no eixo y
%       z_dot [m/s] - varia��o da posi��o do corpo no eixo z
%   mu [m�/s] - par�metro gravitacional
%
% Sa�da:
%   output_vector - vetor de sa�da, contendo, nesta ordem:
%       a [m] - semieixo maior da �rbita
%       e [adim] - excentricidade da �rbita
%       inc [rad] - inclina��o da �rbita em rela��o ao equador 
%       omega_upper [rad] - ascen��o reta do nodo ascendente
%       omega_lower [rad] - argumento do perigeu
%       M [rad] - anomalia m�dia

%% Defini��o das entradas
x = input_vector(1);
y = input_vector(2);
z = input_vector(3);
x_dot = input_vector(4);
y_dot = input_vector(5);
z_dot = input_vector(6);

%% Semi-eixo maior

% r [m] - m�dulo do vetor posi��o
r = sqrt(x^2 + y^2 + z^2);

% v [m/s] - m�dulo do vetor velocidade
v = sqrt(x_dot^2 + y_dot^2 + z_dot^2);

a = 1/(2/r - (v^2)/mu);

%% Excentricidade

% n [s^(-1)] - movimento m�dio
n = sqrt(mu/(a^3));

term_1 = (dot([x, y, z],[x_dot, y_dot, z_dot])/(n*a^2));
term_2 = 1 - r/a;

e = sqrt(term_1^2 + term_2^2);

%% Anomalia M�dia

% u [rad] - anomalia exc�ntrica
u = atan2(term_1, term_2);

M = u - e*sin(u);

% Convers�o para �ngulo positivo, quando necess�rio
if M < 0
    M = M + 2*pi;
end

%% Inclina��o

% h [m^2/s] - momento angular espec�fico
h = norm(cross([x, y, z], [x_dot, y_dot, z_dot]));

% h_z [m^2/s] - componente em z do momento angular espec�fico
h_z = x*y_dot - y*x_dot;

inc = acos(h_z/h);

%% Ascen��o reta do nodo ascendente

% h_x [m^2/s] - componente em x do momento angular espec�fico
h_x = y*z_dot - z*y_dot;

% h_y [m^2/s] - componente em y do momento angular espec�fico
h_y = z*x_dot - x*z_dot;

omega_upper = atan2(h_x, -h_y);

% Convers�o para �ngulo positivo, quando necess�rio
if omega_upper < 0
    omega_upper = omega_upper + 2*pi;
end

%% Argumento do perigeu

% f [rad] - anomalia verdadeira
f = atan2(sin(u)*sqrt(1 - e^2), cos(u) - e); 

% upsilon [rad] - longitude verdadeira
upsilon = atan2(-cos(inc)*sin(omega_upper)*x + cos(inc)*cos(omega_upper)*y + sin(inc)*z, cos(omega_upper)*x + sin(omega_upper)*y);

omega_lower = upsilon - f;

% Convers�o para �ngulo positivo, quando necess�rio
if omega_lower < 0
    omega_lower = 2*pi + omega_lower;
end

%% Constr�i vetor de sa�da
output_vector = [a, e, inc, omega_upper, omega_lower, M];


