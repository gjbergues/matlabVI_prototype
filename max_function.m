function  [pos_max]=max_function(k,h)

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
    
    
    acbh = 0;
    for j = 1:30
       cv = squeeze(Ip(:,bvu-(2*j)));
        
 
        [M,In] = max(cv);%M= valor, I=índices.
       
        bh(j) = In; %valor central detectado de la gaussiana para cada corte
        
        acbh = acbh + bh(j);%acumulador de valores centrales para cada corte de la imagen
        
    end
      
      pos_max= acbh/30;  %valor central único para cada imagen 
      

end

