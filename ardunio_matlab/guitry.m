function varargout = guitry(varargin)


gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @guitry_OpeningFcn, ...
                   'gui_OutputFcn',  @guitry_OutputFcn, ...
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

function guitry_OpeningFcn(hObject, eventdata, handles, varargin)

handles.output = hObject;
guidata(hObject, handles);
cla(handles.axes1);
guidata(hObject, handles);
function varargout = guitry_OutputFcn(hObject, eventdata, handles) 

varargout{1} = handles.output;



function startbutton_Callback(hObject, eventdata, handles)

set(handles.stopbutton,'UserData',0);                             

 ard = serial('COM3');                                        
set(ard,'BaudRate',9600);                                     
set(ard,'DataBits',8);
set(ard,'Parity','none');
set(ard,'StopBits',1);
set(ard,'FlowControl','none');
fopen(ard);                                                    

global x;                                        
x=0;                                                  
try
    
            while (1) 
                if get(handles.stopbutton,'UserData')==1  
                    break
                                                                  
                    
                end
                a = fscanf(ard,'%uint8');                   %ardunio verilerini a değişkenine atadık                     
                set(handles.edit1,'string',[num2str(a)]);   %sayıları karakter arrayine dönüştürü string içine yazmak için kullandık               
                               
                x=x+1;                                      %sayı ekseni her loopta artırıldı       
                                                                   
                
                y(x)=a;
                drawnow;                                    %eş zamanlı grafik çizimi için         
                axes(handles.axes1);                        %çizilecek grafiği gui arayüzündeki axes1'e tanımladık        
                plot(y,'r','linewidth',2)                   %kırmızı ve çizgi kalınlığı             
                title('Zaman-Mesafe Grafiği');                            
                xlabel('Zaman (sn)');                                     
                ylabel('Mesafe (cm)');                                        
                ylim([0 100])                                              
                
                

                drawnow
                end
           
                    
catch                                                  %try catch ile hata penceresi oluşturduk
     errordlg('ERROR!! ','Error') 
     end
        fclose(ard); 
        delete(ard) 
        clear SerPIC 


function stopbutton_Callback(hObject, eventdata, handles)

set(handles.stopbutton,'UserData',1)                             %stop butonu aktive ediliyor
set(handles.edit1,'string',0);
cla(handles.axes1);


function edit1_Callback(hObject, eventdata, handles)

function edit1_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
