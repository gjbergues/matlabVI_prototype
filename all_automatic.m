%Method
%HOUGH=0
%GAUSS=1
%REGRES=2
%MAX = 3
%PROB =4
%rgb = 5

%function [medh, posh, medv, posv]=all_automatic(M) %when
%I need to see some value 
function  [medh, medv] = all_automatic(M)

    ND = 2;
    
    %Initial values to acelerate process
    pHv = zeros(1, 2);
    medh_H = zeros(1, 2);
    BVV2 = zeros(1, 2);
    BHH2 = zeros(1, 2);
    IV2 = zeros(2, 5);
    IH2 = zeros(2, 5);
    medh = zeros(1, 2);
    medv = zeros(1, 2);
    
    for k = 1:ND % numero de directorios
        
        if (M==0)%HOUGH
            [pos_hough] = Hough_function(k);
            pHv(k) = pos_hough; %is just the horizontal position
        end
    
        if (M==1)%GAUSS
           [BVV, BHH, IV, IH] = analisis_cruz_for_automatic(k);
 
            BVV2(k) = BVV;
            BHH2(k) = BHH;
            IV2(k,:) = IV;
            IH2(k,:) = IH;
        end
        
        if (M==2)%REGRES
            [pos_reg] = reg_function(k);
            pHv(k) = pos_reg; %is just the horizontal position
        end
                 
        if (M==3)%MAX
            [pos_max] = max_function(k);
            pHv(k) = pos_max; %is just the horizontal position
        end

         if (M==4)%PROB
            [pos_prob] = prob_function(k);
            pHv(k) = pos_prob; %is just the horizontal position
        end
        
         if (M==5)%RGB
            [pos_rgb] = cruz_rgb(k);
            pHv(k) = pos_rgb; %is just the horizontal position
        end
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    if (M==0)%HOUGH
        %Measurement Results
    
        %%%%Cross Horizontal positions%%%%%%
            
        for i = 1:ND
            medh_H(i) = (-(pHv(i)-pHv(1)))*60/97.3;   
        end
        
