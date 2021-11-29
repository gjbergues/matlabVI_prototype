function  [pos_regres]=reg_function(w,h)

    Ny = 1:1234; %rows
    ey = 1:21;
    ex = 1:100;

    x = zeros(2000, 1);
    y = zeros(2000, 1);
    k=1;


    NI = 20; %Number of images to be average
	sum_I = 0;
	SumaTotal = 0;
   	
    d = 51-w; %When is in clockwise, I beggin from file 50
    
	for i=1:NI
      
        if h==1 %antihorio=1;
            f=['I:\EXP4\ahorario\p' num2str(w-1) '\ima' num2str(i) '.bmp'];
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
    
    xminh= bvu-130;
    yminh = bhu-50;
      
     J = double( imcrop(Ip,[xminh yminh 99 99]) );%[xmin ymin width height]%   
          


for i = 1:100
    
    for j = 1:99
       x(k) = i; 
       y(k) = j;
       k = k + 1;
    end
    y(k) = j+1;
    x(k) = i;
    k= k + 1;
             
end


                  
      %Vector W of Weights
      s = sum(y);
      P = J/s;
      W = P(:);

      a = ((sum(W .* x .* y) * sum(W)) - (sum(W .* y) * sum(W .* x) )) /((sum(W .* x.^2) * sum(W)) - (sum(W.*x))^2);
 
      b = ((sum(W .* x.^2) * sum(W .* y)) - ( sum(W .* x) * sum(W .* x .* y))) / ((sum(W.*x.^2)*sum(W)) - (sum(W.*x))^2);
      
      
      %Center detection for each position
      pos_regres = b + yminh;
      



end
