function  [PHf, PVf] = measurement3(Ip) 
    
   n = 100;      
   PH = 1:n;
   PV = 1:n;
   
   [bvu, bhu] = centercruz_function2(Ip);
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%% LINEA HORIZONTAL DE LA CRUZ%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


    x = 1:50;           
    if (541 < bvu) && (bvu < 1082)         
 
        xminh = bvu + 30;
        yminh = bhu - 25;
    
        I_ch = imcrop(Ip, [xminh yminh 99 49]);%[xmin ymin width height]%
        
        %figure; imshow(Isf_c, [])    
        for j = 1:n
            cv = squeeze(I_ch(:, j));
            %[fith, gofh] =  Fit_un_paso_Gauss_CRUZ_H(x', cv);
            [fith] =  fitH(x', cv);
 
            ch = coeffvalues(fith);            
 
            PH(j) = ch(2); %Posición horizontal de la gaussiana para cada corte           
        end

        %Valor en píxles de la guiñada
        PHf = mean(PH) + yminh - 1;                
       
    elseif (0 < bvu) && (bvu < 541)      
    
        xminh = bvu + 150;
        yminh = bhu - 25;
    
        I_ch = imcrop(Ip, [xminh yminh 99 49]);%[xmin ymin width height]%
        %figure; imshow(Isf_c, [])    
        for j = 1:n
            cv = squeeze(I_ch(:, j));
            %[fith, gofh] =  Fit_un_paso_Gauss_CRUZ_H(x', cv);
            [fith] =  fitH(x', cv);
 
            ch = coeffvalues(fith);            
 
            PH(j) = ch(2); %Posición horizontal de la gaussiana para cada corte           
        end

        %Valor en píxles de la guiñada
        PHf = mean(PH) + yminh - 1;        
    
    else         
    
        xminh = bvu - 450;
        yminh = bhu - 25;
    
        I_ch = imcrop(Ip, [xminh yminh 99 49]);%[xmin ymin width height]%
        %figure; imshow(Isf_c, [])    
        for j = 1:n
            cv = squeeze(I_ch(:, j));
            %[fith, gofh] =  Fit_un_paso_Gauss_CRUZ_H(x', cv);
            [fith] =  fitH(x', cv);
 
            ch = coeffvalues(fith);            
 
            PH(j) = ch(2); %Posición horizontal de la gaussiana para cada corte           
        end

        %Valor en píxles de la guiñada
        PHf = mean(PH) + yminh - 1;
    end
       
       

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%% LINEA VERTICAL DE LA CRUZ%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
 

    if (0 < bhu) && (bhu < 411)   
        xminv = bvu - 25;
        yminv = bhu + 150;
        I_cv = imcrop(Ip, [xminv yminv 49 99]);%[xmin ymin width height]% 
        %figure; imshow(I_cv, [])
    

        for j = 1:n
            cv2 = squeeze(I_cv(j, :))'; 
            %[fitv, gofv] =  Fit_un_paso_Gauss_CRUZ_V(y', cv2);
            [fitv] =  fitV(x', cv2);
            
            cV2 = coeffvalues(fitv);          
        
            PV(j) = cV2(2);%Posición vertical de la gaussiana para cada corte                   
        end
        
        %Valor en píxeles del cabeceo
        PVf = mean(PV) + xminv - 1;      
    
    elseif (411 < bhu) && (bhu < 822)  
        xminv = bvu - 25;
        yminv = bhu + 30;
        I_cv = imcrop(Ip, [xminv yminv 49 99]);%[xmin ymin width height]% 
        %figure; imshow(I_cv, [])
        
        for j = 1:n
            cv2 = squeeze(I_cv(j, :))'; 
            %[fitv, gofv] =  Fit_un_paso_Gauss_CRUZ_V(y', cv2);
            [fitv] =  fitV(x', cv2);
 
            cV2 = coeffvalues(fitv);            
        
            PV(j) = cV2(2);%Posición vertical de la gaussiana para cada corte                   
        end
        
        %Valor en píxeles del cabeceo
        PVf = mean(PV) + xminv - 1;        
    
    else   
        xminv = bvu - 25;
        yminv = bhu - 450;
        I_cv = imcrop(Ip, [xminv yminv 49 99]);%[xmin ymin width height]% 
        %figure; imshow(I_cv, [])    

        for j = 1:n
            cv2 = squeeze(I_cv(j, :))'; 
            %[fitv, gofv] =  Fit_un_paso_Gauss_CRUZ_V(y', cv2);
            [fitv] =  fitV(x', cv2);
 
            cV2 = coeffvalues(fitv);           
        
            PV(j) = cV2(2);%Posición vertical de la gaussiana para cada corte                   
        end
        
        %Valor en píxeles del cabeceo
        PVf = mean(PV) + xminv - 1;
    end
    
 