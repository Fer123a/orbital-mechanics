function x_dot = two_body_problem(~, state_vector, G, m_1, m_2)
%{
TWO_BODY_PROBLEM - Função utilizada juntamente com um integrador para
o cálculo do movimento dos corpos em uma representação em espaço de 
estados do problema gravitacional de dois corpos.

Entradas:
  ~ - input ignorado, placeholder para a variável temporal
  state_vector - vetor de estados do sistema, contendo, nesta ordem:
        x1 - posição do corpo central no eixo x
        x2 - posição do corpo central no eixo y 
        x3 - posição do corpo central no eixo z
        x4 - posição do corpo de massa menor no eixo x
        x5 - posição do corpo de massa menor no eixo y
        x6 - posição do corpo de massa menor no eixo z
        x7 - velocidade do corpo central no eixo x
        x8 - velocidade do corpo central no eixo y 
        x9 - velocidade do corpo central no eixo z
        x10 - velocidade do corpo de massa menor no eixo x
        x11 - velocidade do corpo de massa menor no eixo y
        x12 - velocidade do corpo de massa menor no eixo z
    G [Nm²/kg²] - Constante da gravitação universal
    m_1 [kg] - Massa do corpo central
    m_2 [kg] - Massa do corpo secundário

Saída:
  x_dot - vetor de derivadas dos estados do sistema, contendo, nesta ordem:
        x1_dot - derivada da posição do corpo central no eixo x
        x2_dot - derivada da posição do corpo central no eixo y 
        x3_dot - derivada da posição do corpo central no eixo z
        x4_dot - derivada da posição do corpo de massa menor no eixo x
        x5_dot - derivada da posição do corpo de massa menor no eixo y
        x6_dot - derivada da posição do corpo de massa menor no eixo z
        x7_dot - derivada da velocidade do corpo central no eixo x
        x8_dot - derivada da velocidade do corpo central no eixo y 
        x9_dot - derivada da velocidade do corpo central no eixo z
        x10_dot - derivada da velocidade do corpo de massa menor no eixo x
        x11_dot - derivada da velocidade do corpo de massa menor no eixo y
        x12_dot - derivada da velocidade do corpo de massa menor no eixo z
%}

%% Desempacota os estados e calcula a entrada
x1 = state_vector(1);
x2 = state_vector(2);
x3 = state_vector(3);
x4 = state_vector(4);
x5 = state_vector(5);
x6 = state_vector(6);
x7 = state_vector(7);
x8 = state_vector(8);
x9 = state_vector(9);
x10 = state_vector(10);
x11 = state_vector(11);
x12 = state_vector(12);

%% Calcula as derivadas das variáveis de posição
x1_dot = x7;
x2_dot = x8;
x3_dot = x9;
x4_dot = x10;
x5_dot = x11;
x6_dot = x12;

% f [rad] - anomalia verdadeira
f = atan2((x5 - x2), (x4 - x1));

% r [m] - distância entre os dois corpos
r = sqrt((x4 - x1)^2 + (x5 - x2)^2 + (x6 - x3)^2);

%% Calcula as derivadas das variáveis de velocidade
x7_dot = G*m_2*cos(f)/(r^2);
x8_dot = G*m_2*sin(f)/(r^2);
x9_dot = 0;

x10_dot = -G*m_1*cos(f)/(r^2);
x11_dot = -G*m_1*sin(f)/(r^2);
x12_dot = 0;

%% Monta o vetor x ponto
x_dot = [x1_dot; x2_dot; x3_dot; x4_dot; x5_dot; x6_dot;...
         x7_dot; x8_dot; x9_dot; x10_dot; x11_dot; x12_dot];

end

