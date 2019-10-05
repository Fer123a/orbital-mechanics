function [init_vel_vector, fin_vel_vector] = lambert(init_pos_vector, fin_pos_vector, delta_t, mu, traj_flag)
%{
LAMBERT - Fun��o que resolve o Problema de Lambert;
Determina uma �rbita de transfer�ncia que conecta
dois vetores de posi��o, tendo o tempo entre eles.

Entradas:
  init_pos_vector - vetor da posi��o inicial, contendo, nesta ordem:
      x_0 [m] - componente da posi��o inicial no eixo x
      y_0 [m] - componente da posi��o inicial no eixo y
      z_0 [m] - componente da posi��o inicial no eixo z
  fin_pos_vector - vetor da posi��o final, contendo, nesta ordem:
      x_f [m] - componente da posi��o final no eixo x
      y_f [m] - componente da posi��o final no eixo y
      z_f [m] - componente da posi��o final no eixo z
  delta_t [s] - tempo da manobra
  mu [m�/s] - par�metro gravitacional
  traj_flag [adim] - vari�vel l�gica. Caso seu valor seja "true", ser�
calculada a trajet�ria longa; caso seu valor seja "false", ser� calculada
a trajet�ria curta.

Sa�da:
  init_vel_vector - vetor da velocidade inicial, contendo, nesta ordem:
      x_dot_0 [m/s] - componente da velocidade inicial no eixo x
      y_dot_0 [m/s] - componente da velocidade inicial no eixo y
      z_dot_0 [m/s] - componente da velocidade inicial no eixo z
  fin_vel_vector - vetor da velocidade final, contendo, nesta ordem:
      x_dot_f [m/s] - componente da velocidade final no eixo x
      y_dot_f [m/s] - componente da velocidade final no eixo y
      z_dot_f [m/s] - componente da velocidade final no eixo z
%}

%% Manipula��o das Entradas

% r_0 [m] - norma do vetor posi��o inicial
r_0 = norm(init_pos_vector);

% r_f [m] - norma do vetor posi��o final
r_f = norm(fin_pos_vector);

% delta_phi [rad] - altera��o na anomalia verdadeira entre as posi��es
% inicial e final
if traj_flag
    delta_phi = 2*pi - acos(dot(init_pos_vector, fin_pos_vector)/(r_0*r_f));
else
    delta_phi = acos(dot(init_pos_vector, fin_pos_vector)/(r_0*r_f)); 
end

% A [km] - vari�vel intermedi�ria
A = sqrt(r_0*r_f/(1-cos(delta_phi)))*sin(delta_phi);

%% Busca por z entre 0 e 4*pi^2

% lower_boundary [rad] - limite inferior de busca por z
lower_boundary = 0;
% upper_boundary [rad] - limite superior de busca por z
upper_boundary = 4*pi^2;

% current_est [rad] - diferen�a entre o delta_t de entrada e delta_t_est
% calculada na itera��o atual
current_est = inf;

while abs(current_est) > 1e-6
    % n [adim] - contador de itera��es
    n = 0;
    % interval [rad] - vetor contendo os pontos de busca por z
    interval = linspace(lower_boundary, upper_boundary, 10);
    % previous_est [rad] - diferen�a entre o delta_t de entrada e delta_t_est
    % calculada na itera��o anterior
    previous_est = inf;
    current_est = inf;
    for z_est = interval
        % C [adim], S [adim], y [m], x [m] - vari�veis intermedi�rias
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
                    % Regra do sandu�che (se houve mudan�a de sinal entre dois
                    % pontos, o zero da fun��o est� entre esses dois pontos)
                    lower_boundary = interval(n-1);
                    upper_boundary = z_est;
                    break
                end
            end
        end
        previous_est = current_est;
    end      
end

%% Determina��o das sa�das

% f [adim], g [s], g_dot [adim] - coeficientes de Lagrange
f = 1 - y/r_0;
g = A*sqrt(y/mu);
g_dot = 1 - y/r_f;

% Constr�i vetores de sa�da
init_vel_vector = 1/g*(fin_pos_vector - f*init_pos_vector);
fin_vel_vector= 1/g*(g_dot*fin_pos_vector - init_pos_vector);
