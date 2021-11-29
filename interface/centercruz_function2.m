%This function find the center without making the background substraction

function  [bvu, bhu] = centercruz_function2(Isf)
   
    k = 0;
    bh = 1:162;
    bv = 1:123;
    
    for j = 1:162           
        k = k + 9;
        cv = squeeze(Isf(:,j+k));%cortes verticales       
                
        [~, Inh] = max(cv);%M= valor, I=�ndices.      
        
        bh(j) = Inh; %valor central detectado para cada corte         
    end
    
        bhu = median(bh);  %posici�n l�nea horizontal      
    
     k = 0;
     for j = 1:123
        
        k = k + 9;
        ch = squeeze(Isf(j+k,:));%cortes horizontales
      
        [~, Inv] = max(ch);%M= valor, I=�ndices.
       
        bv(j) = Inv; %valor central detectado de la gaussiana para cada corte                
     end
     
      bvu = median(bv);  %posici�n l�nea vertical
      
end