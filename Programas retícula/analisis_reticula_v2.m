clear all
close all

NI = 20;%Número de imágenes a ser promediadas. Etiquetadas consecutivamente
sum_I = 0;
SumaTotal = 0;

%Carga de la imagenes y promedio aritmético para cada color
%---------------------------------------------------------------------------------------------------------------------------------
for i = 1:NI

    %Entrada para Windows
    f=['F:\Fotos autocolimador\EXP4\retícula\ima' num2str(i) '.bmp'];
    
    %bmp ingresa color por canal? o mezcla colores
    rgb_img = imread(f);
    I = .2989*rgb_img(:,:,1) + .5870*rgb_img(:, :, 2) + .1140*rgb_img(:, :, 3);

    sum_I = sum_I + (double(I) + 1);

end

%Imagen promedio en I_new
I_new = sum_I / NI;
%Muestro imagen promedio
figure; imagesc(I_new); colormap(gray)%1

%Niego imagen promedio y la muestro
%Enhance white and grey values that are in a predominant dark region. And
%put the gaussian peaks positives
%I_new_neg = imcomplement(I_new); se puede hacer de esta manera
I_new_neg = 1 - (I_new ./ 255);
figure; imagesc(I_new_neg); colormap(gray)%2
%--------------------------------------------------------------------------------------------------------------------------------------

%Elijo un sector de imagen que encierre 8 líneas para hacer procesamiento y
%lo muestro.
%------------------------------------------------------------------------
yy = 1:40;
xx = 1:750;%distancia óptima para esta experiencia

II = I_new_neg(640+yy, 440+xx); 
figure; imagesc(II); colormap(gray)%3
%------------------------------------------------------------------------

%Se hace un fitting de la zona preseleccionada
%--------------------------------------------------------------------------------
%fitresult entrega los coeficientes que arman la función de fiteo para el fondo.
%La función siguiente es creada mediante "cftool" la herramienta de fitting
%de matlab.


[xData, yData, zData] = prepareSurfaceData( xx, yy, II );

% Set up fittype and options.
ft = fittype( 'poly22' );
opts = fitoptions( ft );
opts.Lower = [-Inf -Inf -Inf -Inf -Inf -Inf];
opts.Robust = 'Bisquare';
opts.Upper = [Inf Inf Inf Inf Inf Inf];

% Fit model to data.
[fitresult, gof] = fit( [xData, yData], zData, ft, opts );


%Para ver superficie completa con fondo y con los picos gaussianos
figure; surf(xx, yy, II);%4
%-------------------------------------------------------------------------------

%Obtengo el fondo y luego lo resto de la imagen completa para obtener
%la imagen sin fondo
%----------------------------------------------------------------------------------
%Con meshgrid genero una matriz con los dos vectores xx and yy.
%En promfit obtengo el fondo separado de los picos.
[t1,t2] = meshgrid(xx, yy);
promfit = fitresult(t1, t2);% Si corro fitresult en funciÃ³n de las variables independientes obtengo el fondo

%figura del fondo
figure; surf(t1, t2, promfit);%5

%Resto el fondo y grafico la imagen final. Es necesario usar "abs" para que
%los picos no queden al revés.
J= abs(promfit - II);

figure; imagesc(J); colormap(gray)%6
figure; surf(t1, t2, J);%7
%---------------------------------------------------------------------------------


%Procesamiento sobre cortes de las gaussianas 3D
%----------------------------------------------------------------------------------
%Corto la gaussiana 3D para obtener una 2D
cv= squeeze(II(30,:));
cv2= squeeze(J(30,:));

figure; plot(xx, cv, 'r', 'LineWidth', 2); hold on%8
plot(xx, cv2, 'b', 'LineWidth', 2); hold on%8
%legend('corte imagen', 'corte imagen sin fondo')
%---------------------------------------------------------------------------------


%Fitting 8 Gaussianas 2D del corte
%------------------------------------------------------------------------------------
%Corte de 8 Gaussianas, para hacerlo se obsrva la imagen previamente

[fit2, gof2] = Fit_8gauss_H(xx, cv2);%Hice el fiteo de nuevo con cftool y cree una nueva función

% Plot fit with data. Lo siguiente es parte de la función que entrega cftool 
%
[xData, yData] = prepareCurveData( xx, cv2 );

figure; plot(fit2, xData, yData)%9 gráfico del fittin del corte de las 8 gaussianas
%legend('horizontal fit', 'least square fit full parameters', 'Location', 'NorthEast' );
% Label axes
xlabel( 'xx' );
ylabel( 'corte horizontal' );
grid on
%----------------------------------------------------------------------------------------------------------

%Cálculo de incertidumbres
%-----------------------------------------------------------------------------------------------------
cH= coeffvalues(fit2);%coeffvalues entrega los coeficientes de c/u de las 8 gaussianas
bH= reshape(cH, 3, 8);%acomodamos la matriz de coeficientes para que queden agrupados por columnas
b_fH= sort( bH(2, :));%me interesan los valores "b" de cada gaussiana

X=[ones(1,8)' (1:8)'];

%Columna de valores centrales de gaussianas
BH= b_fH';

%Modelo lineal de los valores de b
%Me va a permitir conocer si se genera una recta lo suficientemente
%perfecta debido a la distancia entre gaussianas
mdl = LinearModel.fit(BH, 1:8); 

