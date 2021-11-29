function  [PHf, PVf] = measurement5(vid) 
    
   n = 10;      
   PH = 1:n;
   PV = 1:n;
   
   frame = getsnapshot(vid);    
   Ip = double(.2989*frame(:,:,1) + .5870*frame(:,:,2) + .1140*frame(:,:,3));
   
   [bvu, bhu] = centercruz_function2(Ip);
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%% LINEA HORIZONTAL DE LA CRUZ%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    
    x = 1:50;           
    if (541 < bvu) && (bvu < 1082)  
        
        xminh = bvu + 15;
        yminh = bhu - 25;
    
        I_ch = imcrop(Ip, [xminh yminh n-1 49]);%[xmin ymin width height]%
                
        %figure; imshow(I_ch, []);
        i = 0;
        for j = 1:n            
            cv = squeeze(I_ch(:, j));            
            [fith] =  fitH(x', cv);
 
            ch = coeffvalues(fith);            
 
            PH(j) = ch(2); %Posici�n horizontal de la gaussiana para cada corte             
        end                
       
    elseif (0 < bvu) && (bvu < 541)      
    
        xminh = bvu + 150;
        yminh = bhu - 25;
    
        I_ch = imcrop(Ip, [xminh yminh n-1 49]);%[xmin ymin width height]%
         
        for j = 1:n
            cv = squeeze(I_ch(:, j));            
            [fith] =  fitH(x', cv);
 
            ch = coeffvalues(fith);            
 
            PH(j) = ch(2); %Posici�n horizontal de la gaussiana para cada corte           
        end         
    
    else         
    
        xminh = bvu - 450;
        yminh = bhu - 25;
    
        I_ch = imcrop(Ip, [xminh yminh n-1 49]);%[xmin ymin width height]%
            
        for j = 1:n
            cv = squeeze(I_ch(:, j));            
            [fith] =  fitH(x', cv);
 
            ch = coeffvalues(fith);            
 
            PH(j) = ch(2); %Posici�n horizontal de la gaussiana para cada corte           
        end        
    end
     
    %Valor en p�xles de la gui�ada 
    [~, Inv] = max(PH);
    if (Inv-1) ~= 0
        PH(Inv)=PH(Inv-1);
    else
        PH(Inv)=PH(Inv+1);
    end
    
    [~, in] = min(PH);
    if (in+1) < 9
        PH(in) = PH(in+1);    
    end
    coe = polyfit(1:10, PH, 1); 
    %PHf = median(PH) + yminh - 0.9;    
    PHf = coe(2) + yminh - 0.9;
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
            [fitv] =  fitV(x', cv2);
            
            cV2 = coeffvalues(fitv);          
        
            PV(j) = cV2(2);%Posici�n vertical de la gaussiana para cada corte                   
        end     
    
    elseif (411 < bhu) && (bhu < 822)  
        xminv = bvu - 25;
        yminv = bhu + 30;
        I_cv = imcrop(Ip, [xminv yminv 49 n-1]);%[xmin ymin width height]% 
               
        for j = 1:n
            cv2 = squeeze(I_cv(j, :))';             
            [fitv] =  fitV(x', cv2);
 
            cV2 = coeffvalues(fitv);            
        
            PV(j) = cV2(2);%Posici�n vertical de la gaussiana para cada corte                   
        end             
    
    else   
        xminv = bvu - 25;
        yminv = bhu - 450;
        I_cv = imcrop(Ip, [xminv yminv 49 n-1]);%[xmin ymin width height]%             

        for j = 1:n
            cv2 = squeeze(I_cv(j, :))';             
            [fitv] =  fitV(x', cv2);
 
            cV2 = coeffvalues(fitv);           
        
            PV(j) = cV2(2);%Posici�n vertical de la gaussiana para cada corte                   
        end        
               
    end
    %Valor en p�xeles del cabeceo
%     mdl = LinearModel.fit(1:10, PV) 
%     figure; plot(mdl)    
    [~, Inv] = min(PV);
    if (Inv-1) ~= 0
        PV(Inv)=PV(Inv-1);
    else
        PV(Inv)=PV(Inv+1);
    end
    [~, in] = max(PV);
    if (in+1) < 9
        PV(Inv)=PV(in+1);    
    end
    coefs = polyfit(1:10, PV, 1);    
    %PVf = median(PV) + xminv - 0.9;
    PVf = coefs(2) + xminv - 0.9;