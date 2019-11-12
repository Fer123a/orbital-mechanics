function x_dot = n_body_problem(~, state_vector, masses_vector)
    %{
    N_BODY_PROBLEM - Fun��o utilizada juntamente com um integrador para
    o c�lculo do movimento dos corpos em uma representa��o em espa�o de 
    estados do problema gravitacional de N corpos.

    Entradas:
      ~ - input ignorado, placeholder para a vari�vel temporal
      state_vector - vetor de estados do sistema, contendo, nesta ordem:
            x(1 + 6(n-1)) - posi��o do corpo "n" no eixo x
            x(2 + 6(n-1)) - posi��o do corpo "n" no eixo y 
            x(3 + 6(n-1)) - posi��o do corpo "n" no eixo z
            x(4 + 6(n-1)) - velocidade do corpo "n" no eixo x
            x(5 + 6(n-1)) - velocidade do corpo "n" no eixo y
            x(6 + 6(n-1)) - velocidade do corpo "n" no eixo z
      masses_vector - vetor contendo as massas dos corpos

    Sa�da:
      x_dot - vetor de derivadas dos estados do sistema, contendo, nesta ordem:
            x(1 + 6(n-1))_dot - derivada da posi��o do corpo "n" no eixo x
            x(2 + 6(n-1))_dot - derivada da posi��o do corpo "n" no eixo y 
            x(3 + 6(n-1))_dot - derivada da posi��o do corpo "n" no eixo z
            x(4 + 6(n-1))_dot - derivada da velocidade do corpo "n" no eixo x
            x(5 + 6(n-1))_dot - derivada da velocidade do corpo "n" no eixo y
            x(6 + 6(n-1))_dot - derivada da velocidade do corpo "n" no eixo z
    %}

    %% Defini��es iniciais
    
    % G [Nm�/kg�] - Constante da gravita��o universal
    G = 6.674e-11;

    % bodies_qty [adim] - n�meros de corpos do sistema
    bodies_qty = length(masses_vector);

    x_dot = zeros(6*bodies_qty, 1);
    
    %% C�lculo das derivadas dos estados
    for i = 1 : bodies_qty
        
        % C�lculo das derivadas da posi��o
        x_dot(1 + 6*(i-1) : 3 + 6*(i-1)) = state_vector(4 + 6*(i-1) : 6 + 6*(i-1));
        
        for j = 1 : bodies_qty
            if i ~= j
                
                % r_ij [m] - vetor que liga o corpo "i" ao corpo "j" 
                r_ij = state_vector(1 + 6*(j-1) : 3 + 6*(j-1)) - state_vector(1 + 6*(i-1) : 3 + 6*(i-1));
                
                % C�lculo das derivadas da velocidade
                x_dot(4 + 6*(i-1) : 6 + 6*(i-1)) = x_dot(4 + 6*(i-1) : 6 + 6*(i-1)) + G*masses_vector(j)*r_ij/(norm(r_ij)^3); 
                
            end
        end
    end

end

