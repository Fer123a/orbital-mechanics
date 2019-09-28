% Test kepler_eq.m using 

filename = 'kepler_eq_test.xlsx';

data =  readtable(filename);

excentricidade = data{:,1};
anomalia_excentrica = data{:,2};
anomalia_media = data{:,3};
anomalia_excentrica_calculada = cell(length(anomalia_excentrica),1);

tic
for i = 1 : length(excentricidade)
    u = kepler_eq(anomalia_media(i), excentricidade(i));
    anomalia_excentrica_calculada{i} = u;
    disp(u)
    disp(u - anomalia_excentrica(i));
end
toc

T = table(anomalia_excentrica_calculada);
writetable(T,filename,'Sheet',1,'Range','F3')