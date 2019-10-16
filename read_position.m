function state_matrix = read_position(time_stamp, bodies_names)
%{
READ_POSITION - Fun��o que busca no arquivo 'elementos_orbitais.txt',
os elementos kleperianos que definem a �rbita de um ou mais corpos
e retorna os vetores de estado que define a �rbita desses corpos,
passado um certo tempo,  dispostos em uma matriz.

Entradas:
  time_stamp [dias] - instante de tempo, ap�s J2000, para o qual se deseja
saber a posi��o e velocidade do corpo;
  bodies_names - cell array contendo o nome dos corpos de interesse;

Sa�da:
  state_matrix - matriz de estados, em que cada coluna representa
um dos corpos de interesse, dispostos na mesma ordem de bodies_names,
e as linhas representam, respectivamente:
     x [m] - posi��o do corpo no eixo x
     y [m] - posi��o do corpo no eixo y
     z [m] - posi��o do corpo no eixo z
     x_dot [m/s] - varia��o da posi��o do corpo no eixo x
     y_dot [m/s] - varia��o da posi��o do corpo no eixo y
     z_dot [m/s] - varia��o da posi��o do corpo no eixo z

%}

%% Inicializa��o dos par�metros
% mu_sun [m�/s�], mu_earth [m�/s�] - Par�metros gravitacionais 
mu_sun = 1.32712440018e20;
mu_earth = 3.986004418e14;

% au_to_m - Fator de convers�o de Unidades Astron�micas para metros 
au_to_m = 149597870691;

state_matrix = zeros(6, length(bodies_names));

% t_sec [s] - instante de tempo de interesse em segundos
t_sec = time_stamp*3600*24;

% Leitura dos dados
data_table = readtable('elementos_orbitais.txt', 'Format', '%s%s%f%f%f%f%f%f');

data_cell_array = table2cell(data_table);

%% Busca pelos corpos de interesse
% Itera pela lista de corpos de interesse 
for index = 1:length(bodies_names)
    
    % Encontra o �ndice em "data_cell_array" correspondende ao corpo de
    % interesse
    body_index = find(strcmp({data_cell_array{:,1}}, bodies_names{index}));
    
    if body_index < 10
        mu = mu_sun;
    else
        mu = mu_earth;
    end
    
    a = data_cell_array{body_index, 3}*au_to_m;
    e = data_cell_array{body_index, 4};
    i = deg2rad(data_cell_array{body_index, 5});
    omega_upper = deg2rad(data_cell_array{body_index, 6});
    omega_lower = deg2rad(data_cell_array{body_index, 7});
    M = deg2rad(data_cell_array{body_index, 8}) + sqrt(mu/(a^3))*t_sec;
    
    % Limita o intervalo de M entre [0 2*pi]
    M = wrapTo2Pi(M);
    
    input_vector = [a, e, i, omega_upper, omega_lower, M];
    
    % Constr�i a coluna para o corpo de interesse atual
    state_matrix(:, index) = prob_direto(input_vector, mu);
    
end
