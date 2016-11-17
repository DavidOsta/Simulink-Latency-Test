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

% Last Modified by GUIDE v2.5 11-Nov-2016 18:28:42

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

% init lines

add_subfolder_paths()

update_gui_listbox(handles)
set_matlab_version(handles)



% --- Outputs from this function are returned to the command line.
function varargout = main_GUI_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


%% Pop-ups

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

%% Radio buttons

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

% --- Executes on button press in config_A.
function config_A_Callback(hObject, eventdata, handles)
% hObject    handle to config_A (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of config_A

% --- Executes on button press in config_B.
function config_B_Callback(hObject, eventdata, handles)
% hObject    handle to config_B (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of config_B

%% Edit fields

function ip_address_edit_Callback(hObject, eventdata, handles)
% hObject    handle to ip_address_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function ip_address_edit_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%% Run buttons
% --- Executes on button press in run_button.
function run_button_Callback(hObject, eventdata, handles)
clc
input_resolver = InputResolver(handles, 'sim');
zh_step = input_resolver.get_zh_step();
load_base_workspace(handles, zh_step);

input_resolver.run_simulink_model();


% --- Executes on button press in run_button_real_system.
function run_button_real_system_Callback(hObject, eventdata, handles)
% hObject    handle to run_button_real_system (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc
input_resolver = InputResolver(handles, 'real');
zh_step = input_resolver.get_zh_step();
load_base_workspace(handles, zh_step);

input_resolver.run_simulink_model();


% --- Executes on button press in setup_boards_button.
function setup_boards_button_Callback(hObject, eventdata, handles)
[gui_args_struct] = resolve_inputs(handles);
setup_boards(gui_args_struct);

% --- Executes on button press in test_connection_button.
function test_connection_button_Callback(hObject, eventdata, handles)
clc
input_resolver = InputResolver(handles, 'test');
zh_step = input_resolver.get_zh_step();
load_base_workspace(handles, zh_step);
% test_delay_callback(input_resolver);
success = input_resolver.test_ports_connection();
if(success)
    input_resolver.run_simulink_model();
end


% --- Executes on button press in plot_button.
function plot_button_Callback(hObject, eventdata, handles)
% hObject    handle to plot_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%     contents = cellstr(get(handles.version_popup,'String')) % returns contents as cell array
%      % returns value of selected item from dropdown
%     contents{get(handles.version_popup,'Value')}


list_of_folders = get(handles.measured_data_listbox,'String');
selected_folder =...
    list_of_folders{get(handles.measured_data_listbox,'Value')};

plotter = Plotter(selected_folder);
plotter.plot();


% --- Executes on button press in save_data_checkbox.
function save_data_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to save_data_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of save_data_checkbox

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

% --- Executes on selection change in measured_data_listbox.
function measured_data_listbox_Callback(hObject, eventdata, handles)
% hObject    handle to measured_data_listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns measured_data_listbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from measured_data_listbox


% --- Executes during object creation, after setting all properties.
function measured_data_listbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to measured_data_listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function packet_rec_rate_Callback(hObject, eventdata, handles)
% hObject    handle to packet_rec_rate (see GCBO)
% eventdata  reserved - to be defined in a fture version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of packet_snd_rate as text
%        str2double(get(hObject,'String')) returns contents of packet_snd_rate as a double


% --- Executes during object creation, after setting all properties.
function packet_rec_rate_CreateFcn(hObject, eventdata, handles)
% hObject    handle to packet_snd_rate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function packet_send_rate_Callback(hObject, eventdata, handles)
% hObject    handle to packet_send_rate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of packet_send_rate as text
%        str2double(get(hObject,'String')) returns contents of packet_send_rate as a double


% --- Executes during object creation, after setting all properties.
function packet_send_rate_CreateFcn(hObject, eventdata, handles)
% hObject    handle to packet_send_rate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% load global parameters for simulink models
function load_base_workspace(handles, zh_step)
    %zh_step = 0.01; % global for all ZOH
    sim_run = str2double(get(handles.simulation_time_edit,'String'));
    start_packet_test = sim_run - 2; % for old model => delete
    assignin('base','zh_step',zh_step);
    assignin('base','sim_run',sim_run);
    assignin('base','start_packet_test',start_packet_test); % for old model => delete

% add paths to needed subfolders
function add_subfolder_paths()
    addpath('functions',...
            'functions/plot_functions',...
            'measured_data',...
            'classes');
    addpath(genpath('sim_models'))

% resolves matlab version argument in gui
function set_matlab_version(handles)
    matlab_version = version;
    version_name = matlab_version(end-6:end-1);

    struct_versions = struct('R2015b',1,'R2014b',2,'R2013b',3);
    fields = fieldnames(struct_versions);

    for k = 1:length(fields)
        name = fields{k};
        if(strcmp(name,version_name))
            set(handles.version_popup,'Value',struct_versions.(name));
            break;
        end
    end
