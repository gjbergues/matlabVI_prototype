delete(instrfindall);
s = serial('COM5');
set(s,'BaudRate', 9600);
fopen(s);
% fprintf(s,'*IDN?')
% out = fscanf(s)

    
  
i=1;
readasync(s)
%stopasync(s)
T = zeros(1,100);
D = zeros(1,100);
% fprintf(s, 'MEAS? 1');
% T(1) = str2double(fscanf(s)); 
% 
% fprintf(s, 'MEAS? 3');
% D(1) = str2double(fscanf(s));

 while i < 10

%     fprintf(s, 'MEAS? 1');
%     Tprov = str2double(fscanf(s))  
%     Ba = isnan(Tprov);
%     if ~Ba && Tprov > 19             
%         T(i+1) = Tprov;
%     else
%         T(i+1)=T(i);
%     end
%                     
%     fprintf(s, 'MEAS? 3');
%     Dprov = str2double(fscanf(s))
%     Ba = isnan(Dprov);
%     if ~Ba && Dprov < 10             
%         D(i+1) = Dprov;
%     else
%          D(i+1) = D(i);
%     end
    
                a = fgets (s)
                b = fgets (s)
                if a(1) == '1'
                    Tv(1) = str2double(a(5:12));
                    Dv(1) = str2double(b(5:12));
                else
                    Tv(1) = str2double(b(5:12));
                    Dv(1) = str2double(a(5:12));
                end
    
    
    i = i+1;
      
 end

pT = mean(Tv);
pD = mean(Dv);
fclose(s);
delete(s)
clear s





