%function [I,r,bhu,sv,bh] = dprob
clear all

ND = 5;
% Nx = 1624; %Column
% Ny = 1:1234; %rows

Nx = 100; %Column
Ny = 1:100; %rows
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
      
               
      for j = 1:5
        cv = squeeze(J(:,j+5));
        
        y(i) = (Ny*cv)/sum(cv);
             
        
        %bh(i,j) = In; %valor central detectado de la gaussiana para cada corte
        
        acbh = acbh + y(i);%acumulador de valores centrales para cada corte de la imagen
        
        %ih(i,j) = (cih(2,2)-cih(1,2))/2; %incertidumbre para cada corte
        
      end
      bhu(i)= acbh/5;  %valor central único para cada imagen 
      acbh=0;
end 

 
 r = corcoef(sv,bhu');
 p = pearson(sv, bhu);
%     plot(sv,bhu, '*b')
%     title('Detección Probabilistica bajo ruido'); 
%     xlabel('Gauss function position');
%     ylabel('center detect');   
 
    mdl = LinearModel.fit(sv, bhu); 
    figure; plot(mdl)
    title('Probabilistic Detection - Linear Model');
    xlabel('Simulated Line Position');
    ylabel('Center Detected');
    
% lab{1}='horizontal values' ;
% figure;boxplot([bhh', BVV'],lab)



%end
