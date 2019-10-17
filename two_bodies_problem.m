function x_dot = two_bodies_problem(t, state_vector)

G = 6.674e-11;
m_1 = 1.989e30;
m_2 = 5.972e24;

% Desempacota os estados e calcula a entrada
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

x1_dot = x7;
x2_dot = x8;
x3_dot = x9;
x4_dot = x10;
x5_dot = x11;
x6_dot = x12;
x7_dot = 0;
x8_dot = 0;
x9_dot = 0;

f = atan2((x4 - x1), (x5 - x2));
r = sqrt((x4 - x1)^2 + (x5 - x2)^2 + (x6 - x3)^2);

x10_dot = -G*(m_1+m_2)*sin(f)/(r^2);
x11_dot = -G*(m_1+m_2)*cos(f)/(r^2);
x12_dot = 0;

% Monta o vetor x ponto
x_dot = [x1_dot; x2_dot; x3_dot; x4_dot; x5_dot; x6_dot;...
         x7_dot; x8_dot; x9_dot; x10_dot; x11_dot; x12_dot];

end

