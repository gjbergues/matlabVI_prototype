%horario=0;
%antihorio=1;

function  [BHHtf]= cruz_rgb(k,h)

    NI = 20;%Numero de imagenes a ser 	promediadas.Etiquetadas consecutivamente
	sum_I = 0;
	SumaTotal = 0;
    n = 5; %nº de cortes de gaussianas
	
    d = 51-k; %Para cuando es el sentido horario, empiezo del directorio 50
    
     sumaR=0;;
        sumaG=0;
        sumaB=0;
    
	for i=1:NI
 
       
        if h==1
            f=['I:\EXP4\ahorario\p' num2str(k-1) '\ima' num2str(i) '.bmp'];
            %f=['F:\Fotos autocolimador\EXP9\antihorario\p' num2str(k-1) '\ima' num2str(i) '.bmp'];
            %f=['J:\DATOS\TECNOLOGICA\datos_paper_pattern\Exp 2\ahorario\p' num2str(k-1) '\ima' num2str(i) '.bmp'];
        end
        
        if h==0
            f=['I:\EXP4\horario\p' num2str(d) '\ima' num2str(i) '.bmp'];
            %f=['J:\DATOS\TECNOLOGICA\datos_paper_pattern\Exp 2\horario\p' num2str(d) '\ima' num2str(i) '.bmp'];
        end
        
        %bmp ingresa color por canal? o mezcla colores?
 
               
        imagen=double(imread(f));
        R=squeeze(imagen(:,:,1));%Imagen roja- Tamaï¿½o matriz X(480,640) 480 es el Nï¿½ de pixeles en el eje Y usual
        G=squeeze(imagen(:,:,2));%Imagen verde
        B=squeeze(imagen(:,:,3));%Imagen azul
        
        sumaR=sumaR+R;
        sumaG=sumaG+G;
        sumaB=sumaB+B;
        
   
 
    end
 
    
promR=sumaR/(NI-2);% Imagen Roja promedio
promG=sumaG/(NI-2);% Imagen verde promedio
promB=sumaB/(NI-2);% Imagen azul promedio
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%ROJO%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    [bvu, bhu]=centercruz_function2(promR);%obtengo el centro por cada imagen
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%% LINEA HORIZONTAL DE LA CRUZ%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 	y = 1:200;
	x = 1:200;
    
    xminh= bvu-230;
    yminh = bhu-100;
    
    Isf_c = imcrop(promR,[xminh yminh 199 199]);%[xmin ymin width height]% 
    
	%figure; imagesc(II); colormap(gray)% para ver cada corte
    
