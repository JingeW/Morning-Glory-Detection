function varargout = main(varargin)
% MAIN MATLAB code for main.fig
%      MAIN, by itself, creates a new MAIN or raises the existing
%      singleton*.
%
%      H = MAIN returns the handle to a new MAIN or the handle to
%      the existing singleton*.
%
%      MAIN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAIN.M with the given input arguments.
%
%      MAIN('Property','Value',...) creates a new MAIN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before main_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to main_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help main

% Last Modified by GUIDE v2.5 11-Nov-2019 17:03:05

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @main_OpeningFcn, ...
                   'gui_OutputFcn',  @main_OutputFcn, ...
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
% End initialization code - DO NOT EDIT


% --- Executes just before main is made visible.
function main_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to main (see VARARGIN)

% Choose default command line output for main
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes main wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = main_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in OpenImg.
function OpenImg_Callback(hObject, eventdata, handles)
% hObject    handle to OpenImg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, pathname] = uigetfile(...
    {'*.jpg'},'File Selector');
handles.filename = strcat(pathname,'\',filename);
guidata(hObject, handles);

axes(handles.axes1)
x = imresize(imread(handles.filename),0.25);
imshow(x,[]);

handles.image_original = x;
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function parameterNumber_CreateFcn(hObject, eventdata, handles)
% hObject    handle to parameterNumber (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Segment.
function Segment_Callback(hObject, eventdata, handles)
% hObject    handle to Segment (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
S = get(handles.Dropdown,'value');
if(S == 1)
    K = str2double(get(handles.parameterNumber,'String'));
    I = handles.image_original;
    result = Km(I,K);
else
    bw = str2double(get(handles.parameterNumber,'String'));
    I = handles.image_original;
    result = Ms(I,bw);
end

axes(handles.axes1)
imshow(result);
handles.segment = result;
guidata(hObject, handles);


% --- Executes on button press in Mask.
function Mask_Callback(hObject, eventdata, handles)
% hObject    handle to Mask (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

input = handles.segment;
[m,n] = size(input(:,:,1));
Rmin = 256;
Gmin = 256;
Bmin = 256;
R = input(:,:,1);
G = input(:,:,2);
B = input(:,:,3);
for i = 1:m
    for j = 1: n
        if R(i,j) < Rmin
            Rmin = R(i,j);
        end
        if G(i,j) < Gmin
            Gmin = G(i,j);
        end
        if B(i,j) < Bmin
            Bmin = B(i,j);
        end
    end
end

output = zeros(m,n);
for i = 1:m
    for j = 1:n
        if input(i,j,1) < Rmin + 0.0001 || input(i,j,2) < Gmin + 0.0001 || input(i,j,3) < Bmin + 0.0001 
            output(i,j) = 0;
        else
            output(i,j) = 1;
        end
    end
end

x=output/255;
axes(handles.axes1)
imshow(x,[]);
handles.mask = output;
guidata(hObject, handles);


% --- Executes on button press in Output.
function Output_Callback(hObject, eventdata, handles)
% hObject    handle to Output (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
I = handles.image_original;
output = handles.mask;

for i = 1:3
    result(:,:,i) = double(I(:,:,i)).*output;
end

x=result/255;
xx=rgb2hsv(x);
H=xx(:,:,1);
axes(handles.axes1)
imshow(H,[]);
handles.result = H;
guidata(hObject, handles);


% --- Executes on button press in SaveImg.
function SaveImg_Callback(hObject, eventdata, handles)
% hObject    handle to SaveImg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, pathname] = uiputfile(...
    {'*.jpg'},'File Selector');
fullFileName = fullfile(pathname, filename);
imwrite(handles.result, fullFileName);


% --- Executes on selection change in Dropdown.
function Dropdown_Callback(hObject, eventdata, handles)
% hObject    handle to Dropdown (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
S = get(handles.Dropdown,'value');
if(S == 1)
    set(handles.parameterNumber,'String','3');
else
    set(handles.parameterNumber,'String','0.2');
end
% Hints: contents = cellstr(get(hObject,'String')) returns Dropdown contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Dropdown


% --- Executes during object creation, after setting all properties.
function Dropdown_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Dropdown (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Count.
function Count_Callback(hObject, eventdata, handles)
% hObject    handle to Count (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
b = imbinarize(handles.result,0.6);
cc = bwconncomp(b); 
num = getfield(cc,'NumObjects');
textLabel = sprintf('%d',num);
set(handles.ctNum, 'String',textLabel);
