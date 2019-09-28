function u = kepler_eq_syms(M, e)
% KEPLER_EQ - Implementa o m�todo de Newton-Raphson para a Equa��o de 
% Kepler, calculando a anomalia exc�ntrica a partir da anomalia m�dia 
% e a excentricidade.
%
% Sintaxe: u = kepler_eq(M, e)
%
% Entradas:
%   M - anomalia m�dia em radianos
%   e - excentricidade da �rbita
%
% Sa�da:
%   u - anomalia exc�ntrica em radianos

%% Defini��o de par�metros:
% n_max - quantidade m�xima de itera��es do m�todo de Newton Raphson
n_max = 50;

% u_est_init - "chute" inicial da raiz
u_est_init = M; 

% toler - toler�ncia do m�todo
toler = 1e-7;

% u_est - vari�vel de itera��o
syms u_est

% f - diferen�a entre o valor estimado de M e o M real
f = u_est - e * sin(u_est) - M; 

% f_dot - derivada de f
f_dot = 1 - e*cos(u_est); 

% n - n�mero atual de itera��es realizadas
n = 0;

u_est = u_est_init;

%% Implementa��o do m�todo de Newton Raphson
while true
    u_est = u_est - eval(f)/eval(f_dot);
    n = n + 1;
    
    if abs(eval(f)) <= toler
        % Imprimir mensagem de sucesso
        u = u_est;
        disp("O m�todo convergiu com sucesso para a solu��o do problema")
        break
    end
    
    if n == n_max
        % Imprimir mensagem de erro (n�mero m�ximo de itera��es atingido)
        disp("O m�todo atingiu o n�mero m�ximo de itera��es e n�o obteve sucesso em encontrar uma solu��o para o problema.")
        break
    end
end

    
    