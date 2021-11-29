clear all

a='caseorder';	
b='fitted'	;
c='histogram'	;
d='lagged'	;
e='probability';
f='symmetry';

ang = xlsread('nivel_gaussymax.xlsx','B15:B39');
dif_M = xlsread('nivel_gaussymax.xlsx','G15:G39');
dif_H = xlsread('nivel.xlsx','G15:G39');
dif_R = xlsread('nivel_gaussyregres.xlsx','G15:G39');
dif_P = xlsread('nivel_gaussyprob.xlsx','G15:G39');
dif_G = xlsread('nivel_gaussymax.xlsx','d15:d39');
dif_rgb = xlsread('nivel_gaussyrgb.xlsx','G15:G39');



% %%%%%%%%%HOUGH%%%%%%%%%%%%%%%%
mdl_h = LinearModel.fit(-ang, dif_H); 
% figure; plot(mdl_h)
% title('D_k vs X_k (Hough)');
% xlabel('Measure Angle (sec of arc)');
% ylabel('Discrepancies (sec of arc)');
%     
    
res_H = mdl_h.Residuals.Raw
figure; plot(ang, res_H, '*r');  

title('D_k vs X_k (Hough)');
xlabel('Measure Angle (sec of arc)');
ylabel('Discrepancies (sec of arc)');

h_H = plotResiduals(mdl_h, b);
ecm_H = sqrt(sum(res_H.^2)/25);
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% %%%%%%%%%GAUSS%%%%%%%%%%%%%%%%
mdl_g = LinearModel.fit(-ang, dif_G); 
% figure; plot(mdl_g)
% title('D_k vs X_k (Gauss)');
% xlabel('Measure Angle (sec of arc)');
% ylabel('Discrepancies (sec of arc)');
    
    
res_G = mdl_g.Residuals.Raw
figure; plot(ang, res_G, '*b');

title('D_k vs X_k (Gauss)');
xlabel('Measure Angle (sec of arc)');
ylabel('Discrepancies (sec of arc)');

h_G = plotResiduals(mdl_g, b);
ecm_G = sqrt(sum(res_G.^2)/25);
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%REGRES%%%%%%%%%%%%%%%%
mdl_R = LinearModel.fit(-ang, dif_R); 
% figure; plot(mdl_M)
% title('D_k vs X_k (MAX)');
% xlabel('Measure Angle (sec of arc)');
% ylabel('Discrepancies (sec of arc)');
    
    
res_R = mdl_R.Residuals.Raw
figure; plot(ang, res_R, '*r');  

title('D_k vs X_k (Max)');
xlabel('Measure Angle (sec of arc)');
ylabel('Discrepancies (sec of arc)');


h_R = plotResiduals(mdl_R, b);
ecm_R = sqrt(sum(res_R.^2)/25);


%%%%%%%%%MAX%%%%%%%%%%%%%%%%
mdl_M = LinearModel.fit(-ang, dif_M); 
% figure; plot(mdl_M)
% title('D_k vs X_k (MAX)');
% xlabel('Measure Angle (sec of arc)');
% ylabel('Discrepancies (sec of arc)');
    
    
res_M = mdl_M.Residuals.Raw
figure; plot(ang, res_M, '*r');  

title('D_k vs X_k (Max)');
xlabel('Measure Angle (sec of arc)');
ylabel('Discrepancies (sec of arc)');


h_M = plotResiduals(mdl_M, b);
ecm_M = sqrt(sum(res_M.^2)/25);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%PROB%%%%%%%%%%%%%%%%
mdl_P = LinearModel.fit(-ang, dif_P); 
% figure; plot(mdl_M)
% title('D_k vs X_k (MAX)');
% xlabel('Measure Angle (sec of arc)');
% ylabel('Discrepancies (sec of arc)');
    
    
res_P = mdl_P.Residuals.Raw
figure; plot(ang, res_P, '*r');  

title('D_k vs X_k (Max)');
xlabel('Measure Angle (sec of arc)');
ylabel('Discrepancies (sec of arc)');


h_P = plotResiduals(mdl_P, b);
ecm_P = sqrt(sum(res_P.^2)/25);

%Method comparison.

res_M = mdl_M.Residuals.Raw
figure; plot(ang, res_M, '*r'); hold on 
plot(ang, res_R, '*y'); hold on 
plot(ang, res_P, '*b');  

legend('Max','WLS','Prob')
title('Method comparion');
xlabel('Measure Angle (sec of arc)');
ylabel('Discrepancies (sec of arc)');



%%METHOD COMPARISON (LINE)

% res_f= res_G - res_H;
% figure; plot(ang, res_f, '*r');

% val_H = xlsread('nivel.xlsx','G3:G53');
% val_G = xlsread('nivel.xlsx','D3:D53');
% 
% mdl_hg = LinearModel.fit(val_G, val_H); 
% figure; plot(mdl_hg)
% title('Method comparison');
% xlabel('Detector Gaussiano');
% ylabel('Detector Hough');
% 
% val_H = xlsread('nivel.xlsx','G25:G30');
% val_G = xlsread('nivel.xlsx','D25:D30');
% 
% mdl_hg = LinearModel.fit(val_G, val_H); 
% figure; plot(mdl_hg)
% 
% 

val_rgb = xlsread('nivel_gaussyrgb.xlsx','G3:G53');
val_G = xlsread('nivel_gaussyrgb.xlsx','D3:D53');
 
mdl_rgb = LinearModel.fit(val_G, val_rgb); 
figure; plot(mdl_hg)
title('Method comparison');
xlabel('Niveles de gris');
ylabel('RGB');

