function  [PHf, PVf] = measurement2(Is) 
    
   NI = 5;
   n = 40;
      
   
   Ip = Is/(NI);%Imagen promediada
   
   [bvu, bhu] = centercruz_function(Ip)
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%% LINEA HORIZONTAL DE LA CRUZ%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


    i=0;
    x = 1:1234;            
    if (541 < bvu) && (bvu < 1082) 
        xminh = bvu - 230;
        yminh = 1;
    
        I_ch = imcrop(Ip, [xminh yminh 199 1233]);%[xmin ymin width height]%
        
        %figure; imshow(I_ch, [])    
        for j = 1:n
            i = i+4;
            cv = squeeze(I_ch(:, j+i));
            [fith, gofh] =  Fit_un_paso_Gauss_CRUZ_H2(x', cv);
 
            ch = coeffvalues(fith);
            cih = confint(fith, 0.95);
 
            PH(j) = ch(2); %Posición horizontal de la gaussiana para cada corte
            IH(j) = (cih(2,2) - cih(1,2))/2; %incertidumbre para cada corte
            
        end
        
        
        xminh2 = bvu + 30;
        yminh2 = 1;
    
        I_ch2 = imcrop(Ip, [xminh2 yminh2 199 1233]);%[xmin ymin width height]%
        %figure; imshow(I_ch2, []) 
        i=0;
        for j = 1:n
            i = i+4;
            cv2 = squeeze(I_ch2(:, j+i));
            [fith2, gofh2] =  Fit_un_paso_Gauss_CRUZ_H2(x', cv2);
 
            ch2 = coeffvalues(fith2);
            cih2 = confint(fith2, 0.95);
 
            PH2(j) = ch2(2); %Posición horizontal de la gaussiana para cada corte      
        end
    
    PHf = (median(PH) + median(PH2))/2;    
    
       
    
    elseif (0 < bvu) && (bvu < 541)      
    
        xminh = bvu + 50;
        yminh = 1;
    
        I_ch = imcrop(Ip, [xminh yminh 399 1233]);%[xmin ymin width height]%
        %figure; imshow(Isf_c, []) 
        i = 0;
        for j = 1:(n*2)
            i = i+4;
            cv = squeeze(I_ch(:, j+i));
            [fith, gofh] =  Fit_un_paso_Gauss_CRUZ_H2(x', cv);
 
            ch = coeffvalues(fith);
            cih = confint(fith, 0.95);
 
            PH(j) = ch(2); %Posición horizontal de la gaussiana para cada corte
            IH(j) = (cih(2,2) - cih(1,2))/2; %incertidumbre para cada corte
                
        end
    PHf = median(PH);   
    
    
    
    else         
    
        xminh = bvu - 230;
        yminh = 1;
    
        I_ch = imcrop(Ip, [xminh yminh 399 1233]);%[xmin ymin width height]%
        %figure; imshow(Isf_c, []) 
        i = 0;
        for j = 1:(n*2)
            i = i+4;
            cv = squeeze(I_ch(:, j+i));
            [fith, gofh] =  Fit_un_paso_Gauss_CRUZ_H2(x', cv);
 
            ch = coeffvalues(fith);
            cih = confint(fith, 0.95);
 
            PH(j) = ch(2); %Posición horizontal de la gaussiana para cada corte
            IH(j) = (cih(2,2) - cih(1,2))/2; %incertidumbre para cada corte
        end
    PHf = median(PH);
    end
       
    
   
       

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%% LINEA VERTICAL DE LA CRUZ%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
    y = 1:200;
    xminv = bvu - 100;
    yminv = bhu + 30;
    I_cv = imcrop(Ip, [xminv yminv 199 199]);%[xmin ymin width height]% 
    %figure; imshow(I_cv, [])
    

    for j = 1:n
        cv2 = squeeze(I_cv(j, :))'; 
        [fitv, gofv] =  Fit_un_paso_Gauss_CRUZ_V(y', cv2);
 
        cV2 = coeffvalues(fitv);
        ciV = confint(fitv, 0.95);
        
        PV(j) = cV2(2);%Posición vertical de la gaussiana para cada corte
        IV(j) = (ciV(2,2) - ciV(1,2))/2;
        
    end
    %Valor en píxeles del cabeceo
    PVf = sum(PV)/n + xminv;


% c = 100;
%     y = 1:1624;
%     if (0 < bhu) && (bhu < 411)   
%         xminv = 1;
%         yminv = bhu + 30;
%         I_cv = imcrop(Ip, [xminv yminv 1623 c]);%[xmin ymin width height]% 
%         
%         figure; imshow(I_cv, [])
%         
%         for j = 1:c
%             cv2 = squeeze(I_cv(j, :))'; 
%             [fitv, gofv] =  Fit_un_paso_Gauss_CRUZ_V2(y', cv2);
%  
%             cV2 = coeffvalues(fitv);
%             ciV = confint(fitv, 0.95);
%         
%             PV(j) = cV2(2);%Posición vertical de la gaussiana para cada corte
%             IV(j) = (ciV(2,2) - ciV(1,2))/2;
%         
%         end
%     Valor en píxeles del cabeceo
%     PVf = median(PV);
%       
%     
%     elseif (411 < bhu) && (bhu < 822)  
%         xminv = 1;
%         yminv = bhu + 30;
%         I_cv = imcrop(Ip, [xminv yminv 1623 c]);%[xmin ymin width height]% 
%         save('june','I_cv')
%         figure; imshow(I_cv, [])
%     
%         
%         for j = 1:c
%             
%             cv2 = squeeze(I_cv(j, :))'; 
%             [fitv, gofv] =  Fit_un_paso_Gauss_CRUZ_V2(y', cv2);
%  
%             cV2 = coeffvalues(fitv);
%             ciV = confint(fitv, 0.95);
%         
%             PV(j) = cV2(2);%Posición vertical de la gaussiana para cada corte
%             IV(j) = (ciV(2,2) - ciV(1,2))/2;
%         
%         end
%         
%         xminv2 = 1;
%         yminv2 = bhu - 230;
%         I_cv2 = imcrop(Ip, [xminv2 yminv2 1623 c]);%[xmin ymin width height]% 
%         figure; imshow(I_cv2, [])
%     
%         for j = 1:c
%             
%             cv3 = squeeze(I_cv2(j, :))'; 
%             [fitv3, gofv3] =  Fit_un_paso_Gauss_CRUZ_V2(y', cv3);
%  
%             cV3 = coeffvalues(fitv3);
%             ciV3 = confint(fitv3, 0.95);
%         
%             PV3(j) = cV3(2);%Posición vertical de la gaussiana para cada corte
%             IV3(j) = (ciV3(2,2) - ciV3(1,2))/2;
%         
%         end
%     Valor en píxeles del cabeceo
%     PVf = (median(PV) + median(PV3))/2;
%         
%     
%     else   
%         xminv = 1;
%         yminv = bhu - 430;
%         I_cv = imcrop(Ip, [xminv yminv 1623 c]);%[xmin ymin width height]% 
%     figure; imshow(I_cv, [])
%     
%         
%         for j = 1:c
%             cv2 = squeeze(I_cv(j+i, :))'; 
%             [fitv, gofv] =  Fit_un_paso_Gauss_CRUZ_V2(y', cv2);
%  
%             cV2 = coeffvalues(fitv);
%             ciV = confint(fitv, 0.95);
%         
%             PV(j) = cV2(2);%Posición vertical de la gaussiana para cada corte
%             IV(j) = (ciV(2,2) - ciV(1,2))/2;
%         
%         end
%     Valor en píxeles del cabeceo
%     PVf = median(PV);
    end
    
 