%     %Creo con cftool el fitting del fondo
% 	[fitfh, goffh] = Fit_fondo_cruz_H(x, y, I);
%     %figure; surf(xx, yy, II);
%     
%     [t1,t2] = meshgrid( x,y);
%     promfit = fitfh( t1, t2);
%     %figure; surf(t1, t2, promfit);
% 
%     Jh = abs(promfit-I);
%     %figure; imagesc(J2); colormap(gray)
%     %figure; surf(xx, yy, J2);
    
        
    for j = 1:n
      cv = squeeze(Isf_c(:,j));
      [fith, gofh] =  Fit_un_paso_Gauss_CRUZ_H(x', cv);
 
      ch = coeffvalues(fith);
      cih = confint(fith, 0.95);
 
      BHH(j) = ch(2); %valor central de la gaussiana para cada corte
      IH(j) = (cih(2,2)-cih(1,2))/2; %incertidumbre para cada corte
    end

    %mdlV = LinearModel.fit(1:5, BHH); 
    %figure; plot(mdlV)
 
    %Regregresión
    %X = [ones(1,5)' (1:5)'];
    %[bv, bintv, rv, rintv] = regress(BHH', X);
    %BHHt=bv(1)+635-(k-1)*6;

    %Promedio
    BHHt = sum(BHH)/n + yminh;
    
   
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%VERDE%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    [bvu2, bhu2]=centercruz_function2(promG);%obtengo el centro por cada imagen
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%% LINEA HORIZONTAL DE LA CRUZ%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 	y = 1:200;
	x = 1:200;
    
    xminh2= bvu2-230;
    yminh2 = bhu2-100;
    
    Isf_c2 = imcrop(promG,[xminh2 yminh2 199 199]);%[xmin ymin width height]% 
    
	%figure; imagesc(II); colormap(gray)% para ver cada corte
    
%     %Creo con cftool el fitting del fondo
% 	[fitfh, goffh] = Fit_fondo_cruz_H(x, y, I);
%     %figure; surf(xx, yy, II);
%     
%     [t1,t2] = meshgrid( x,y);
%     promfit = fitfh( t1, t2);
%     %figure; surf(t1, t2, promfit);
% 
%     Jh = abs(promfit-I);
%     %figure; imagesc(J2); colormap(gray)
%     %figure; surf(xx, yy, J2);
    
        
    for j = 1:n
      cv2 = squeeze(Isf_c2(:,j));
      [fith2, gofh2] =  Fit_un_paso_Gauss_CRUZ_H(x', cv2);
 
      ch2 = coeffvalues(fith2);
      cih2 = confint(fith2, 0.95);
 
      BHH2(j) = ch2(2); %valor central de la gaussiana para cada corte
      IH2(j) = (cih2(2,2)-cih2(1,2))/2; %incertidumbre para cada corte
    end

    %mdlV = LinearModel.fit(1:5, BHH); 
    %figure; plot(mdlV)
 
    %Regregresión
    %X = [ones(1,5)' (1:5)'];
    %[bv, bintv, rv, rintv] = regress(BHH', X);
    %BHHt=bv(1)+635-(k-1)*6;

    %Promedio
    BHHt2 = sum(BHH2)/n + yminh2;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%AZUL%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    [bvu3, bhu3]=centercruz_function2(promB);%obtengo el centro por cada imagen
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%% LINEA HORIZONTAL DE LA CRUZ%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 	y = 1:200;
	x = 1:200;
    
    xminh3= bvu3-230;
    yminh3 = bhu3-100;
    
    Isf_c3 = imcrop(promB,[xminh3 yminh3 199 199]);%[xmin ymin width height]% 
    
	%figure; imagesc(II); colormap(gray)% para ver cada corte
    
%     %Creo con cftool el fitting del fondo
% 	[fitfh, goffh] = Fit_fondo_cruz_H(x, y, I);
%     %figure; surf(xx, yy, II);
%     
%     [t1,t2] = meshgrid( x,y);
%     promfit = fitfh( t1, t2);
%     %figure; surf(t1, t2, promfit);
% 
%     Jh = abs(promfit-I);
%     %figure; imagesc(J2); colormap(gray)
%     %figure; surf(xx, yy, J2);
    
        
    for j = 1:n
      cv3 = squeeze(Isf_c3(:,j));
      [fith3, gofh3] =  Fit_un_paso_Gauss_CRUZ_H(x', cv3);
 
      ch3 = coeffvalues(fith3);
      cih3 = confint(fith3, 0.95);
 
      BHH3(j) = ch3(2); %valor central de la gaussiana para cada corte
      IH3(j) = (cih3(2,2)-cih3(1,2))/2; %incertidumbre para cada corte
    end

    %mdlV = LinearModel.fit(1:5, BHH); 
    %figure; plot(mdlV)
 
    %Regregresión
    %X = [ones(1,5)' (1:5)'];
    %[bv, bintv, rv, rintv] = regress(BHH', X);
    %BHHt=bv(1)+635-(k-1)*6;

    %Promedio
    BHHt3 = sum(BHH2)/n + yminh3;   


     BHHtf =  (BHHt+ BHHt2+ BHHt3)/3;
    
end