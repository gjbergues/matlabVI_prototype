function  [pos_hough]=Hough_function(k,h)

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
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%% LINEA HORIZONTAL DE LA CRUZ%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 	y = 1:200;
	x = 1:200;
    
    xminh= bvu-230;
    yminh = bhu-100;
    
    Isf_c = imcrop(Ip,[xminh yminh 199 199]);%[xmin ymin width height]% 
    
	%%%%%%%%%%%%%% Take out BACKGROUND%%%%%%%%%%%%%%%%%%%%%%%%%%%
    [fitfh, goffh] = Fit_fondo_cruz_H(x, y, Isf_c);
    %figure; surf(xx, yy, II);
%     
    [t1,t2] = meshgrid( x,y);
    promfit = fitfh( t1, t2);
%     %figure; surf(t1, t2, promfit);
% 
    Isf_c = abs(promfit-Isf_c);
%     %figure; imagesc(J2); colormap(gray)
%     %figure; surf(xx, yy, J2);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
    
    %figure; imagesc(Isf_c); colormap(gray)% para ver cada corte
    
    %figure; surf(x, y, Isf_c);
       
    %%%%%%%%%%%%%%%%%%%%% HOUGH %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     A = (Isf_c > 56);
%     B = (56 >Isf_c & Isf_c >= 52);
%     C = (52 > Isf_c & Isf_c > 42);
%     D = (42 > Isf_c & Isf_c > 30);
%     E = (30 > Isf_c & Isf_c > 16);
%     T = A+B+C+D+E;
%     
    max_h = mean(max(Isf_c));
    
    th1 = 4;
    th2 = 14;
    th3 = 26;
    th4 = 40;

    A = (Isf_c > max_h);
    B = (max_h >Isf_c & Isf_c >= max_h-th1);
    C = (max_h-th1 > Isf_c & Isf_c > max_h-th2);
    D = (max_h-th2 > Isf_c & Isf_c > max_h-th3);
    E = (max_h-th3 > Isf_c & Isf_c > max_h-th4);
    T = A+B+C+D+E;
    
    
%     th1 = 28;
%     th2 = 69;
%     th3 = 110;
%     th4 = 159;
%     th5 = 178;
% 
%     A = (Isf_c > max_h);
%     B = (max_h >Isf_c & Isf_c >= max_h-th1);
%     C = (max_h-th1 > Isf_c & Isf_c > max_h-th2);
%     D = (max_h-th2 > Isf_c & Isf_c > max_h-th3);
%     E = (max_h-th3 > Isf_c & Isf_c > max_h-th4);
%     F = (max_h-th4 > Isf_c & Isf_c > max_h-th5);
%     T = A+B+C+D+E+F;
    

    [H,theta,rho] = hough(T,'RhoResolution',1,'Theta',-90:1:89.5);
    [Hfil, Hcol]= find(H >= (0.5*max(max(H))));

    %x1 = theta(Hcol(:,1));
    y1 = rho(Hfil(:,1));
    %figure; plot(x1,y1,'s','color','black');
    
    %Separation of the vector y1 in its positives and negatives values
    ypos=y1(y1>=0); 
    yneg=abs(y1(y1<0));
    
    %final position of the horizontal line
    pos_hough = (mean(ypos)+ mean(yneg))/2 + yminh;
    

    
end
    