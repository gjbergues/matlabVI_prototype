 clear all



ey = 1:21;
ex = 1:100;

x = zeros(2000, 1);
y = zeros(2000, 1);
k=1;

       f=['I:\EXP4\ahorario\p0\ima1.bmp'];
          
 
        rgb_img = imread(f);
 
    	Ip = .2989*rgb_img(:,:,1)+.5870*rgb_img(:,:,2) +.1140*rgb_img(:,:,3);
 
       
     
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
      

