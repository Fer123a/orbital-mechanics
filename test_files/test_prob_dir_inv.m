% Test prob_direto and prob_inverso

filename = 'problema_dir_inv.xlsx';

data =  readtable(filename);

semi_eixo_maior = data{:,1};
excentricidade = data{:, 2};
inclinacao = data{:, 3};
nodo_ascendente = data{:, 4}; 
arg_perigeu = data{:, 5};
anomalia_media = data{:, 6};
x = cell(length(excentricidade),1);
y = cell(length(excentricidade),1);
z = cell(length(excentricidade),1);
x_dot = cell(length(excentricidade),1);
y_dot = cell(length(excentricidade),1);
z_dot = cell(length(excentricidade),1);

mu = 398600e9;

for i = 1 : length(excentricidade)
    input_vector = [semi_eixo_maior(i), excentricidade(i), inclinacao(i), nodo_ascendente(i), arg_perigeu(i), anomalia_media(i)];
    output_vector = prob_direto(input_vector, mu);
    x{i} = output_vector(1);
    y{i} = output_vector(2);
    z{i} = output_vector(3);
    x_dot{i} = output_vector(4);
    y_dot{i} = output_vector(5);
    z_dot{i} = output_vector(6);
end

T = table(x, y, z, x_dot, y_dot, z_dot);
writetable(T,filename,'Sheet',1,'Range','K3')


clear

filename = 'problema_dir_inv.xlsx';

data =  readtable(filename);

x = data{:,10};
y = data{:, 11};
z = data{:, 12};
x_dot = data{:, 13}; 
y_dot = data{:, 14};
z_dot = data{:, 15};
semi_eixo_maior = cell(length(x_dot),1);
excentricidade = cell(length(x_dot),1);
inclinacao = cell(length(x_dot),1);
nodo_ascendente = cell(length(x_dot),1);
arg_perigeu = cell(length(x_dot),1);
anomalia_media = cell(length(x_dot),1);

mu = 398600e9;

for i = 1 : length(x_dot)
    input_vector = [x(i), y(i), z(i), x_dot(i), y_dot(i), z_dot(i)];
    output_vector = prob_inverso(input_vector, mu);
    semi_eixo_maior{i} = output_vector(1);
    excentricidade{i} = output_vector(2);
    inclinacao{i} = output_vector(3);
    nodo_ascendente{i} = output_vector(4);
    arg_perigeu{i} = output_vector(5);
    anomalia_media{i} = output_vector(6);
        
end

T = table(semi_eixo_maior, excentricidade, inclinacao, nodo_ascendente, arg_perigeu, anomalia_media);
writetable(T,filename,'Sheet',1,'Range','S3')

