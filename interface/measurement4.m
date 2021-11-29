function  [PHf, PVf] = measurement4(Ip) 
    
   n = 10;      
   PH = 1:n;
   PV = 1:n;
   
   [bvu, bhu] = centercruz_function2(Ip)
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%% LINEA HORIZONTAL DE LA CRUZ%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    
    x = 1:50;           
    if (541 < bvu) && (bvu < 1082)         
 
        %xminh = bvu + 30;
        xminh = bvu + 15;
        yminh = bhu - 25;
    
        I_ch = imcrop(Ip, [xminh yminh n-1 49]);%[xmin ymin width height]%
                
        %figure; imshow(I_ch, []);
        i = 0;
        for j = 1:n            
            cv = squeeze(I_ch(:, j));
            %[fith, gofh] =  Fit_un_paso_Gauss_CRUZ_H(x', cv);
            [fith] =  fitH(x', cv);
 
            ch = coeffvalues(fith);            
 
            PH(j) = ch(2); %Posición horizontal de la gaussiana para cada corte             
        end                
       
    elseif (0 < bvu) && (bvu < 541)      
    
        xminh = bvu + 150;
        yminh = bhu - 25;
    
        I_ch = imcrop(Ip, [xminh yminh n-1 49]);%[xmin ymin width height]%
        %figure; imshow(Isf_c, [])    
        for j = 1:n
            cv = squeeze(I_ch(:, j));
            %[fith, gofh] =  Fit_un_paso_Gauss_CRUZ_H(x', cv);
            [fith] =  fitH(x', cv);
 
            ch = coeffvalues(fith);            
 
            PH(j) = ch(2); %Posición horizontal de la gaussiana para cada corte           
        end         
    
    else         
    
        xminh = bvu - 450;
        yminh = bhu - 25;
    
        I_ch = imcrop(Ip, [xminh yminh n-1 49]);%[xmin ymin width height]%
        %figure; imshow(Isf_c, [])    
        for j = 1:n
            cv = squeeze(I_ch(:, j));
            %[fith, gofh] =  Fit_un_paso_Gauss_CRUZ_H(x', cv);
            [fith] =  fitH(x', cv);
 
            ch = coeffvalues(fith);            
 
            PH(j) = ch(2); %Posición horizontal de la gaussiana para cada corte           
        end        
    end
    %PHf = mean(PH) + yminh - 0.5; 
    %Valor en píxles de la guiñada 
    [~, Inv] = max(PH);
    PH(Inv)=PH(Inv-1);
    [~, in] = min(PH);
    PH(in)=PH(in+1);
    PHf = median(PH) + yminh - 0.9;    

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%% LINEA VERTICAL DE LA CRUZ%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
 

    if (0 < bhu) && (bhu < 411)   
        xminv = bvu - 25;
        yminv = bhu + 150;
        I_cv = imcrop(Ip, [xminv yminv 49 n-1]);%[xmin ymin width height]% 
        %figure; imshow(I_cv, [])
    

        for j = 1:n
            cv2 = squeeze(I_cv(j, :))'; 
            %[fitv, gofv] =  Fit_un_paso_Gauss_CRUZ_V(y', cv2);
            [fitv] =  fitV(x', cv2);
            
            cV2 = coeffvalues(fitv);          
        
            PV(j) = cV2(2);%Posición vertical de la gaussiana para cada corte                   
        end     
    
    elseif (411 < bhu) && (bhu < 822)  
        xminv = bvu - 25;
        yminv = bhu + 30;
        I_cv = imcrop(Ip, [xminv yminv 49 n-1]);%[xmin ymin width height]% 
        %figure; imshow(I_cv, [])
        
        for j = 1:n
            cv2 = squeeze(I_cv(j, :))'; 
            %[fitv, gofv] =  Fit_un_paso_Gauss_CRUZ_V(y', cv2);
            [fitv] =  fitV(x', cv2);
 
            cV2 = coeffvalues(fitv);            
        
            PV(j) = cV2(2);%Posición vertical de la gaussiana para cada corte                   
        end
        
        %Valor en píxeles del cabeceo         
    
    else   
        xminv = bvu - 25;
        yminv = bhu - 450;
        I_cv = imcrop(Ip, [xminv yminv 49 n-1]);%[xmin ymin width height]% 
        %figure; imshow(I_cv, [])    

        for j = 1:n
            cv2 = squeeze(I_cv(j, :))'; 
            %[fitv, gofv] =  Fit_un_paso_Gauss_CRUZ_V(y', cv2);
            [fitv] =  fitV(x', cv2);
 
            cV2 = coeffvalues(fitv);           
        
            PV(j) = cV2(2);%Posición vertical de la gaussiana para cada corte                   
        end
        
        %Valor en píxeles del cabeceo
        
    end
    %Valor en píxeles del cabeceo
    %[~, Inv] = max(PV);
    %PV(Inv)=PV(Inv+1);
    [~, in] = min(PV);
    PV(in)=PV(in-1);
    PVf = median(PV) + xminv - 0.9;
 