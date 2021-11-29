 clear all
% 
ND = 5;
% Nx = 1624; %Column
% Ny = 1:1234; %rows

Nx = 100; %Column
Ny = 1:100; %rows
n = 100;

% load('function1234n_18.mat');
% load('function1234.mat');



ey = 1:21;
ex = 1:100;

I = Gfn;
%position of the line

bh = zeros(100,n);
ih = zeros(100,5);
y = zeros(100);
r = zeros(100);
acbh = 0;
x = zeros(2000, 1);
y = zeros(2000, 1);
k=1;

%Create the vector X
% for i = 1:100
%     
%     for j = 1:19
%        x(k) = i;    
%        k = k + 1;
%     end
%     x(k) = i;
%     k= k + 1;
%              
% end

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

for i = 1:100
      J = (I(:,:,i));
          
      
      %Vector Y (responses)
      %y = J(:);
      
      %Vector W of Weights
      s = sum(y);
      P = J/s;
      W = P(:);

      a = ((sum(W .* x .* y) * sum(W)) - (sum(W .* y) * sum(W .* x) )) /((sum(W .* x.^2) * sum(W)) - (sum(W.*x))^2);
 
      b = ((sum(W .* x.^2) * sum(W .* y)) - ( sum(W .* x) * sum(W .* x .* y))) / ((sum(W.*x.^2)*sum(W)) - (sum(W.*x))^2);
      
      
      %Center detection for each position
      Cd(i) = b;
      %Slope for each detection
      Sd(i)= a;
      
end 





