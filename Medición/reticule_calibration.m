%Este programa agrega al análisis de la retícula un bucle for que recorre
%todas los posibles cortes de gaussianas

clear all
close all

NI = 20;%Número de imagenes a ser promediadas. Etiquetadas consecutivamente
sum_I = 0;

%Carga de la imagenes y promedio aritmético para cada color

for i = 1 : NI
    file = ['F:\Fotos autocolimador\EXP4\retícula\ima' num2str(i) '.bmp'];
    %file = ['F:\Fotos autocolimador\incertidumbre2\M2\zero\ima' num2str(i) '.bmp'];
    %file = ['F:\Fotos autocolimador\experimento 2 con nivel\retícula\' num2str(i) '.bmp'];
   
    rgb_img = imread(file);
    I = .2989*rgb_img(:,:,1) + .5870*rgb_img(:,:,2) + .1140*rgb_img(:,:,3);
    sum_I = sum_I + (double(I)+1);
end

I = sum_I/(NI);
%I_new_neg=1-(I_new./255);

%Llamo función que obtiene el centro de la retícula y quita el fondo.
[indC, indF, Isf] = scale_center(I); %Isf=image without backgroud

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%% ANÁLISIS HORIZONTAL %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

y = 1:50;
x = 1:770;
xmin = indC - 440;
ymin = indF - 70;
%corte de la imagen
Ic = imcrop(Isf,[xmin ymin 769 49]);%[xmin ymin width height]%

for j = 1 : 15  
    ch = squeeze(Ic(j,:));%cortes horizontales
    %fitting de 8 gaussianas
    [fith, gofh] = Fit_8gauss_H(x, ch);
    %obtengo los coeficientes de las gaussianas
    cH = coeffvalues(fith);
    bH = reshape(cH, 3, 8);
    b_fH = sort(bH(2,:));
    X = [ones(1,8)' (1:8)'];
    BH = b_fH';
    %modelo de regresión con los 8 centros de las gaussianas
    [bh, bint] = regress(BH, X);
    BHH(j) = bh(2);
    %incertidumbre del modelo lineal de regresión, obtengo con un 95%
    IH(j) = (bint(2,2) - bint(2,1))/2;
end

DX = mean(BHH);
ux = mean(IH);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%% ANÁLISIS VERTICAL %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
yv = 1:770;
xv = 1:50;
xmin = indC - 60;
ymin = indF - 330;
%corte de la imagen
Icv = imcrop(Isf,[xmin ymin 49 769]);%[xmin ymin width height]%

for j= 1 : 50
    cv = squeeze(Icv(:,j))';
    [fitv, gofv] = Fit_8gauss_V(yv, cv);
    cV = coeffvalues(fitv);
    bV = reshape(cV, 3, 8);
    b_fV = sort(bV(2, :));
    X = [ones(1,8)' (1:8)'];
    BV = b_fV';
    [bv, bintv] = regress(BV, X);
    IV(j) = (bintv(2,2)-bintv(2,1))/2;
    BVV(j) = bv(2);
end

DY = mean(BVV);
uy = mean(IV);

%Cálculo de DELTA XY, la distancia entre segmentos consecutivos de la
%escala:

DXY=(DX + DY)/2;
uxy=(ux + uy)/2;
