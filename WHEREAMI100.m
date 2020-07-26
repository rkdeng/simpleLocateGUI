function varargout = WHEREAMI100(varargin)
% WHEREAMI100 M-file for WHEREAMI100.fig
%      WHEREAMI100, by itself, creates a new WHEREAMI100 or raises the existing
%      singleton*.
%
%      H = WHEREAMI100 returns the handle to a new WHEREAMI100 or the handle to
%      the existing singleton*.
%
%      WHEREAMI100('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in WHEREAMI100.M with the given input arguments.
%
%      WHEREAMI100('Property','Value',...) creates a new WHEREAMI100 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before WHEREAMI100_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to WHEREAMI100_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help WHEREAMI100

% Last Modified by GUIDE v2.5 23-Jul-2012 12:33:03

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @WHEREAMI100_OpeningFcn, ...
                   'gui_OutputFcn',  @WHEREAMI100_OutputFcn, ...
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


% --- Executes just before WHEREAMI100 is made visible.
function WHEREAMI100_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to WHEREAMI100 (see VARARGIN)

% Choose default command line output for WHEREAMI100
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

initialize_gui(hObject, handles)


% UIWAIT makes WHEREAMI100 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = WHEREAMI100_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in LoadDICImage_pushbutton1.
function LoadDICImage_pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to LoadDICImage_pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% load & display image, save name & path

[fname,fdir] = uigetfile({'*.tif';'*.jpg'})

fpath = sprintf('%s',fdir,fname)
h = find_figure(fname);
colormap(gray)
dic = imread(fpath);
imagesc(dic)

% initialize location variables as 0

dico = [];
dicnew = [];
tpo = [];
tpnew = [];
dicref = [];
tpref = [];


save('returns','fname','fdir','dic','dico','dicnew','tpo','tpnew','dicref','tpref')


return


% --- Executes on button press in set_landmark.
function set_landmark_Callback(hObject, eventdata, handles)
% hObject    handle to set_landmark (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% set 2p coordinates to land mark and display it on DIC image

load returns 
h = find_figure(fname);
hold on

if isempty(dico)==0
    [x,y] = getpts(gcf);
    dico = [x(1),y(1)];
    clf
    imagesc(dic)
    hold on
    plotroi(dico(1),dico(2),147.27,147.27,'g')
else
    [x,y] = getpts(gcf);
    dico = [x(1),y(1)];
    plotroi(dico(1),dico(2),147.27,147.27,'g')
end

prompt = {'Landmark under 2P X:','Landmark under 2P Y:'};
dlg_title = 'Coordinates under 2P';
num_lines = 1;
cor = inputdlg(prompt,dlg_title,num_lines)';
tpo = [str2num(cell2mat(cor(1))),str2num(cell2mat(cor(2)))];


% tex_tpox = findobj(0, 'tag', 'tex_tpox');
% set(tex_tpox, 'string', tpo(1));
% tex_tpoy = findobj(0, 'tag', 'tex_tpoy');
% set(tex_tpoy, 'string', tpo(2));

set(handles.tex_tpox, 'String', tpo(1));
set(handles.tex_tpoy, 'String', tpo(2));

save('returns','fname','fdir','dic','dico','dicnew','tpo','tpnew','dicref','tpref')

% --- Executes on button press in tp_to_dic_buttom.
function tp_to_dic_buttom_Callback(hObject, eventdata, handles)
% hObject    handle to tp_to_dic_buttom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% get DIC location from input 2p coordinates

load returns 

if isempty(tpnew)==0
    clear tpnew
end

prompt = {'CurrentLOC under 2P X:','CurrentLOC under 2P Y:'};
dlg_title = 'Coordinates under 2P';
num_lines = 1;
cor = inputdlg(prompt,dlg_title,num_lines)';
tpnew = [str2num(cell2mat(cor(1))),str2num(cell2mat(cor(2)))];

dicnew = coordi_exchange(tpo,tpnew,dico,4.04);

h = find_figure(fname);
clf
imagesc(dic)
hold on
plotroi(dico(1),dico(2),147.27,147.27,'g')  
plotroi(dicnew(1),dicnew(2),147.27,147.27,'r')
if isempty(dicref)==0
    plotroi(dicref(1),dicref(2),147.27,147.27,'b')
end

set(handles.tex_tpnewx, 'String', tpnew(1));
set(handles.tex_tpnewy, 'String', tpnew(2));

save('returns','fname','fdir','dic','dico','dicnew','tpo','tpnew','dicref','tpref')


% --- Executes on button press in dic_to_tp_buttom.
function dic_to_tp_buttom_Callback(hObject, eventdata, handles)
% hObject    handle to dic_to_tp_buttom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% get 2p location by clicking DIC image

load returns
h = find_figure(fname);
clf
imagesc(dic)
hold on
plotroi(dico(1),dico(2),147.27,147.27,'g')
if isempty(dicref)==0
    plotroi(dicref(1),dicref(2),147.27,147.27,'b')
end

if isempty(dicnew)==0
    clear dicnew
end

if isempty(tpnew)==0
    clear tpnew
end

[x,y]=getpts(gcf);
dicnew = [x(1),y(1)];

tpnew = coordi_exchange(dico,dicnew,tpo,1/4.04);

h = find_figure(fname);
clf
imagesc(dic)
hold on
plotroi(dico(1),dico(2),147.27,147.27,'g')
if isempty(dicref)==0
    plotroi(dicref(1),dicref(2),147.27,147.27,'b')
end
plotroi(dicnew(1),dicnew(2),147.27,147.27,'r')


set(handles.tex_tpnewx, 'String', tpnew(1));
set(handles.tex_tpnewy, 'String', tpnew(2));
   
save('returns','fname','fdir','dic','dico','dicnew','tpo','tpnew','dicref','tpref')



% --- Executes on button press in bye_buttom.
function bye_buttom_Callback(hObject, eventdata, handles)
% hObject    handle to bye_buttom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% exit program, with a question dialog to confirm

button = questdlg('Call it a day?');

switch button
    case 'Yes'
        load returns fname
        find_figure(fname);
        close(fname)
        close(handles.figure1)
    case 'No'
        
    case 'Cancel'

end

% --- Executes on button press in ref_buttom.
function ref_buttom_Callback(hObject, eventdata, handles)
% hObject    handle to ref_buttom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% set reference location and plot it in blue

load returns

global cb
if cb==1
    
    % set reference point by clicking, plot reference roi, calculate
    % reference 2p coordinates
    
    h = find_figure(fname);
    clf
    imagesc(dic)
    hold on
    plotroi(dico(1),dico(2),147.27,147.27,'g')
    if isempty(dicnew)==0
       plotroi(dicnew(1),dicnew(2),147.27,147.27,'r')
    end
    
    [x,y] = getpts(gcf);
    dicref = [x(1),y(1)];
    plotroi(dicref(1),dicref(2),147.27,147.27,'b')
    
    tpref = coordi_exchange(dico,dicref,tpo,1/4.04);

else
    
    % set reference point by inputting 2p coordinates, calculate DIC coordinates, plot reference roi,

    prompt = {'ReferenceLOC under 2P X:','ReferenceLOC under 2P Y:'};
    dlg_title = 'Coordinates under 2P';
    num_lines = 1;
    cor = inputdlg(prompt,dlg_title,num_lines)';
    tpref = [str2num(cell2mat(cor(1))),str2num(cell2mat(cor(2)))];
    
    dicref = coordi_exchange(tpo,tpref,dico,4.04);
    
    h = find_figure(fname);
    clf
    imagesc(dic)
    hold on
    plotroi(dico(1),dico(2),147.27,147.27,'g')
    if isempty(dicnew)==0
    plotroi(dicnew(1),dicnew(2),147.27,147.27,'r')
    end
    plotroi(dicref(1),dicref(2),147.27,147.27,'b')
    
end

set(handles.tex_tprefx, 'String', tpref(1));
set(handles.tex_tprefy, 'String', tpref(2));

save('returns','fname','fdir','dic','dico','dicnew','tpo','tpnew','dicref','tpref')


% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox1


% 'cb = 1 = by clicking' if check, 'cb = 0 = 2p coordinate input' if
% uncheck
global cb
if get(hObject,'Value')==1
    cb = 1;
else
    cb = 0;
end

function initialize_gui(hObject, handles)

% set 2p location display table as 0
% set cb as 0, for set reference checkbox, 0 means unchecked

set(handles.tex_tpox, 'String', 0);
set(handles.tex_tpoy, 'String', 0);
set(handles.tex_tpnewx, 'String', 0);
set(handles.tex_tpnewy, 'String', 0);
set(handles.tex_tprefx, 'String', 0);
set(handles.tex_tprefy, 'String', 0);
global cb
cb = 0;





% --- Executes on button press in redraw_button.
function redraw_button_Callback(hObject, eventdata, handles)
% hObject    handle to redraw_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% display DIC image, if it is close by accident

button = questdlg('Closed DIC image window by accident?');
switch button
    case 'Yes'
        load returns
        h = find_figure(fname);
        colormap(gray)
        imagesc(dic)
        hold on
        
        if isempty(dico)==0
            plotroi(dico(1),dico(2),147.27,147.27,'g')
        end
        if isempty(dicnew)==0
            plotroi(dicnew(1),dicnew(2),147.27,147.27,'r')
        end
        if isempty(dicref)==0
            plotroi(dicref(1),dicref(2),147.27,147.27,'b')
        end
    case 'No'
        
    case 'Cancel'
        
end
        



function date_edit5_Callback(hObject, eventdata, handles)
% hObject    handle to date_edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of date_edit5 as text
%        str2double(get(hObject,'String')) returns contents of date_edit5 as a double

% get input from date, return value into handles.date

date = str2double(get(hObject,'String'));

handles.date = date;
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function date_edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to date_edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function num_of_ROI_edit_Callback(hObject, eventdata, handles)
% hObject    handle to num_of_ROI_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of num_of_ROI_edit as text
%        str2double(get(hObject,'String')) returns contents of num_of_ROI_edit as a double

% get num of ROI and save it into handles.num_of_roi

num_of_roi = str2double(get(hObject,'String'));

handles.num_of_roi = num_of_roi;
guidata(hObject,handles)


% --- Executes during object creation, after setting all properties.
function num_of_ROI_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to num_of_ROI_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in save_button.
function save_button_Callback(hObject, eventdata, handles)
% hObject    handle to save_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% save location infor as .m file into ROILOC folder

load returns

cd ROILOC
eval(sprintf('save(''LOC_of_ROI%d_%08d'',''fname'',''fdir'',''dic'',''dico'',''dicnew'',''tpo'',''tpnew'',''dicref'',''tpref'')',handles.num_of_roi,handles.date))
cd ..

function plotroi(centerx,centery,xx,yy,color)

% center coordinate: centerx,centery; range of x y: xx,yy; line color

figure(gcf)
hold on
plot(centerx,centery,strcat(color,'*'))
plot(centerx-xx/2,centery-yy/2:centery+yy/2,strcat(color))
plot(centerx+xx/2,centery-yy/2:centery+yy/2,strcat(color))
plot(centerx-xx/2:centerx+xx/2,centery-yy/2,strcat(color))
plot(centerx-xx/2:centerx+xx/2,centery+yy/2,strcat(color))

function h=find_figure(figname)

h = findobj('Tag', figname); % check for pre-existing window
if(isempty(h)) % if none, make one
	h = figure('Tag', figname, 'Name', figname, 'NumberTitle', 'off');
end
figure(h)


function [ uv2 ] = coordi_exchange(xy1,xy2,uv1,mmp)

% xy1 = [x_coordinate,y_coordinate]
% xy1 corresponds to uv1, move xy1 to xy2, calculate new coordinates for uv2

% mmp = 4.04 if uv2 is DIC coordinates, mmp = 1/4.04 if uv2 is 2p
% coordinates

% 20x full frame = 595um * 595um

if xy2(1)==xy1(1)
    
    dist_sq = (xy2(1)-xy1(1))^2+(xy2(2)-xy1(2))^2;
    uv2 = [];
    uv2(1) = uv1(1);
    
    if xy2(2)>xy1(2)
        uv2(2) = -sqrt(dist_sq)/mmp+uv1(2);
    else
        uv2(2) = sqrt(dist_sq)/mmp+uv1(2);
    end
    
    % plotroi(uv2(1),uv2(2),20,20,'r')
else

    dist_sq = (xy2(1)-xy1(1))^2+(xy2(2)-xy1(2))^2;
    slop = (xy2(2)-xy1(2))/(xy2(1)-xy1(1));

    uv2 = [];

    if xy2(1)>xy1(1)
       uv2(1) = sqrt(dist_sq/(1+slop^2))/mmp+uv1(1);
    else
       uv2(1) = -sqrt(dist_sq/(1+slop^2))/mmp+uv1(1);
    end

    if xy2(2)>xy1(2)
       uv2(2) = -sqrt(slop^2*dist_sq/(slop^2+1))/mmp+uv1(2);
    else
       uv2(2) = sqrt(slop^2*dist_sq/(slop^2+1))/mmp+uv1(2);
    end

    % plotroi(uv2(1),uv2(2),20,20,'r')
end
