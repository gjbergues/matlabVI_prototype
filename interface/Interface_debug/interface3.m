
%This function calls interface3.fig
function varargout = interface3(varargin)
    gui_Singleton = 1;
    gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @interface3_OpeningFcn, ...
                   'gui_OutputFcn',  @interface3_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
    if nargin && ischar(varargin{1})
        gui_State.gui_Callback = str2func(varargin{1});
    end

    if nargout
        [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
    else
        gui_mainfcn(gui_State, varargin{:});
    end

function interface3_OpeningFcn(hObject, ~, handles, varargin)

    handles.output = hObject;
    guidata(hObject, handles);

function varargout = interface3_OutputFcn(~, ~, handles) 
    varargout{1} = handles.output;

function VIDEO_CreateFcn(~, ~, ~)

function onoff_Callback(hObject, ~, handles)
    
    state = get(hObject, 'Value');%Obtengo variable de boton ON/OFF
    
    if state == get(hObject, 'Max')%INICIAR INTERFAZ
        %SERIAL PORT
        delete(instrfindall);
        %%%%%%%%%%%%%%%%%%%%%%%%%
        set(handles.onoff, 'string', 'OFF'); 
        set(handles.file, 'string', 'F:\Fotos autocolimador\prototipo');
        set(handles.ExcelFile, 'string', 'C:\Users\Bergues\Dropbox\Matlab softwares\prototype\interface\Interface_debug\medidas1.xlsx');
		%VIDEO
        handles.vid = videoinput('winvideo', 1, 'BYBG_1624X1234');            
        vidRes = get(handles.vid, 'VideoResolution');
        nBands = get(handles.vid, 'NumberofBands');
        handles.hImage = image(zeros(vidRes(2), vidRes(1), nBands), 'Parent', handles.VIDEO);
        preview(handles.vid, handles.hImage)  
                
        handles.src = getselectedsource(handles.vid);
        handles.src.Exposure = 0;
        handles.src.Gain = 250;
        handles.src.Brightness = 250; 
        
        %Dxy set
        set(handles.dist_dxy, 'string', 97.0777);       
        %Measurement set
        set(handles.xpix, 'string', 0);            
        set(handles.ypix, 'string', 0);  
        set(handles.guinada, 'string', 0); 
        set(handles.cabeceo, 'string', 0); 
        set(handles.nom, 'string', 0);        
        set(handles.Count, 'string', 'Counter');
    elseif state == get(hObject, 'Min')%APAGAR INTERFAZ        
        set(handles.onoff, 'string', 'ON');
        set(handles.file, 'string', ' ');
        set(handles.dist_dxy, 'string', 0);        
        set(handles.xpix, 'string', 0);            
        set(handles.ypix, 'string', 0);  
        set(handles.guinada, 'string', 0); 
        set(handles.cabeceo, 'string', 0); 
        set(handles.Temp, 'string', 0);       
        set(handles.Deriva, 'string', 0);  
        %VIDEO
        stoppreview(handles.vid);
        delete(handles.vid);  
        %SERIAL PORT
        if strcmp(get(handles.Ton, 'string'), 'OFF')
            set(handles.Ton, 'string', 'ON'); 
            fclose(handles.s);
            delete(handles.s);
            clear handles.s    
        end
        %%%%%%%%%%%%%%%%
        handles.rgb = image(imread('logo.jpg'), 'Parent', handles.VIDEO); 
        axis off
        axis image
    end  
    guidata(hObject, handles) 
    
%OBTENER PASO DE LA ESCALA    
function scale_calibration_Callback(~, ~, handles)
    
    [Dxy] = scale_calibrationE(handles.vid);
    
    %Escribo en interfaz el valor en píxeles Dxy
    set(handles.dist_dxy, 'string', Dxy);
   
    
%Función que guarda imágenes en una carpeta creada por usuario.
function save_image_Callback(~, ~, handles)
    for i= 1:5
        frame = getsnapshot(handles.vid);    
        file= get(handles.file, 'String');
        imwrite(frame, [file '\' num2str(i) '.bmp']);
    end

%Función para escribir el archivo
function file_Callback(~, ~, ~)

function file_CreateFcn(hObject, ~, ~)

    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end

%Función para escribir Dxy, paso de la escala
function dist_dxy_Callback(~, ~, ~)

function dist_dxy_CreateFcn(hObject, ~, ~)

    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
    

%Guarda el valor de referencia en la medición
function setm0_Callback(~, ~, handles)    

    %[PHf, PVf] = measurement5(handles.vid);   
    [PHf, PVf] = measurement7(handles.vid);
    
    set(handles.xpix, 'string', PVf);            
    set(handles.ypix, 'string', PHf);
    set(handles.guinada, 'string', 0); 
    set(handles.cabeceo, 'string', 0);   
    set(handles.Temp, 'string', 0);       
    set(handles.Deriva, 'string', 0);
    set(handles.nom, 'String', 0);
    set(handles.Count, 'string', 0);
    
   

%Función para escribir posición de guiñada de referencia en la medición
function xpix_Callback(~, ~, ~)

function xpix_CreateFcn(hObject, ~, ~)
    
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white'); 
    end


%Función para escribir posición de cabeceo de referencia en la medición
function ypix_Callback(~, ~, ~)

function ypix_CreateFcn(hObject, ~, ~)

    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% MEDIR CRUZ%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function medir_Callback(~, ~, handles)
  
    pop = get(handles.tipo, 'Value'); %pop menu 1=un punto; 2=serie
    dxy = str2double(get(handles.dist_dxy, 'String'));%Obtengo calibración
    refy0 = str2double(get(handles.ypix,'String'));
    refx0 = str2double(get(handles.xpix,'String')); 
  
    if (pop == 1)  
        if (get(handles.xpix, 'String')== '0')
            errordlg('SET 0 FIRST', 'Measurement Error');
      
        elseif (get(handles.nom, 'string') == '0')     
            errordlg('SET NoM', 'measurement error');        
        else
        
            i = 0;             
            dim  =  str2double(get(handles.nom, 'String'));
            v_c = zeros(1, dim);
            v_g = zeros(1, dim);
            Time = zeros(1, dim);
            Tv = zeros(1, dim);
            Dv = zeros(1, dim);        
        
            if  strcmp(get(handles.Ton, 'string'), 'OFF')
                a = fgets (handles.s);
                b = fgets (handles.s);
                if a(1) == '1'
                    Tv(1) = str2double(a(5:12));
                    Dv(1) = str2double(b(5:12));
                else
                    Tv(1) = str2double(b(5:12));
                    Dv(1) = str2double(a(5:12));
                end
            set(handles.Temp, 'string', num2str(Tv(i+1), 4)); 
            set(handles.Deriva, 'string', num2str(Dv(i+1), 3));
            end

        %%%%%%%%%%%%%%%%% MEDICIÓN DE UN SOLO PUNTO%%%%%%%%%%%%%%%%%%%%%%%%
            while (dim - i) ~= 0 %Establece cantidad de mediciones
            
                tic%TIEMPO INICIO 
                i = i+1;     
                set(handles.Count, 'string', num2str(i));
                %Serial Port
                if strcmp(get(handles.Ton, 'string'), 'OFF')
                    a = fgets (handles.s);
                    b = fgets (handles.s);
                    if a(1) == '1'
                        Tv(i+1) = str2double(a(5:12));
                        Dv(i+1) = str2double(b(5:12));
                    else
                        Tv(i+1) = str2double(b(5:12));
                        Dv(i+1) = str2double(a(5:12));
                    end
                    set(handles.Temp, 'string', num2str(Tv(i+1), 4)); 
                    set(handles.Deriva, 'string', num2str(Dv(i+1), 3));  
                end               
                     
 
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                %%%%%%%%%%%%%%%%%%%%%%%%%%% MEDICIÓN %%%%%%%%%%%%%%%%%%%%%%%%%%
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
           
                %[PHf, PVf] = measurement5(handles.vid);
                [PHf, PVf] = measurement7(handles.vid);
                %%%%$%%%%%% ANGULO DE CABECEO %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%        
            
                v_c(i) = (PHf - refy0)*60/dxy;                           
                set(handles.cabeceo, 'string', num2str(v_c(i), 3));
                
                %%%%%$%%%%%% ANGULO DE GUIÑADA %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
            
                v_g(i) = (PVf - refx0)*60/dxy;                              
                set(handles.guinada, 'string', num2str(v_g(i), 3));               
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%              
                
                Tprov = toc;% TIEMPO FINAL
                if i == 1
                    Time(1)= Tprov;
                else
                    Time(i) = Time(i-1) +  Tprov;
                end
                
                 
                save('test.mat', 'v_c', 'v_g', 'Tv', 'Dv', 'Time');                
            end   
  
            %WRITE MEASUREMENT IN EXCEL FILE
            l1 = num2str(dim+1);
            Tlong = strcat('D2:D', l1);
            Dlong = strcat('E2:E', l1);
            xlswrite(get(handles.ExcelFile, 'String'), {'''CABECEO'}, 1,'A1');  
            xlswrite(get(handles.ExcelFile, 'String'), {'''GUIÑADA'}, 1,'B1'); 
            xlswrite(get(handles.ExcelFile, 'String'), {'''Time'}, 1,'C1'); 
            xlswrite(get(handles.ExcelFile, 'String'), {'''Temp'}, 1,'D1'); 
            xlswrite(get(handles.ExcelFile, 'String'), {'''DeltaT'}, 1,'E1'); 
            xlswrite(get(handles.ExcelFile, 'String'), v_c', 1,'A2');  
            xlswrite(get(handles.ExcelFile, 'String'), v_g', 1,'B2'); 
            xlswrite(get(handles.ExcelFile, 'String'), Time', 1,'C2'); 
            xlswrite(get(handles.ExcelFile, 'String'), Tv', 1, Tlong); 
            xlswrite(get(handles.ExcelFile, 'String'), Dv', 1, Dlong); 
        end
    
  %%%%%%%%%%%%%%%%%%%%% MEDICIÓN EN SERIE%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
    else
        if (get(handles.xpix, 'String')== '0')
            errordlg('SET 0 FIRST', 'Measurement Error');
        elseif (get(handles.nom, 'string') == '0')     
            errordlg('SET NoM', 'measurement error');      
        else    
            i = 0; 
            dim  =  str2num(get(handles.nom, 'String'));
            v_c = zeros(1, dim);
            v_g = zeros(1, dim);        
            Tv = zeros(1, dim);
            Dv = zeros(1, dim);
            %SERIAL PORT
            if  strcmp(get(handles.Ton, 'string'), 'OFF')
                a = fgets (handles.s);
                b = fgets (handles.s);
                if a(1) == '1'
                    Tv(1) = str2double(a(5:12));
                    Dv(1) = str2double(b(5:12));
                else
                    Tv(1) = str2double(b(5:12));
                    Dv(1) = str2double(a(5:12));
                end
            set(handles.Temp, 'string', num2str(Tv(i+1), 4)); 
            set(handles.Deriva, 'string', num2str(Dv(i+1), 3));
            end 
           
            
            while (dim - i) ~= 0 %Establece cantidad de mediciones
                tic%TIEMPO INICIO
                i = i+1;
                set(handles.Count, 'string', num2str(i));
                %SERIAL PORT: MEDICIÓN TEMPERATURA
                if strcmp(get(handles.Ton, 'string'), 'OFF')
                    a = fgets (handles.s);
                    b = fgets (handles.s);
                    if a(1) == '1'
                        Tv(i+1) = str2double(a(5:12));
                        Dv(i+1) = str2double(b(5:12));
                    else
                        Tv(i+1) = str2double(b(5:12));
                        Dv(i+1) = str2double(a(5:12));
                    end
                    set(handles.Temp, 'string', num2str(Tv(i+1), 4)); 
                    set(handles.Deriva, 'string', num2str(Dv(i+1), 3));  
                end   

                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

                sb = num2str(i);
                uiwait(msgbox(cat(2, {'Introduce Measurement '}, sb)));  
  
 
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%% MEDICIÓN %%%%%%%%%%%%%%%%%%%%%%%
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
                [PHf, PVf] = measurement7(handles.vid);
    
                %%%%$%%%%%% ANGULO DE CABECEO %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%              
                v_c(i) = (PHf - refy0)*60/dxy;            
                set(handles.cabeceo, 'string', num2str(v_c(i), 3));
                %%%%%$%%%%%% ANGULO DE GUIÑADA %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%           
                v_g(i) = (PVf - refx0)*60/dxy;                      
                set(handles.guinada, 'string', num2str(v_g(i), 3)); 
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                Time(i)= toc;% TIEMPO FINAL
                save('test.mat', 'v_c', 'v_g', 'Tv', 'Dv', 'Time');

            end 
        
            %WRITE MEASUREMENT IN EXCEL FILE 
            l1 = num2str(dim+1);
            Tlong = strcat('D2:D', l1);
            Dlong = strcat('E2:E', l1);
            xlswrite(get(handles.ExcelFile, 'String'), {'''CABECEO'}, 1,'A1');  
            xlswrite(get(handles.ExcelFile, 'String'), {'''GUIÑADA'}, 1,'B1'); 
            xlswrite(get(handles.ExcelFile, 'String'), {'''Time'}, 1,'C1'); 
            xlswrite(get(handles.ExcelFile, 'String'), {'''Temp'}, 1,'D1'); 
            xlswrite(get(handles.ExcelFile, 'String'), {'''DeltaT'}, 1,'E1'); 
            xlswrite(get(handles.ExcelFile, 'String'), v_c', 1,'A2');  
            xlswrite(get(handles.ExcelFile, 'String'), v_g', 1,'B2'); 
            xlswrite(get(handles.ExcelFile, 'String'), Time', 1,'C2'); 
            xlswrite(get(handles.ExcelFile, 'String'), Tv', 1, Tlong); 
            xlswrite(get(handles.ExcelFile, 'String'), Dv', 1, Dlong); 
        end
    end
  
%Función para escribir ángulo de Guiñada    
function guinada_Callback(~, ~, ~)

function guinada_CreateFcn(hObject, ~, ~)

    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end

%Función para escribir ángulo de Cabeceo 
function cabeceo_Callback(~, ~, ~)

function cabeceo_CreateFcn(hObject, ~, ~)

    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end

%Función que toma el número de mediciones 
function nom_Callback(~, ~, ~)


% --- Executes during object creation, after setting all properties.
function nom_CreateFcn(hObject, ~, ~)

    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end


%Botón que indica si es medición de un punto o de varios en serie
function tipo_Callback(~, ~, ~)

function tipo_CreateFcn(hObject, ~, ~)

    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end


%Función de temperatura
function Temp_Callback(~, ~, ~)

function Temp_CreateFcn(hObject, ~, ~)

    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end


%Función de delta temperatura
function Deriva_Callback(~, ~, ~)

function Deriva_CreateFcn(hObject, ~, ~)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end

function ExcelFile_Callback(~, ~, ~)


function ExcelFile_CreateFcn(hObject, ~, ~)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Ton.
function Ton_Callback(hObject, ~, handles)    
    
    state = get(hObject, 'Value');%Obtengo variable de boton ON/OFF
  
    
   
    if state == get(hObject, 'Max') 
      
        set(handles.Ton, 'string', 'OFF');         
        delete(instrfindall);
        handles.s = serial('COM5');
        set(handles.s,'BaudRate', 9600);
        fopen(handles.s);     
        readasync(handles.s)

       
   
    elseif state == get(hObject, 'Min')
    
        set(handles.Ton, 'string', 'ON');       
        set(handles.Temp, 'string', 0);   
        set(handles.Deriva, 'string', 0);
        
        fclose(handles.s);
        delete(handles.s);
        clear handles.s             
    end  
    guidata(hObject, handles);



function Count_Callback(hObject, eventdata, handles)
% hObject    handle to Count (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Count as text
%        str2double(get(hObject,'String')) returns contents of Count as a double


% --- Executes during object creation, after setting all properties.
function Count_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Count (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
