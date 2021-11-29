function  [pos_prob]=prob_function(k,h)

    Ny = 1:1234; %rows

 NI = 20; %Number of images to be average
	sum_I = 0;
	SumaTotal = 0;
   	
    d = 51-k; %When is in clockwise, I beggin from file 50
    
	for i=1:NI
      
        if h==1 %antihorio=1;
            f=['I:\EXP4\ahorario\p' num2str(k-1) '\ima' num2str(i) '.bmp'];
            %f=['F:\Fotos autocolimador\EXP9\antihorario\p' num2str(k-1) '\ima' num2str(i) '.bmp'];
            %f=['J:\DATOS\TECNOLOGICA\datos_paper_pattern\Exp 2\ahorario\p' num2str(k-1) '\ima' num2str(i) '.bmp'];
        end
        
        if h==0 %horario=0;
            f=['I:\EXP4\horario\p' num2str(d) '\ima' num2str(i) '.bmp'];
            %f=['J:\DATOS\TECNOLOGICA\datos_paper_pattern\Exp 2\horario\p' num2str(d) '\ima' num2str(i) '.bmp'];
        end
        
        %Gray image creation
 
        rgb_img = imread(f);
 
    	I = .2989*rgb_img(:,:,1)+.5870*rgb_img(:,:,2) +.1140*rgb_img(:,:,3);
 
        sum_I = sum_I+(double(I)+1);
 
	end
 
	Ip = sum_I/(NI);% Averaged image
	%Ipneg = 1-(Ip./255);% denied image
    
    [bvu, bhu]=centercruz_function2(Ip); %cross center and image without background
    
    y = 1:200;
	x = 1:200;
    
    xminh= bvu-230;
    yminh = bhu-100;
    
    Isf_c = double( imcrop(Ip,[xminh yminh 199 199]) );
    
      acbh=0;         
      for j = 1:200
        
        cv = double(squeeze(Isf_c(:,j)));
        
        y(j) = (x*cv)/sum(cv);             
         
        acbh = acbh + y(j) + yminh;%acumulador de valores centrales para cada corte de la imagen
       
      end
      
      pos_prob = acbh/200;  %valor central único para cada imagen 
      


end
