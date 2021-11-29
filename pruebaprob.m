clear all

    Ny = 1:1234; %rows


            f=['I:\EXP4\ahorario\p0\ima1.bmp'];
          
 
        rgb_img = imread(f);
 
    	Ip = .2989*rgb_img(:,:,1)+.5870*rgb_img(:,:,2) +.1140*rgb_img(:,:,3);
 
       
     
    [bvu, bhu]=centercruz_function2(Ip); %cross center and image without background
    
           y = 1:200;
	x = 1:200;
    
     xminh= bvu-230;
    yminh = bhu-100;
      
      acbh=0;         
      for j = 1:200
          
 
        Isf_c = double( imcrop(Ip,[xminh yminh 199 199]) );%[xmin ymin width height]%   
          
        cv = double(squeeze(Isf_c(:,j)));
        
        y(j) = (x*cv)/sum(cv);             
         
        acbh = acbh + y(j) +yminh;%acumulador de valores centrales para cada corte de la imagen
       
      end
      
      pos_prob = acbh/200;  %valor central único para cada imagen 