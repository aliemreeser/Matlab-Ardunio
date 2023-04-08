function varargout = SENSOR(varargin) %Burasý matlab gui arayüzü oluþturulduðunda
                                      %otomatik olarak eklenen kýsým
                                      %Burda matlab gui ile alakalý ayarlar
                                      %yapýlýyor.
                                      
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
%Bu kýsým bizim matlab script-file dosyasý çalýþtýrýldýðýnda 
%çalýþtýrýlacak kodlarýn bulunduðu kýsým.
cla(handles.axes1);
guidata(hObject, handles);
handles.output = hObject;

guidata(hObject, handles);

function varargout = SENSOR_OutputFcn(hObject, eventdata, handles) 

varargout{1} = handles.output;

function INICIO_Callback(hObject, eventdata, handles)
%Burasý bizim Ölçümü Baþlat Butonuna bastýgýmýzda 
%iþletilecek komutlarýn oldugu kýsým.
%Kodlarýn tamamýna yakýný burada yazýlý.
%Gui arayüzüne mesafeyi yazdýrma, grafik çizme vs.

set(handles.STOP,'UserData',0);  %Ölçümü durdur butonuna basýlý deðil olarak baþlanýyor.

SerPIC = serial('COM9');         %Arduinonun baðlý oldugu port belirleniyor.
set(SerPIC,'BaudRate',9600);     %Haberleþme hýzý 9600 olarak ayarlanýyor.
set(SerPIC,'DataBits',8);
set(SerPIC,'Parity','none');
set(SerPIC,'StopBits',1);
set(SerPIC,'FlowControl','none');
fopen(SerPIC); %Port haberleþmeye açýlýyor.

global x; %x adýnda bir deðiþken tanýmlanýyor.
x=0; %x deðiþkenine ilk deðeri sýfýr olarak atanýyor.
try
    
            while (1) 
                if get(handles.STOP,'UserData')==1  
                    %Eðer ölçümü durdur butonuna basýlýrsa döngüden
                    %çýkýlýyor.
                    break 
                end
                a = fscanf(SerPIC,'%d'); %Seri porta gelen veri a deðiþkeninde tutuluyor.
                set(handles.edit1,'string',[num2str(a)]); %a deðiþkenindeki veri gui ekranýna yazdýrýlýyor.
                               
                x=x+1; %Zaman ekseninin sürekliliði için.Döngü çalýþtýkça zaman ekseni
                       %1 sn aralýklarla artacak.
                y(x)=fscanf(SerPIC,'%d'); %Seri porttan okunan veriler zamana baðlý bir fonk. tutuluyor.
                drawnow;  %Gerçek zamanlý grafik çizdirmek için gerekli komut.
                axes(handles.axes1); %Grafiðin çizileceði bileþen seçiliyor.
                plot(y,'r','linewidth',2) %Sürekli zamanlý sinyal çizdiriliyor.
                title('Zaman-Mesafe Grafiði'); %Grafiðin baþlýgý ayarlanýyor.
                xlabel('Zaman (sn)'); %Grafiðin x ekseninde yazacak yazý belirleniyor.
                ylabel('Mesafe (cm)'); %Grafiðin y ekseninde yazacak yazý belirleniyor.
                ylim([0 100]) %y ekseninin aralýðý 0-100 arasý seçiliyor.
                
                
                if (a>30) %Mesafe 30 cm den büyükse 'ÇOK UZAK' yazdýrýlýyor.
                        set(handles.distancia,'string','ÇOK UZAK')
                        else
                if ((a<30) & (a > 20)) %Mesafe 20 ile 30 arasýnda ise UZAK yazdýrýlýyor.
                    set(handles.distancia,'string','UZAK')
                                       
                else
                    if (a < 20) & (a > 10) %Mesafe 10 ile 20 cm arasýnda ise ORTA yazdýrýlýyor.
                        set(handles.distancia,'string','ORTA')
                        
                    else
                        if ((a < 10) & (a>5)) %Mesafe 5 ile 10 cm arasýnda ise YAKIN yazdýrýlýyor.
                            set(handles.distancia,'string','YAKIN')
                        else
                            if (a<=5) %Mesafe 5 cm den küçükse ÇOK YAKIN yazdýrýlýyor.
                            set(handles.distancia,'string','ÇOK YAKIN')
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
