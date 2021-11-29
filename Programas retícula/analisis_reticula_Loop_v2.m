%Este programa agrega al análisis de la retícula un bucle for que recorre
%todas los posibles cortes de gaussianas

clear all
close all

NI=20;%Número de imagenes a ser promediadas. Etiquetadas consecutivamente
sum_I=0;

%Carga de la imagenes y promedio aritmético para cada color

for i=1:NI
    file=['F:\Fotos autocolimador\EXP4\retícula\ima' num2str(i) '.bmp'];
    rgb_img=imread(file);
    I = .2989*rgb_img(:,:,1)+.5870*rgb_img(:,:,2) +.1140*rgb_img(:,:,3);
    sum_I=sum_I+(double(I)+1);
end

I=sum_I/(NI);
%I_new_neg=1-(I_new./255);

[indC, indF, Isf]=scale_center(I); 

yy=1:40;
xx=1:750;
II=I_new_neg(640+yy,440+xx);
[fitresult, gof] = Fit_fondo_H(xx, yy, II);
[t1,t2] = meshgrid( xx,yy);
promfit = fitresult( t1, t2);
J=abs(promfit-II);

for j=1:40
    cv2=squeeze(J(j,:));
    [fit2, gof2] = Fit_8gauss_H(xx, cv2);
    cH=coeffvalues(fit2);
    bH=reshape(cH,3,8);
    b_fH=sort(bH(2,:));
    X=[ones(1,8)' (1:8)'];
    BH=b_fH';
    [bh,bint,r,rint] =regress(BH,X);
    BHH(j)=bh(2);
    IH(j)=(bint(2,2)-bint(2,1))/2;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CURVA vertical 

yy=1:750;
xx=1:40;
III=I_new_neg(303+yy,690+xx);

[fitresult2, gof2] = Fit_fondo_V(xx, yy, III);
[t1,t2] = meshgrid( xx,yy);
promfit2 = fitresult2( t1, t2);
J=abs(promfit2-III);

for j=1:40
    cv2=squeeze(J(:,j))';
    [fitv, gofv] = Fit_8gauss_V(yy, cv2);
    cV=coeffvalues(fitv);
    bV=reshape(cV,3,8);
    b_fV=sort(bV(2,:));
    X=[ones(1,8)' (1:8)'];
    BV=b_fV';
    [bv,bintv,rv,rintv] =regress(BV,X);
    IV(j)=(bintv(2,2)-bintv(2,1))/2;
    BVV(j)=bv(2);
end

figure;boxplot(BHH)
figure;boxplot(IH)
figure;boxplot(BVV)
figure;boxplot(IV)

