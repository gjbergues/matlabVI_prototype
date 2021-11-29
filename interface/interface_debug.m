
%This function calls interface_debug.fig
function varargout = interface_debug(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @interface_debug_OpeningFcn, ...
                   'gui_OutputFcn',  @interface_debug_OutputFcn, ...
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

function interface_debug_OpeningFcn(hObject, ~, handles, varargin)

    handles.output = hObject;
    guidata(hObject, handles);

function varargout = interface_debug_OutputFcn(~, ~, handles) 
    varargout{1} = handles.output;

function VIDEO_CreateFcn(~, ~, ~)

function onoff_Callback(hObject, ~, handles)
    
    state = get(hObject, 'Value');
    
    if state == get(hObject, 'Max')
        set(handles.onoff, 'string', 'OFF'); 
        set(handles.file, 'string', 'F:\Fotos autocolimador\prototipo');
        set(handles.ExcelFile, 'string', ' ');
		handles.vid = videoinput('winvideo', 1, 'BYBG_1624X1234');
        guidata(hObject, handles);    
        vidRes = get(handles.vid, 'VideoResolution');
        nBands = get(handles.vid, 'NumberofBands');
        handles.hImage = image(zeros(vidRes(2), vidRes(1), nBands), 'Parent', handles.VIDEO);
        preview(handles.vid, handles.hImage)  
        
        %Gain set
        handles.src = getselectedsource(handles.vid);
        handles.src.Exposure = 0;
        handles.src.Gain = 250;
        %Brightness set
        handles.src = getselectedsource(handles.vid);
        %handles.src.Exposure = 0;
        handles.src.Brightness = 250; 
        %Dxy set
        set(handles.dist_dxy, 'string', 97.105);       
        %Measurement set
        set(handles.xpix, 'string', 0);            
        set(handles.ypix, 'string', 0);  
        set(handles.guinada, 'string', 0); 
        set(handles.cabeceo, 'string', 0); 
    elseif state == get(hObject, 'Min')  
        set(handles.onoff, 'string', 'ON');
        set(handles.file, 'string', ' ');
        set(handles.dist_dxy, 'string', 0);        
        set(handles.xpix, 'string', 0);            
        set(handles.ypix, 'string', 0);  
        set(handles.guinada, 'string', 0); 
        set(handles.cabeceo, 'string', 0); 
        stoppreview(handles.vid);
        delete(handles.vid);        
        guidata(hObject, handles)  
        handles.rgb = image(imread('logo.jpg'), 'Parent', handles.VIDEO); 
        axis off
        axis image
    end  
    
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
        imwrite(frame,[file '\' num2str(i) '.bmp']);
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
 
 
    [PHf, PVf] = measurement5(handles.vid);
    
    handles.PVf = PVf;
    handles.PHf = PHf;
    
    set(handles.xpix, 'string', handles.PVf);            
    set(handles.ypix, 'string', handles.PHf);
    set(handles.guinada, 'string', 0); 
    set(handles.cabeceo, 'string', 0);     
   

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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function medir_Callback(~, ~, handles)
   
  if (get(handles.xpix, 'String')== '0')
     
     f = errordlg('SET 0 FIRST', 'Measurement Error');
      
  else
    
    [PHf, PVf] = measurement5(handles.vid);
      
    handles.PVf = PVf;
    handles.PHf = PHf;    
 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%% MEDICIÓN %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %Obtengo parámetro Delta XY
    dxy = str2double(get(handles.dist_dxy, 'String'));
    
    %%%%$%%%%%% ANGULO DE CABECEO %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
    refy0 = str2double(get(handles.ypix,'String'));
    medh = [(handles.PHf - refy0)*60]/dxy;  
    medhS = num2str(medh, 5); %Paso a string para limitar decimales
    set(handles.cabeceo, 'string', medhS);
    
    %%%%%$%%%%%% ANGULO DE GUIÑADA %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    refx0 = str2double(get(handles.xpix,'String'));
    medv = [(handles.PVf - refx0)*60]/dxy;    
    medvS = num2str(medv, 5);%Paso a string para limitar decimales
    set(handles.guinada, 'string', medvS);
    
%         if (h==1)
%             nah=xlsread('nivel.xlsx','B3:B53');%med nivel antihorario
%             nahref= (nah - nah(1));%referencio el nivel a la primera medición
%             xlswrite('nivel.xlsx', nahref, 1,'C3:C53');%escribo en tabla
%             xlswrite('nivel.xlsx', medh', 1,'D3:D53');%coloco medición con interfaz
%             difah = nahref + medh';%hago la diferencia entre nivel-autocolimador
%             xlswrite('nivel.xlsx', difah, 1,'E3:E53');%escribo diferencia
%             xlswrite('nivel.xlsx', medv' , 1,'I3:I53');%valores verticales
%         end  
  %f = errordlg('Correct Measurement', 'Message'); 
    
%   filE= get(handles.ExcelFile, 'String');  
%   if (strcmp(filE, ' '))
%      f = errordlg('Write Path', 'Measurement Error');
%   end
    
    %guidata(hObject, handles); 
%     filename = 'testdata.xlsx';
% A = [12.7 5.02 -98 63.9 0 -.2 56];
% xlswrite(filename,A)
    
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

function ExcelFile_Callback(~, ~, ~)


function ExcelFile_CreateFcn(hObject, ~, ~)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
