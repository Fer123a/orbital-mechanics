possible_bodies = {'Mercurio', 'Venus', 'Terra', 'Marte', 'Jupiter', 'Saturno', 'Urano', 'Netuno', 'Plutao', 'Lua'};

filename = 'test_read_position.xlsx';

for i = 1:100
    time_stamp = randi(100000000);
    
    number_of_bodies = randi(10);
    
    bodies_names = cell(length(number_of_bodies));
    
    for j = 1:number_of_bodies
        bodies_names{j} = possible_bodies{randi(10)};
    end
    
    x = cell(1, length(bodies_names));
    y = cell(1, length(bodies_names));
    z = cell(1, length(bodies_names));
    x_dot = cell(1, length(bodies_names));
    y_dot = cell(1, length(bodies_names));
    z_dot = cell(1, length(bodies_names));

    state_matrix = read_position(time_stamp, bodies_names);
    state_matrix(:, 1) = state_matrix(:, 1)/149597870691;
    state_matrix(:, 3) = rad2deg(state_matrix(:, 3));
    state_matrix(:, 4) = rad2deg(state_matrix(:, 4));
    state_matrix(:, 5) = rad2deg(state_matrix(:, 5));
    
    state_matrix = [bodies_names;num2cell(state_matrix)];
    T = table(state_matrix);
    writetable(T, fullfile(pwd, 'test_files', filename),'Sheet',1,'Range',['K', num2str(3 + 10*(i-1))]);
    
end
        
    

