function varargout = SENSOR(varargin) %Buras� matlab gui aray�z� olu�turuldu�unda
                                      %otomatik olarak eklenen k�s�m
                                      %Burda matlab gui ile alakal� ayarlar
                                      %yap�l�yor.
                                      
gui_Singleton = 1;                    
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @SENSOR_OpeningFcn, ...
                   'gui_OutputFcn',  @SENSOR_OutputFcn, ...
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

function SENSOR_OpeningFcn(hObject, eventdata, handles, varargin)
%Bu k�s�m bizim matlab script-file dosyas� �al��t�r�ld���nda 
%�al��t�r�lacak kodlar�n bulundu�u k�s�m.
cla(handles.axes1);
guidata(hObject, handles);
handles.output = hObject;

guidata(hObject, handles);

function varargout = SENSOR_OutputFcn(hObject, eventdata, handles) 

varargout{1} = handles.output;

function INICIO_Callback(hObject, eventdata, handles)
%Buras� bizim �l��m� Ba�lat Butonuna bast�g�m�zda 
%i�letilecek komutlar�n oldugu k�s�m.
%Kodlar�n tamam�na yak�n� burada yaz�l�.
%Gui aray�z�ne mesafeyi yazd�rma, grafik �izme vs.

set(handles.STOP,'UserData',0);  %�l��m� durdur butonuna bas�l� de�il olarak ba�lan�yor.

SerPIC = serial('COM9');         %Arduinonun ba�l� oldugu port belirleniyor.
set(SerPIC,'BaudRate',9600);     %Haberle�me h�z� 9600 olarak ayarlan�yor.
set(SerPIC,'DataBits',8);
set(SerPIC,'Parity','none');
set(SerPIC,'StopBits',1);
set(SerPIC,'FlowControl','none');
fopen(SerPIC); %Port haberle�meye a��l�yor.

global x; %x ad�nda bir de�i�ken tan�mlan�yor.
x=0; %x de�i�kenine ilk de�eri s�f�r olarak atan�yor.
try
    
            while (1) 
                if get(handles.STOP,'UserData')==1  
                    %E�er �l��m� durdur butonuna bas�l�rsa d�ng�den
                    %��k�l�yor.
                    break 
                end
                a = fscanf(SerPIC,'%d'); %Seri porta gelen veri a de�i�keninde tutuluyor.
                set(handles.edit1,'string',[num2str(a)]); %a de�i�kenindeki veri gui ekran�na yazd�r�l�yor.
                               
                x=x+1; %Zaman ekseninin s�reklili�i i�in.D�ng� �al��t�k�a zaman ekseni
                       %1 sn aral�klarla artacak.
                y(x)=fscanf(SerPIC,'%d'); %Seri porttan okunan veriler zamana ba�l� bir fonk. tutuluyor.
                drawnow;  %Ger�ek zamanl� grafik �izdirmek i�in gerekli komut.
                axes(handles.axes1); %Grafi�in �izilece�i bile�en se�iliyor.
                plot(y,'r','linewidth',2) %S�rekli zamanl� sinyal �izdiriliyor.
                title('Zaman-Mesafe Grafi�i'); %Grafi�in ba�l�g� ayarlan�yor.
                xlabel('Zaman (sn)'); %Grafi�in x ekseninde yazacak yaz� belirleniyor.
                ylabel('Mesafe (cm)'); %Grafi�in y ekseninde yazacak yaz� belirleniyor.
                ylim([0 100]) %y ekseninin aral��� 0-100 aras� se�iliyor.
                
                
                if (a>30) %Mesafe 30 cm den b�y�kse '�OK UZAK' yazd�r�l�yor.
                        set(handles.distancia,'string','�OK UZAK')
                        else
                if ((a<30) & (a > 20)) %Mesafe 20 ile 30 aras�nda ise UZAK yazd�r�l�yor.
                    set(handles.distancia,'string','UZAK')
                                       
                else
                    if (a < 20) & (a > 10) %Mesafe 10 ile 20 cm aras�nda ise ORTA yazd�r�l�yor.
                        set(handles.distancia,'string','ORTA')
                        
                    else
                        if ((a < 10) & (a>5)) %Mesafe 5 ile 10 cm aras�nda ise YAKIN yazd�r�l�yor.
                            set(handles.distancia,'string','YAKIN')
                        else
                            if (a<=5) %Mesafe 5 cm den k���kse �OK YAKIN yazd�r�l�yor.
                            set(handles.distancia,'string','�OK YAKIN')
                        else
                          
                        end
                         
                        end
                    end
                end
            end
                drawnow
                end
           
                    
 catch 
     errordlg('Bir Hata Oldu !! ','Hata') 
     end
        fclose(SerPIC); 
        delete(SerPIC) 
        clear SerPIC 

function STOP_Callback(hObject, eventdata, handles)
set(handles.STOP,'UserData',1)
set(handles.edit1,'string',0);
cla(handles.axes1);

function edit1_Callback(hObject, eventdata, handles)


function edit1_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function distancia_CreateFcn(hObject, eventdata, handles)
