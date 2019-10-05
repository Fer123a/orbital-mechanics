function [init_vel_vector, fin_vel_vector] = lambert(init_pos_vector, fin_pos_vector, delta_t, mu, traj_flag)
%{
LAMBERT - Função que resolve o Problema de Lambert;
Determina uma órbita de transferência que conecta
dois vetores de posição, tendo o tempo entre eles.

Entradas:
  init_pos_vector - vetor da posição inicial, contendo, nesta ordem:
      x_0 [m] - componente da posição inicial no eixo x
      y_0 [m] - componente da posição inicial no eixo y
      z_0 [m] - componente da posição inicial no eixo z
  fin_pos_vector - vetor da posição final, contendo, nesta ordem:
      x_f [m] - componente da posição final no eixo x
      y_f [m] - componente da posição final no eixo y
      z_f [m] - componente da posição final no eixo z
  delta_t [s] - tempo da manobra
  mu [m³/s] - parâmetro gravitacional
  traj_flag [adim] - variável lógica. Caso seu valor seja "true", será
calculada a trajetória longa; caso seu valor seja "false", será calculada
a trajetória curta.

Saída:
  init_vel_vector - vetor da velocidade inicial, contendo, nesta ordem:
      x_dot_0 [m/s] - componente da velocidade inicial no eixo x
      y_dot_0 [m/s] - componente da velocidade inicial no eixo y
      z_dot_0 [m/s] - componente da velocidade inicial no eixo z
  fin_vel_vector - vetor da velocidade final, contendo, nesta ordem:
      x_dot_f [m/s] - componente da velocidade final no eixo x
      y_dot_f [m/s] - componente da velocidade final no eixo y
      z_dot_f [m/s] - componente da velocidade final no eixo z
%}

%% Manipulação das Entradas

% r_0 [m] - norma do vetor posição inicial
r_0 = norm(init_pos_vector);

% r_f [m] - norma do vetor posição final
r_f = norm(fin_pos_vector);

% delta_phi [rad] - alteração na anomalia verdadeira entre as posições
% inicial e final
if traj_flag
    delta_phi = 2*pi - acos(dot(init_pos_vector, fin_pos_vector)/(r_0*r_f));
else
    delta_phi = acos(dot(init_pos_vector, fin_pos_vector)/(r_0*r_f)); 
end

% A [km] - variável intermediária
A = sqrt(r_0*r_f/(1-cos(delta_phi)))*sin(delta_phi);

%% Busca por z entre 0 e 4*pi^2

% lower_boundary [rad] - limite inferior de busca por z
lower_boundary = 0;
% upper_boundary [rad] - limite superior de busca por z
upper_boundary = 4*pi^2;

% current_est [rad] - diferença entre o delta_t de entrada e delta_t_est
% calculada na iteração atual
current_est = inf;

while abs(current_est) > 1e-6
    % n [adim] - contador de iterações
    n = 0;
    % interval [rad] - vetor contendo os pontos de busca por z
    interval = linspace(lower_boundary, upper_boundary, 10);
    % previous_est [rad] - diferença entre o delta_t de entrada e delta_t_est
    % calculada na iteração anterior
    previous_est = inf;
    current_est = inf;
    for z_est = interval
        % C [adim], S [adim], y [m], x [m] - variáveis intermediárias
        n = n + 1;
        if z_est == 0
            C = 1/2;
            S = 1/6;
        else
            C = (1 - cos(sqrt(z_est)))/z_est;
            S = (sqrt(z_est) - sin(sqrt(z_est)))/(z_est^(3/2));
        end
        y = r_0 + r_f - A*(1 - z_est*S)/sqrt(C);
        x = sqrt(y/C);
        
        delta_t_est = 1/sqrt(mu)*(x^3*S + A*sqrt(y));
        
        current_est = delta_t - delta_t_est;
        
        if abs(current_est) <= 1e-6
            break
        else
            if n ~= 1
                % Atualiza fronteiras de busca
                if ~isequal(sign(current_est), sign(previous_est))
                    % Regra do sanduíche (se houve mudança de sinal entre dois
                    % pontos, o zero da função está entre esses dois pontos)
                    lower_boundary = interval(n-1);
                    upper_boundary = z_est;
                    break
                end
            end
        end
        previous_est = current_est;
    end      
end

%% Determinação das saídas

% f [adim], g [s], g_dot [adim] - coeficientes de Lagrange
f = 1 - y/r_0;
g = A*sqrt(y/mu);
g_dot = 1 - y/r_f;

% Constrói vetores de saída
init_vel_vector = 1/g*(fin_pos_vector - f*init_pos_vector);
fin_vel_vector= 1/g*(g_dot*fin_pos_vector - init_pos_vector);
