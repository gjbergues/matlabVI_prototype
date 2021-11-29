%This function find the center without making the background substraction

function  [bvu, bhu] = centercruz_function2(Isf)
   
    k = 0;
    bh = 1:162;
    bv = 1:123;
    
    
    for j = 1:162    
        k = k + 9;
        cv = squeeze(Isf(:, j+k));%cortes verticales       
                
        [~, Inh] = max(cv);%M= valor, I=índices.      
        
        bh(j) = Inh; %valor central detectado para cada corte         
    end
    
     bhu = median(bh);  %posición línea horizontal      
    
     k = 0;
     for j = 1:123
        
        k = k + 9;
        ch = squeeze(Isf(j+k, :));%cortes horizontales
      
        [~, Inv] = max(ch);%M= valor, I=índices.
       
        bv(j) = Inv; %valor central detectado de la gaussiana para cada corte                
     end
     
      bvu = median(bv);  %posición línea vertical      
       
      
end