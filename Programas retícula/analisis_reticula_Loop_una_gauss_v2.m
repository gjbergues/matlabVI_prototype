clear all
close all

NI=100;%Número de imagenes a ser promediadas. Etiquetadas consecutivamente
sum_I=0;
SumaTotal=0;

%Carga de la imagenes y promedio aritmético para cada color

for i=1:NI


f=['I:\datos_paper_pattern\Exp 2\ret\ima' num2str(i) '.bmp'];

%bmp ingresa color por canal? o mezcla colores?

rgb_img=imread(f);

I = .2989*rgb_img(:,:,1)+.5870*rgb_img(:,:,2) +.1140*rgb_img(:,:,3);

sum_I=sum_I+(double(I)+1);

end

I_new=sum_I/(NI);
I_new_neg=1-(I_new./255);

yy=1:40;
xx=1:750;
II=I_new_neg(640+yy,440+xx);
[fitresult, gof] = Fit_fondo_H(xx, yy, II);
[t1,t2] = meshgrid( xx,yy);
promfit = fitresult( t1, t2);
J2=abs(promfit-II);


for j=1:40
cv2=squeeze(J2(j,:));
[fit3, gof3] =  Fit_un_paso_Gauss_H(xx, cv2);

cH2=coeffvalues(fit3);
cih = confint(fit3,0.95);

BHH(j)=cH2(10);
IH(j)=(cih(2,10)-cih(1,10))/2;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% curva vertical 

yy=1:750;
xx=1:40;
III=I_new_neg(303+yy,690+xx);

[fitresult2, gof2] = Fit_fondo_V(xx, yy, III);
  [t1,t2] = meshgrid( xx,yy);
promfit2 = fitresult2( t1, t2);
J=abs(promfit2-III);

for j=1:40
cv2=squeeze(J(:,j))';

[fit4, gof4] =  Fit_un_paso_Gauss_H(yy, cv2);

cV2=coeffvalues(fit4);
ciV = confint(fit4,0.95);

IV(j)=(ciV(2,10)-ciV(1,10))/2;
BVV(j)=cV2(10);

end

 lab{1}='horizontal values' ;lab{2}= 'vertical values';figure;boxplot([BHH', BVV'],lab)
figure;boxplot([IH', IV'],lab)


