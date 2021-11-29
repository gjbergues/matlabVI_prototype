%Method
%HOUGH=0
%GAUSS=1


%function [medh, posh, medv, posv]=all_automatic(M) %when
%I need to see some value 
function  [medh, medv] = crosspos(M)

    %Llamar función de cálculo DELTA XY.
    %averiguar si se puede guardar valor con interfaz visual
    
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
    
    
    %setear 0 o primer medición, en base a esta se miden las siguientes.
    
    
    for k = 1:ND % numero de directorios
        
        if (M==0)%HOUGH
            [pos_hough] = Hough_function(k);
            pHv(k) = pos_hough; %is just the horizontal position
        end
    
        if (M==1)%GAUSS
           [BVV, BHH, IV, IH] = measure_cross(k);
 
            BVV2(k) = BVV;
            BHH2(k) = BHH;
            IV2(k,:) = IV;
            IH2(k,:) = IH;
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
        
        %%%%Cross Vertical positions%%%%%%
        posv = BVV2;
        for j = 1:ND
            medv(j) = (-(BVV2(j)-BVV2(1)))*60/97.3;        
        end
        
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
    
end%FINAL FUNCIÓN