%Grafico la recta
figure; plot(mdl)%10 gráfico de la recta de regresión

%Modelo de regresión
[bh, bint, r, rint] = regress(BH, X);
%Grafico los residuos
figure; rcoplot(r, rint)%11 gráfico de residuos

incertezaH= (bint(2,2) - bint(2,1)) / 2;

%Presento valores en terminal
bh
incertezaH
createfigure_fig7(1:8, BH)%12 figura de recta y residuos

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Realizo el fitting forzando la primer gaussiana y obteniedo los otros centros y obtengo incertezas
%------------------------------------------------------------------------------------------
[fit3, gof3] =  Fit_un_paso_Gauss_H(xx, cv2);

% Plot fit with data.
figure; plot(fit3, xData, yData)%13 gráfico del fittin realizado de 
%legend('horizontal fit', 'least square fit reduced parameters', 'Location', 'NorthEast' );
% Label axes
xlabel( 'xx' );
ylabel( 'corte horizontal' );
grid on


cH2= coeffvalues(fit3);
bH2= cH2(10);
ci = confint(fit3, 0.95);

incertezaH2= ci(2,10) - ci(1,10);

%Presento valores en terminal
bH2
incertezaH2
%-------------------------------------------------------------------------------------------

% whichstats = {'beta','rsquare','covb', };
% stats = regstats(B,1:5,'linear',whichstats);
% beta = stats.beta;
% rsquare = stats.rsquare;
% covb=stats.covb;



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Región VERTICAL de la RETÍCULA 

%Elijo un sector de imagen para hacer proceso y la muestro
%------------------------------------------------------------------------
yy2= 1:750;
xx2= 1:40;

III= I_new_neg(303+yy2, 690+xx2);
figure; imagesc(III); colormap(gray)%14 gráfico de las 8 líneas verticales cortadas

%Fución del fondo.
[fitresult2, gof2] = Fit_fondo_V(xx2, yy2, III);

%Para ver superficie completa con fondo y con los picos gaussianos
figure; surf(xx2, yy2, III);%15

%Función del fondo
[t_1, t_2]= meshgrid(xx2, yy2);
promfit2= fitresult2(t_1, t_2);
figure; surf(t_1,t_2, promfit2);%16 figura del fondo fitiado.

%Resto el fondo
J2= abs(promfit2 - III);
figure; imagesc(J2); colormap(gray)%17 líneas sin fondo (similar a 14)

%Figura en 3D sin fondo
figure; surf(t_1, t_2, J2);% 18 picos en 3D sin el fondo




%Tomamos una sección de la 3D
cv_1=squeeze(III(:,20));
cv_2= squeeze( J2(:, 20));

figure; plot(yy2, cv_1, 'r', 'LineWidth', 2); hold on%19
plot(yy2, cv_2, 'b', 'LineWidth', 2); hold on%19
%legend('cv_2')

%Se busca un fiteo en la zona
%--------------------------------------------------------------------------------
%fitresult entrega los coeficientes que arman la función de fiteo para el fondo.
%La función siguiente es creada mediante "cftool" la herramienta de fitting
%de matlab.
%Fitting del corte
[fitv, gofv] = Fit_8gauss_V(yy2', cv_2);%Nuevo

% Plot fit with data.
[xDatav, yDatav] = prepareCurveData( yy2', cv_2 );

figure; plot(fitv,xDatav, yDatav)%20 figura del fiteo vertical
%legend('vertical fit', 'least square fit full parameters', 'Location', 'NorthEast' );
% Label axes
xlabel( 'yy' );
ylabel( 'corte vertical' );
grid on
%-------------------------------------------------------------------------------------


%Cálculo de incertidumbres
%-------------------------------------------------------------------------------------
cVv= coeffvalues(fitv);
bV= reshape( cVv, 3, 8);
b_fV= sort( bV(2, :));

X= [ones(1,8)' (1:8)'];

%Columna de valores centrales de gaussianas
BV= b_fV';

%Modelo lineal de los valores de b
%Me va a permitir conocer si se genera una recta lo suficientemente
%perfecta debido a la distancia entre gaussianas
mdlV = LinearModel.fit(BV, 1:8); 
figure; plot(mdlV)%22 figura de la recta de regresión
 
%Modelo de regresiÃ³n
[bv, bintv, rv, rintv] = regress(BV, X);
%Grafico los residuos
figure; rcoplot(rv, rintv)%23

incertezaV=(bintv(2,2) - bintv(2,1)) / 2;

%Presento valores
bv
incertezaV
createfigure_fig7(1:8, BV)%24
%Realizo el fitting forma forzada y obtengo incertezas
%------------------------------------------------------------------------------------------
[fit4, gof4] =  Fit_un_paso_Gauss_H(yy2', cv_2);%Utilizo la misma función que en la zona horizontal

% Plot fit with data.
figure; plot(fit4, xDatav, yDatav)%25
%legend('horizontal fit', 'least square fit reduced parameters', 'Location', 'NorthEast' );
% Label axes
xlabel( 'yy' );
ylabel( 'corte vertical' );
grid on


cV_2= coeffvalues(fit4);
bV2= cV_2(10);
ciV = confint(fit4, 0.95);

incertezaV2= ciV(2,10) - ciV(1,10);

%Presento valores
bV2
incertezaV2

