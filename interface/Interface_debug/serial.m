delete(instrfindall);
s = serial('COM5');
set(s,'BaudRate', 9600);
fopen(s);
%out = fscanf(s);
i=0;
j=1;
while i < 3
    A = fread(s, 108);
    val = char(A)'
    if val ~= 0
        T = str2double(val(5:10));
        D = str2double(val(40:46));
        j = j+1;
    end
    i = i+1;
end
fclose(s)
delete(s)
clear s





