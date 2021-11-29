function varargout = interface(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @interface_OpeningFcn, ...
                   'gui_OutputFcn',  @interface_OutputFcn, ...
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


function interface_OpeningFcn(hObject, eventdata, handles, varargin)

    handles.output = hObject;
    guidata(hObject, handles);

function varargout = interface_OutputFcn(hObject, eventdata, handles) 
    varargout{1} = handles.output;

function VIDEO_CreateFcn(hObject, eventdata, handles)

function onoff_Callback(hObject, eventdata, handles)
    
    state = get(hObject, 'Value');
    
    if state == get(hObject,'Max')
        set(handles.onoff, 'string', 'ON'); 
		handles.vid = videoinput('winvideo', 1, 'BYBG_1624X1234');
        guidata(hObject, handles);    
        vidRes = get(handles.vid, 'VideoResolution');
        nBands = get(handles.vid, 'NumberofBands');
        handles.hImage = image(zeros(vidRes(2), vidRes(1), nBands), 'Parent', handles.VIDEO);
        preview(handles.vid, handles.hImage)        
    elseif state == get(hObject,'Min')  
        set(handles.onoff, 'string', 'OFF');
        stoppreview(handles.vid);
        delete(handles.vid);        
        guidata(hObject, handles)  
        handles.rgb = image(imread('ima1.bmp'), 'Parent', handles.VIDEO);               
    end  
   
function scale_calibration_Callback(hObject, eventdata, handles)
    NI = 5;
    sum_I = 0;
    
    for i = 1 : NI
        gfile= get(handles.file, 'String');
        file = [gfile '\' num2str(i) '.bmp'];
        rgb_img = imread(file);
        I = .2989*rgb_img(:,:,1) + .5870*rgb_img(:,:,2) + .1140*rgb_img(:,:,3);
        sum_I = sum_I + (double(I)+1);
    end

    I = sum_I/(NI);
    %Obtengo el centro de la retícula.
    %Isf=image without backgroud
    [indC, indF, Isf] = scale_center(I); 

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%% ANÁLISIS HORIZONTAL %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    y = 1:50;
    x = 1:770;
    xmin = indC - 440;
    ymin = indF - 70;
    %corte de la imagen
    Ic = imcrop(Isf, [xmin ymin 769 49]);%[xmin ymin width height]%

    for j = 1 : 15  
        ch = squeeze(Ic(j,:));%cortes horizontales
        %fitting de 8 gaussianas
        [fith, gofh] = Fit_8gauss_H(x, ch);
        %obtengo los coeficientes de las gaussianas
        cH = coeffvalues(fith);
        bH = reshape(cH, 3, 8);
        b_fH = sort(bH(2,:));
        X = [ones(1,8)' (1:8)'];
        BH = b_fH';
        %modelo de regresión con los 8 centros de las gaussianas
        [bh, bint] = regress(BH, X);
        BHH(j) = bh(2);
        %incertidumbre del modelo lineal de regresión, obtengo con un 95%
        IH(j) = (bint(2,2) - bint(2,1))/2;
    end
    %Paso horizontal de la escala (en eje X).
    DX = mean(BHH);
    %Incertidumbre en X
    ux = mean(IH);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%% ANÁLISIS VERTICAL %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    yv = 1:770;
    xv = 1:50;
    xmin = indC - 60;
    ymin = indF - 330;
    %corte de la imagen
    Icv = imcrop(Isf, [xmin ymin 49 769]);%[xmin ymin width height]%

    for j= 1 : 50
        cv = squeeze(Icv(:,j))';
        [fitv, gofv] = Fit_8gauss_V(yv, cv);
        cV = coeffvalues(fitv);
        bV = reshape(cV, 3, 8);
        b_fV = sort(bV(2, :));
        X = [ones(1,8)' (1:8)'];
        BV = b_fV';
        [bv, bintv] = regress(BV, X);
        IV(j) = (bintv(2,2)-bintv(2,1))/2;
        BVV(j) = bv(2);
    end
    %Pasa vertical de la escala (en eje Y)
    DY = mean(BVV);
    %Incertidumbre en Y
    uy = mean(IV);

    %Cálculo de DELTA XY, la distancia entre segmentos consecutivos de la
    %escala:

    DXY=(DX + DY)/2;
    uxy=(ux + uy)/2;
    %Escribo en interfaz el valor en píxeles Dxy y su incertidumbre
    set(handles.dist_dxy, 'string', DXY);
    set(handles.uncert_dxy, 'string', uxy);
    
%Función que guarda imágenes en una carpeta creada por usuario.
function save_image_Callback(hObject, eventdata, handles)
    for i= 1:5
        frame = getsnapshot(handles.vid);    
        file= get(handles.file, 'String');
        imwrite(frame,[file '\' num2str(i) '.bmp']);
    end

%Función para regular la ganancia de la cámara.
function gain_Callback(hObject, eventdata, handles)
    handles.src = getselectedsource(handles.vid);
    handles.src.Exposure = 0;
    G = str2double(get(handles.gain, 'string'));
    handles.src.Gain = G;
    
function gain_CreateFcn(hObject, eventdata, handles)

    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
    
%Función para regular el brillo de la cámara.
function bright_Callback(hObject, eventdata, handles)
    handles.src = getselectedsource(handles.vid);
    handles.src.Exposure = 0;
    B = str2double(get(handles.bright, 'string'));
    handles.src.Brightness = B; 

function bright_CreateFcn(hObject, eventdata, handles)

    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end

%Función para escribir el archivo
function file_Callback(hObject, eventdata, handles)

function file_CreateFcn(hObject, eventdata, handles)

    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end

%Función para escribir Dxy, paso de la escala
function dist_dxy_Callback(hObject, eventdata, handles)

function dist_dxy_CreateFcn(hObject, eventdata, handles)

    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
    
%Función para escribir la incertidumbre en el paso de la escala
function uncert_dxy_Callback(hObject, eventdata, handles)

function uncert_dxy_CreateFcn(hObject, eventdata, handles)

    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end


%Guarda el valor de referencia en la medición
function setm0_Callback(hObject, eventdata, handles)
    
    set(handles.guinada, 'string', 0); 
    set(handles.cabeceo, 'string', 0); 
    
    set(handles.xpix, 'string', handles.PVf);            
    set(handles.ypix, 'string', handles.PHf);   

%Función para escribir posición de guiñada de referencia en la medición
function xpix_Callback(hObject, eventdata, handles)

function xpix_CreateFcn(hObject, eventdata, handles)
    
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white'); 
    end


%Función para escribir posición de cabeceo de referencia en la medición
function ypix_Callback(hObject, eventdata, handles)

function ypix_CreateFcn(hObject, eventdata, handles)

    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end

%Mide valores sucesivos del movimiento de la escala.
function medir_Callback(hObject, eventdata, handles)
    
    NI = 5;
    sum_I = 0;
    n = 5;    
    
    for i = 1 : NI
        gfile = get(handles.file, 'String');
        file = [gfile '\' num2str(i) '.bmp'];
        rgb_img = imread(file);
        I = .2989*rgb_img(:,:,1) + .5870*rgb_img(:,:,2) + .1140*rgb_img(:,:,3);
        sum_I = sum_I + (double(I)+1);
    end
    
	Ip = sum_I/(NI);%Imagen promediada
        
    %Obtengo centro Imagen
    %bvu=posición línea vertical
    %bhu=posición línea horizontal
    [bvu, bhu] = centercruz_function(Ip);
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%% LINEA HORIZONTAL DE LA CRUZ%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 	y = 1:200;
	x = 1:200;
    
    xminh = bvu - 230;
    yminh = bhu - 100;
    
    I_ch = imcrop(Ip, [xminh yminh 199 199]);%[xmin ymin width height]%
    %figure; imshow(Isf_c, [])    
    for j = 1:n
      cv = squeeze(I_ch(:, j));
      [fith, gofh] =  Fit_un_paso_Gauss_CRUZ_H(x', cv);
 
      ch = coeffvalues(fith);
      cih = confint(fith, 0.95);
 
      PH(j) = ch(2); %Posición horizontal de la gaussiana para cada corte
      IH(j) = (cih(2,2) - cih(1,2))/2; %incertidumbre para cada corte
    end

    %mdlV = LinearModel.fit(1:5, BHH); 
    %figure; plot(mdlV)
 
    %Regregresión
    %X = [ones(1,5)' (1:5)'];
    %[bv, bintv, rv, rintv] = regress(BHH', X);
    %BHHt=bv(1)+635-(k-1)*6;

    %Valor en píxles de la guiñada
    handles.PHf = sum(PH)/n + yminh;
       

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%% LINEA VERTICAL DE LA CRUZ%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

    xminv = bvu - 100;
    yminv = bhu + 30;
    I_cv = imcrop(Ip, [xminv yminv 199 199]);%[xmin ymin width height]% 
    %figure; imshow(II, [])
    
%     [fitfv, goffv] = Fit_fondo_cruz_V(x, y, II);
%     [t1,t2] = meshgrid( x,y);
%     promfit2 = fitfv( t1, t2);
%     Jv = abs(promfit2-II);
    %figure; surf(xx, yy, J); 

    for j = 1:n
        cv2 = squeeze(I_cv(j, :))'; 
        [fitv, gofv] =  Fit_un_paso_Gauss_CRUZ_V(y', cv2);
 
        cV2 = coeffvalues(fitv);
        ciV = confint(fitv, 0.95);
        
        PV(j) = cV2(2);%Posición vertical de la gaussiana para cada corte
        IV(j) = (ciV(2,2) - ciV(1,2))/2;
        
    end
    %Valor en píxeles del cabeceo
    handles.PVf = sum(PV)/n + xminv;
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%% MEDICIÓN %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %Obtengo parámetro Delta XY
    dxy = str2double(get(handles.dist_dxy, 'String'));
    
    %%%%$%%%%%% ANGULO DE CABECEO %%%%%%%
        
    refy0 = str2double(get(handles.ypix,'String'))
    medh = [(handles.PHf - refy0)*60]/dxy     
    set(handles.cabeceo, 'string', medh);
    
     %%%%$%%%%%% ANGULO DE GUIÑADA %%%%%%
    
    refx0 = str2double(get(handles.xpix,'String'))
    medv = [(handles.PVf - refx0)*60]/dxy       
    set(handles.guinada, 'string', medv);
    
%         if (h==1)
%             nah=xlsread('nivel.xlsx','B3:B53');%med nivel antihorario
%             nahref= (nah - nah(1));%referencio el nivel a la primera medición
%             xlswrite('nivel.xlsx', nahref, 1,'C3:C53');%escribo en tabla
%             xlswrite('nivel.xlsx', medh', 1,'D3:D53');%coloco medición con interfaz
%             difah = nahref + medh';%hago la diferencia entre nivel-autocolimador
%             xlswrite('nivel.xlsx', difah, 1,'E3:E53');%escribo diferencia
%             xlswrite('nivel.xlsx', medv' , 1,'I3:I53');%valores verticales
%         end  
    guidata(hObject, handles); 

%Función para escribir ángulo de Guiñada    
function guinada_Callback(hObject, eventdata, handles)

function guinada_CreateFcn(hObject, eventdata, handles)

    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end

%Función para escribir ángulo de Cabeceo 
function cabeceo_Callback(hObject, eventdata, handles)

function cabeceo_CreateFcn(hObject, eventdata, handles)

    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
