    n = 10;      
    PH = 1:n;
    PV = 1:n;
   
    frame = imread('1.bmp');       
    Ip = double(.2989*frame(:,:,1) + .5870*frame(:,:,2) + .1140*frame(:,:,3));
   
    [bvu, bhu] = centercruz_function2(Ip);
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%% LINEA HORIZONTAL DE LA CRUZ%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %x = 1:50; 
    x = 1:30; 
    if (541 < bvu) && (bvu < 1082) %si la cruz está en la zona central de la imagen
        
        xminh = bvu + 50;
        yminh = bhu - 15;
    
        I_ch = imcrop(Ip, [xminh yminh n-1 29]);%[xmin ymin width height]%
                
        %figure; imshow(I_ch, []);        
        for j = 1:n            
            cv = squeeze(I_ch(:, j));            
            [fith] =  fitH2(x', cv);%Función de fiteo de gaussiana vertical
 
            ch = coeffvalues(fith);            
 
            PH(j) = ch(2); %Posición horizontal de la gaussiana para cada corte             
        end                
       
    elseif (0 < bvu) && (bvu < 541)%si la cruz está en la zona izquierda de la imagen      
    
        xminh = bvu + 150;
        yminh = bhu - 15;
    
        I_ch = imcrop(Ip, [xminh yminh n-1 29]);%[xmin ymin width height]%
         
        for j = 1:n
            cv = squeeze(I_ch(:, j));            
            [fith] =  fitH2(x', cv);%Función de fiteo de gaussiana vertical
 
            ch = coeffvalues(fith);            
 
            PH(j) = ch(2); %Posición horizontal de la gaussiana para cada corte           
        end         
    
    else %si la cruz está en la zona derecha de la imagen        
    
        xminh = bvu - 450;
        yminh = bhu - 15;
    
        I_ch = imcrop(Ip, [xminh yminh n-1 29]);%[xmin ymin width height]%
            
        for j = 1:n
            cv = squeeze(I_ch(:, j));            
            [fith] =  fitH2(x', cv);
 
            ch = coeffvalues(fith);            
 
            PH(j) = ch(2); %Posición horizontal de la gaussiana para cada corte           
        end        
    end
     
    %Valor en píxles del cabeceo
%     [~, Inv] = max(PH);
%     if (Inv-1) ~= 0
%         PH(Inv) = PH(Inv-1);
%     else
%         PH(Inv) = PH(Inv+1);
%     end
%     
%     [~, in] = min(PH);
%     if (in+1) < 9
%         PH(in) = PH(in+1);    
%     end
    coe = polyfit(1:n, PH, 1); 
    %PHf = median(PH) + yminh - 0.9;    
    PHf = coe(2) + yminh - 0.9;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%% LINEA VERTICAL DE LA CRUZ%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
 

    if (0 < bhu) && (bhu < 411)   
        xminv = bvu - 15;
        yminv = bhu + 150;
        I_cv = imcrop(Ip, [xminv yminv 29 n-1]);%[xmin ymin width height]% 
        %figure; imshow(I_cv, [])    

        for j = 1:n
            cv2 = squeeze(I_cv(j, :))';            
            [fitv] =  fitV2(x', cv2);
            
            cV2 = coeffvalues(fitv);          
        
            PV(j) = cV2(2);%Posición vertical de la gaussiana para cada corte                   
        end     
    
    elseif (411 < bhu) && (bhu < 822)  
        xminv = bvu - 15;
        yminv = bhu + 50;
        I_cv = imcrop(Ip, [xminv yminv 29 n-1]);%[xmin ymin width height]% 
        %figure; imshow(I_cv, [])        
        for j = 1:n
            cv2 = squeeze(I_cv(j, :))';             
            [fitv] =  fitV2(x', cv2);
 
            cV2 = coeffvalues(fitv);            
        
            PV(j) = cV2(2);%Posición vertical de la gaussiana para cada corte                   
        end             
    
    else   
        xminv = bvu - 15;
        yminv = bhu - 450;
        I_cv = imcrop(Ip, [xminv yminv 29 n-1]);%[xmin ymin width height]%             

        for j = 1:n
            cv2 = squeeze(I_cv(j, :))';             
            [fitv] =  fitV2(x', cv2);
 
            cV2 = coeffvalues(fitv);           
        
            PV(j) = cV2(2);%Posición vertical de la gaussiana para cada corte                   
        end        
               
    end
    %Valor en píxeles de la guiñada
%     mdl = LinearModel.fit(1:30, PV) 
%     figure; plot(mdl)    
%     [~, Inv] = min(PV);
%     if (Inv-1) ~= 0
%         PV(Inv) = PV(Inv-1);
%     else
%         PV(Inv) = PV(Inv+1);
%     end
%     [~, in] = max(PV);
%     if (in+1) < 9
%         PV(Inv) = PV(in+1);    
%     end
    coefs = polyfit(1:n, PV, 1);    
    %PVf = median(PV) + xminv - 0.9;
    PVf = coefs(2) + xminv - 0.9;

    
    save('measure.mat', 'PV', 'PH', 'cv', 'cv2');   

