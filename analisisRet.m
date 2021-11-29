clear
NI=20;%Numero de imagenes a ser promediadas.Etiquetadas consecutivamente
NP=128;%Tama�o util (en numero de pixeles) de la foto inicial(480x640)
PcY=275;%pixel central en la direccion Y donde se centrar� el recorte (+-NP/2)
PcX=300;%pixel central en la direccion X donde se centrar� el recorte (+-NP/2)
sumaR=0;
promR=0;
sumaG=0;
promG=0;
sumaB=0;
promB=0;
SumaTotal=0;

%Carga de la imagenes y promedio aritm�tico para cada color
for i=1:NI
f=['/media/B/Doctorado/Fotos Autocolimador/Diagonal apunta escritorio 4/pos 1/reticula 1/Image-' num2str(i) '.bmp'];
imagen=double(imread(f));
SumaTotal=SumaTotal+imagen;
R=squeeze(imagen(:,:,1));%Imagen roja- Tama�o matriz X(480,640) 480 es el N� de pixeles en el eje Y usual
G=squeeze(imagen(:,:,2));%Imagen verde
B=squeeze(imagen(:,:,3));%Imagen azul
sumaR=sumaR+R;
sumaG=sumaG+G;
sumaB=sumaB+B;
end

imwrite(uint8(sumaR/NI-2),'/media/B/Doctorado/Fotos Autocolimador/Diagonal apunta escritorio 4/pos 1/impruebaretR.png')
imwrite(uint8(SumaTotal/NI-2),'/media/B/Doctorado/Fotos Autocolimador/Diagonal apunta escritorio 4/pos 1/impruebaret.png')
%imp=uint8(SumaTotal/NI-2);

%imshow(imp)
pause


promR=sumaR/(NI-2);% Imagen Roja promedio
promG=sumaG/(NI-2);% Imagen verde promedio
promB=sumaB/(NI-2);% Imagen azul promedio
xx=1:640;
plot (xx,squeeze(promR(275,:)),xx,squeeze(promG(275,:)),xx,squeeze(promB(275,:)))

pause

%Mascara de NP de lado, centrada en PcY,PcX 
for i=1:NP
    for j=1:NP
promRM(i,j)=promR(PcY-(NP/2+1)+i,PcX-(NP/2+1)+j);
promGM(i,j)=promG(PcY-(NP/2+1)+i,PcX-(NP/2+1)+j); 
promBM(i,j)=promB(PcY-(NP/2+1)+i,PcX-(NP/2+1)+j); 
    end
end


%save(['/media/B/Doctorado/Fotos Autocolimador/Diagonal apunta escritorio 4/pos 1/Imagen-promedioR' '.dat'],'promRM','-ascii');
%save(['/media/B/Doctorado/Fotos Autocolimador/Diagonal apunta escritorio 4/pos 1/Imagen-promedioR' '.dat'],'promRM','-ascii');
%save(['/media/B/Doctorado/Fotos Autocolimador/Diagonal apunta escritorio 4/pos 1/Imagen-promedioG' '.dat'],'promGM','-ascii');
%save(['/media/B/Doctorado/Fotos Autocolimador/Diagonal apunta escritorio 4/pos 1/Imagen-promedioB' '.dat'],'promBM','-ascii');
  




