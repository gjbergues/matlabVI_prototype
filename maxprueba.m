clear all


       
        f=['I:\EXP4\ahorario\p0\ima1.bmp'];
           
        
        rgb_img = imread(f);
 
    	I = .2989*rgb_img(:,:,1)+.5870*rgb_img(:,:,2) +.1140*rgb_img(:,:,3);
 
       
 
	Ip = I;% Averaged image
	    
    [bvu, bhu]=centercruz_function2(Ip); %cross center and image without background
    
    
    acbh = 0;
    for j = 1:30
        cv = squeeze(Ip(:,bvu-(2*j)));
        
 
        [M,In] = max(cv);%M= valor, I=índices.
       
        bh(j) = In; %valor central detectado de la gaussiana para cada corte
        
        acbh = acbh + bh(j);%acumulador de valores centrales para cada corte de la imagen
        
    end
      
      pos_max= acbh/30;  %valor central único para cada imagen 
      



