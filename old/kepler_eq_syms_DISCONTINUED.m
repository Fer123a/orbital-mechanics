function u = kepler_eq_syms(M, e)
% KEPLER_EQ - Implementa o método de Newton-Raphson para a Equação de 
% Kepler, calculando a anomalia excêntrica a partir da anomalia média 
% e a excentricidade.
%
% Sintaxe: u = kepler_eq(M, e)
%
% Entradas:
%   M - anomalia média em radianos
%   e - excentricidade da órbita
%
% Saída:
%   u - anomalia excêntrica em radianos

%% Definição de parâmetros:
% n_max - quantidade máxima de iterações do método de Newton Raphson
n_max = 50;

% u_est_init - "chute" inicial da raiz
u_est_init = M; 

% toler - tolerância do método
toler = 1e-7;

% u_est - variável de iteração
syms u_est

% f - diferença entre o valor estimado de M e o M real
f = u_est - e * sin(u_est) - M; 

% f_dot - derivada de f
f_dot = 1 - e*cos(u_est); 

% n - número atual de iterações realizadas
n = 0;

u_est = u_est_init;

%% Implementação do método de Newton Raphson
while true
    u_est = u_est - eval(f)/eval(f_dot);
    n = n + 1;
    
    if abs(eval(f)) <= toler
        % Imprimir mensagem de sucesso
        u = u_est;
        disp("O método convergiu com sucesso para a solução do problema")
        break
    end
    
    if n == n_max
        % Imprimir mensagem de erro (número máximo de iterações atingido)
        disp("O método atingiu o número máximo de iterações e não obteve sucesso em encontrar uma solução para o problema.")
        break
    end
end

    
    
