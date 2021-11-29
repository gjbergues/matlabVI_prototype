

c = xlsread('medidas1.xlsx', 1, 'A1:A10'); %datos de cabeceo
g = xlsread('medidas1.xlsx', 1, 'B1:B10'); %datos de guiñada

nc = fitdist(c, 'Normal');
ng = fitdist(g, 'Normal');

x_values = -0.1:0.0001:0.1;
yc = pdf(nc, x_values);
yg = pdf(ng, x_values);


plot(x_values, yc, 'LineWidth',2, 'color','r')%cabeceo
hold on

plot(x_values, yg, 'LineWidth', 2)%Guiñada
legend('Cabeceo','Guiñada');