%         if (h==1)
%             nah=xlsread('nivel.xlsx','B3:B53');%med nivel antihorario
%             nahref= (nah - nah(1)); %referencio el nivel a la primera medición
%             xlswrite('nivel.xlsx', nahref, 1,'F3:F53');%escribo en tabla
%             xlswrite('nivel.xlsx', medh_H', 1,'G3:G53');%coloco medición con interfaz HOUGH
%             difah_H = nahref + medh_H';%hago la diferencia entre nivel-autocolimador
%             xlswrite('nivel.xlsx', difah_H, 1,'H3:H53');%escribo diferencia
%             %xlswrite('nivel.xlsx',medv',1,'F3:F53');%valores verticales
%         end  
    end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if (M==1)%GAUSS
        %Measurement Results
    
        %%%%Cross Horizontal positions%%%%%%
        posh = BHH2;
       
    
        for i = 1:ND
            medh(i) = (-(BHH2(i)-BHH2(1)))*60/97.3;                
        end    
        medh
        %%%%Cross Vertical positions%%%%%%
        posv = BVV2;
        for j = 1:ND
            medv(j) = (-(BVV2(j)-BVV2(1)))*60/97.3;        
        end
        medv
%         if (h==1)
%             nah=xlsread('nivel.xlsx','B3:B53');%med nivel antihorario
%             nahref= (nah - nah(1));%referencio el nivel a la primera medición
%             xlswrite('nivel.xlsx', nahref, 1,'C3:C53');%escribo en tabla
%             xlswrite('nivel.xlsx', medh', 1,'D3:D53');%coloco medición con interfaz
%             difah = nahref + medh';%hago la diferencia entre nivel-autocolimador
%             xlswrite('nivel.xlsx', difah, 1,'E3:E53');%escribo diferencia
%             xlswrite('nivel.xlsx', medv' , 1,'I3:I53');%valores verticales
%         end  
    end
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    if (M==2)%REGRESION
        %Measurement Results
    
        %%%%Cross Horizontal positions%%%%%%
            
        for i = 1:ND
            medh_R(i) = (-(pHv(i)-pHv(1)))*60/97.3;   
        end    

%         if (h==1)
%             nah=xlsread('nivel_gaussyregres.xlsx','B3:B53');%med nivel antihorario
%             nahref= (nah - nah(1)); %referencio el nivel a la primera medición
%             xlswrite('nivel_gaussyregres.xlsx', nahref, 1,'F3:F53');%escribo en tabla
%             xlswrite('nivel_gaussyregres.xlsx', medh_R', 1,'G3:G53');%coloco medición con interfaz HOUGH
%             difah_R = nahref + medh_R';%hago la diferencia entre nivel-autocolimador
%             xlswrite('nivel_gaussyregres.xlsx', difah_R, 1,'H3:H53');%escribo diferencia
%             %xlswrite('nivel.xlsx',medv',1,'F3:F53');%valores verticales
%         end   
    end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    if (M==3)%MAX
        %Measurement Results
    
        %%%%Cross Horizontal positions%%%%%%
            
        for i = 1:ND
            medh_M(i) = (-(pHv(i)-pHv(1)))*60/97.3;   
        end    

%         if (h==1)
%             nah=xlsread('nivel_gaussymax.xlsx','B3:B53');%med nivel antihorario
%             nahref= (nah - nah(1)); %referencio el nivel a la primera medición
%             xlswrite('nivel_gaussymax.xlsx', nahref, 1,'F3:F53');%escribo en tabla
%             xlswrite('nivel_gaussymax.xlsx', medh_M', 1,'G3:G53');%coloco medición con interfaz HOUGH
%             difah_M = nahref + medh_M';%hago la diferencia entre nivel-autocolimador
%             xlswrite('nivel_gaussymax.xlsx', difah_M, 1,'H3:H53');%escribo diferencia
%             %xlswrite('nivel.xlsx',medv',1,'F3:F53');%valores verticales
%         end  
    end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     
    if (M==4)%PROB
        %Measurement Results
    
        %%%%Cross Horizontal positions%%%%%%
            
        for i = 1:ND
            medh_P(i) = (-(pHv(i)-pHv(1)))*60/97.3;   
        end    

%         if (h==1)
%             nah=xlsread('nivel_gaussyprob.xlsx','B3:B53');%med nivel antihorario
%             nahref= (nah - nah(1)); %referencio el nivel a la primera medición
%             xlswrite('nivel_gaussyprob.xlsx', nahref, 1,'F3:F53');%escribo en tabla
%             xlswrite('nivel_gaussyprob.xlsx', medh_P', 1,'G3:G53');%coloco medición con interfaz HOUGH
%             difah_P = nahref + medh_P';%hago la diferencia entre nivel-autocolimador
%             xlswrite('nivel_gaussyprob.xlsx', difah_P, 1,'H3:H53');%escribo diferencia
%             %xlswrite('nivel.xlsx',medv',1,'F3:F53');%valores verticales
%         end 
    end
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
    if (M==5)%RGB
        %Measurement Results
    
        %%%%Cross Horizontal positions%%%%%%
            
        for i = 1:ND
            medh_RGB(i) = (-(pHv(i)-pHv(1)))*60/97.3;   
        end    
 
%         if (h==1)
%             nah=xlsread('nivel_gaussyrgb.xlsx','B3:B53');%med nivel antihorario
%             nahref= (nah - nah(1)); %referencio el nivel a la primera medición
%             xlswrite('nivel_gaussyrgb.xlsx', nahref, 1,'F3:F53');%escribo en tabla
%             xlswrite('nivel_gaussyrgb.xlsx', medh_RGB', 1,'G3:G53');%coloco medición con interfaz HOUGH
%             difah_rgb = nahref + medh_RGB';%hago la diferencia entre nivel-autocolimador
%             xlswrite('nivel_gaussyrgb.xlsx', difah_rgb, 1,'H3:H53');%escribo diferencia
%             %xlswrite('nivel.xlsx',medv',1,'F3:F53');%valores verticales
%         end       
 
    end
    
end%FINAL FUNCIÓN