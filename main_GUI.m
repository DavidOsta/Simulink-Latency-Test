function varargout = main_GUI(varargin)
% MAIN_GUI MATLAB code for main_GUI.fig
%      MAIN_GUI, by itself, creates a new MAIN_GUI or raises the existing
%      singleton*.
%
%      H = MAIN_GUI returns the handle to a new MAIN_GUI or the handle to
%      the existing singleton*.
%
%      MAIN_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAIN_GUI.M with the given input arguments.
%
%      MAIN_GUI('Property','Value',...) creates a new MAIN_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before main_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to main_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help main_GUI

% Last Modified by GUIDE v2.5 17-Oct-2016 21:25:35

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @main_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @main_GUI_OutputFcn, ...
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


% --- Executes just before main_GUI is made visible.
function main_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to main_GUI (see VARARGIN)

% Choose default command line output for main_GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes main_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% REDUNDANT
% local_host = '127.0.0.1';
% set(handles.ip_address_edit, 'String', local_host);

% init
add_paths()


% --- Outputs from this function are returned to the command line.
function varargout = main_GUI_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in version_popup.
function version_popup_Callback(hObject, eventdata, handles)
% hObject    handle to version_popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --- Executes during object creation, after setting all properties.
function version_popup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to version_popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in ports_popup.
function ports_popup_Callback(hObject, eventdata, handles)
% hObject    handle to ports_popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function ports_popup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ports_popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in plant_radio_btn.
function plant_radio_btn_Callback(hObject, eventdata, handles)
% hObject    handle to plant_radio_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --- Executes on button press in controller_radio_btn.
function controller_radio_btn_Callback(hObject, eventdata, handles)
% hObject    handle to controller_radio_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




function ip_address_edit_Callback(hObject, eventdata, handles)
% hObject    handle to ip_address_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function ip_address_edit_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in run_button.
function run_button_Callback(hObject, eventdata, handles)

[ip_address, version,...
 ports, station] = resolve_inputs(handles);

load_base_workspace(handles)

main(ip_address, version, ports, station);


% --- Executes on button press in setup_boards_button.
function setup_boards_button_Callback(hObject, eventdata, handles)

[ip_address, version,...
 ports, station] = resolve_inputs(handles);

setup_boards(ip_address, version, ports);

% --- Executes on button press in check_ports_button.
function check_ports_button_Callback(hObject, eventdata, handles)
[ip_address, version,...
 ports, station] = resolve_inputs(handles);

test_ports(version, station, ip_address, ports);

function simulation_time_edit_Callback(hObject, eventdata, handles)
% hObject    handle to simulation_time_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes during object creation, after setting all properties.
function simulation_time_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to simulation_time_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'),...
        get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%% My Helper functions

function [ip_address, version,...
          ports, station] = resolve_inputs(handles)

% resolves - ip addres
selected_ip_address = get(handles.ip_address_edit, 'String');
% check IP address
if(regexp(selected_ip_address, '^(?:[0-9]{1,3}\.){3}[0-9]{1,3}$'))
    ip_address = selected_ip_address;
else
  ip_address = 'error';
  error('Error. \nGiven IP address, ''%s'' is not valid.', selected_ip_address)
end

% resolves - ports
ports_content =  cellstr(get(handles.ports_popup, 'String'));
selected_ports_cell = ports_content(get(handles.ports_popup, 'Value'));
ports = selected_ports_cell{:}(end);

% resolves - version
version_content =  cellstr(get(handles.version_popup, 'String'));
selected_version_cell = version_content(get(handles.version_popup, 'Value'));
version = selected_version_cell{:};

% resolves - station
if(get(handles.plant_radio_btn, 'Value') == 1) station = 'plant';
else station = 'controller'; end;



function load_base_workspace(handles)
zh_step = 0.01; % global for all ZOH
sim_run = str2double(get(handles.simulation_time_edit,'String'));
sim_warmup = 1;
assignin('base','zh_step',zh_step);
assignin('base','sim_run',sim_run);
assignin('base','sim_warmup',sim_warmup);



function add_paths()
    addpath('functions',...
            'measured_data');
    addpath(genpath('sim_models'))



