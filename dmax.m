%function [I,r,p,bhu, sv, bh, mdl] = dmax
clear all

ND = 5;
% Nx = 1624; %Column
% Ny = 1234; %rows

Nx = 100; %Column
Ny = 100; %rows

n=100;

% load('function1234n_18.mat');
% load('function1234.mat');

load('D:\PhD\Simulation Data\frimN23_05.mat');
load('D:\PhD\Simulation Data\frim05.mat');


I = Gfn;
%position of the line
bh=zeros(100,n);
ih=zeros(100,5);
r=zeros(100);
acbh=0;

for i = 1:100
      J= (I(:,:,i));
      
               
      for j = 1:30
        cv = squeeze(J(:,j+2));
        
 
       [M,In] = max(cv);%M= valor, I=índices.
       
        
        bh(i,j) = In; %valor central detectado de la gaussiana para cada corte
        
        acbh = acbh + bh(i,j);%acumulador de valores centrales para cada corte de la imagen
        
        %ih(i,j) = (cih(2,2)-cih(1,2))/2; %incertidumbre para cada corte
        
      end
      
      bhu(i)= acbh/30;  %valor central único para cada imagen 
      acbh=0;
end 

 
 r = corcoef(sv,bhu');
 p = pearson(sv,bhu);
 
%    plot(sv,bhu, '*b')
%    title('Detección del valor máximo'); 
%    xlabel('Gauss function position');
%    ylabel('center detect');   
 
   mdl = LinearModel.fit(sv, bhu); 
   figure; plot(mdl)
   title('Maximun Detection - Linear Model ');
   xlabel('Simulated Line Position');
   ylabel('Center Detected');

% lab{1}='horizontal values' ;
% figure;boxplot([bhh', BVV'],lab)



%end

