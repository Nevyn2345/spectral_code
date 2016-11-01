function varargout = simple_gui(varargin)
% SIMPLE_GUI MATLAB code for simple_gui.fig
%      SIMPLE_GUI, by itself, creates a new SIMPLE_GUI or raises the existing
%      singleton*.
%
%      H = SIMPLE_GUI returns the handle to a new SIMPLE_GUI or the handle to
%      the existing singleton*.
%
%      SIMPLE_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SIMPLE_GUI.M with the given input arguments.
%
%      SIMPLE_GUI('Property','Value',...) creates a new SIMPLE_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before simple_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to simple_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help simple_gui

% Last Modified by GUIDE v2.5 12-Jul-2016 14:23:16

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @simple_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @simple_gui_OutputFcn, ...
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


% --- Executes just before simple_gui is made visible.
function simple_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to simple_gui (see VARARGIN)

setappdata(handles.axes1, 'coordinates', 0);
setappdata(handles.axes2, 'coordinates', 0);

[filename, Path] = uigetfile('*.tif', 'Select Real File');
rpath = Path;
rfiles = LM_filelist(rpath);
[filename, Path] = uigetfile('*.tif', 'Select Spectra File', Path);
spath = Path;
sfiles = LM_filelist(spath);
sfiles = sfiles(1:size(rfiles),:);
imagesc(handles.axes1,imread(rfiles{1}))
imagesc(handles.axes2,imread(sfiles{1}))

% Choose default command line output for simple_gui
handles.output = hObject;
data = struct('rfiles',rfiles, 'sfiles',sfiles);
set(handles.slider2, 'UserData',data)
set(handles.slider2, 'min',1);
set(handles.slider2, 'max', size(rfiles,1))
set(handles.slider2, 'Value',1)
set(handles.slider2,'SliderStep', [1/size(rfiles,1), 10/size(rfiles,1)])
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes simple_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = simple_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on slider movement.
function slider2_Callback(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%files = get(hObject, 'files');
data = get(hObject, 'UserData');
val = get(hObject,'Value');
imreal = imread(data(int32(val)).rfiles);
im = imagesc(handles.axes1, imreal);
set(im, 'ButtonDownFcn', @ImageButtonDownFcn);
imspectral = imread(data(int32(val)).sfiles);
imspec = imagesc(handles.axes2, imspectral);
set(imspec, 'ButtonDownFcn', @ImageButtonDownFcn);


% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function coordinates = ImageButtonDownFcn(objectHandle, eventData, handles)
axesHandle = get(objectHandle, 'Parent');
imreal = objectHandle.CData;
coordinates = get(axesHandle, 'CurrentPoint');
coordinates = round(coordinates(1,1:2));
cut = 5;
handles = guihandles(gcf);
try
    co = getappdata(axesHandle,'coordinates');
    %co(end+1,:) = coordinates;
    c = coordinates;
    
    cutr = imreal(c(2)-cut:c(2)+cut,c(1)-cut:c(1)+cut);
%     a = sum(cutr,2);
%     xx = linspace(1,11,100);
%     cs = spline(1:11,sum(cutr,2));
%     p = ppval(cs,xx)'
%     [~,b] = max(p);
%     b = (b+10)/10
    fit = LM_fit(double(cutr));
    %[~,b] = max(cutr(:));
    %[x,y] = ind2sub(size(cutr),b);
%     tempr(1) = (c(1) - (cut+1)) + y;
%     tempr(2) = (c(2) - (cut+1)) + x;
    tempr(3) = (c(1) - (cut+1))+ fit(:,2);
    tempr(4) = (c(2) - (cut+1))+ fit(:,4);
    tempr(2) = round(get(handles.slider2, 'Value'));
    tempr(1) = size(co,1)+1;
    co(end+1,:) = tempr;
    hold on
    plot(co(:,3), co(:,4), 'ro')
%     plot(co(:,3),(c(2) - (cut+1))+ b, 'go');
    size(co,1)
    hold off
catch
    co = getappdata(axesHandle,'coordinates');
    %co(end+1,:) = coordinates;
    c = coordinates;
    
    cutr = imreal(c(2)-cut:c(2)+cut,c(1)-cut:c(1)+cut);
    fit = LM_fit(double(cutr));
    [~,b] = max(cutr(:));
    [x,y] = ind2sub(size(cutr),b);
    tempr(3) = (c(1) - (cut+1))+ fit(:,2);
    tempr(4) = (c(2) - (cut+1))+ fit(:,4);
    tempr(2) = round(get(handles.slider2, 'Value'));
    tempr(1) = size(co,1)+1;
    co = tempr;
    hold on
    plot(co(:,3), co(:,4), 'ro')
    size(co,1)
    hold off
end
setappdata(axesHandle, 'coordinates', co);
    



% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
g = getappdata(handles.axes1, 'coordinates');
gspec = getappdata(handles.axes2, 'coordinates');
save('points.mat', 'g', 'gspec');
