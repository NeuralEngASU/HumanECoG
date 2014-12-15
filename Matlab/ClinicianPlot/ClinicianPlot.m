function varargout = ClinicianPlot(varargin)
% CLINICIANPLOT MATLAB code for ClinicianPlot.fig
%      CLINICIANPLOT, by itself, creates a new CLINICIANPLOT or raises the existing
%      singleton*.
%
%      H = CLINICIANPLOT returns the handle to a new CLINICIANPLOT or the handle to
%      the existing singleton*.
%
%      CLINICIANPLOT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CLINICIANPLOT.M with the given input arguments.
%
%      CLINICIANPLOT('Property','Value',...) creates a new CLINICIANPLOT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ClinicianPlot_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ClinicianPlot_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ClinicianPlot

% Last Modified by GUIDE v2.5 14-Dec-2014 22:27:26

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ClinicianPlot_OpeningFcn, ...
                   'gui_OutputFcn',  @ClinicianPlot_OutputFcn, ...
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


% --- Executes just before ClinicianPlot is made visible.
function ClinicianPlot_OpeningFcn(hObject, eventdata, handles, varargin)
% Choose default command line output for ClinicianPlot
handles.output = hObject;

handles.chans = [1-96]; % Channels to plot
handles.numChans = length(chans); % Number of channels

handles.patchNum = 4; % Number of patches
handles.scale = 1;    % Scale: 1 = 1uV, 2 = 10uV, 3=100uV, 4 = 1mV
handles.data = []; % Data to plot
handles.specData = []; % Spectrogram
handles.plotMode = 1; % Default Mode is mono-phasic plot
handles.fs = 30000; % 30,000 samples/sec

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ClinicianPlot wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ClinicianPlot_OutputFcn(hObject, eventdata, handles) 

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in MonoPhasicButton.
function MonoPhasicButton_Callback(hObject, eventdata, handles)


% --- Executes on button press in BiPhasicButton.
function BiPhasicButton_Callback(hObject, eventdata, handles)



function ChannelsET_Callback(hObject, eventdata, handles)
% Hints: get(hObject,'String') returns contents of ChannelsET as text
%        str2double(get(hObject,'String')) returns contents of ChannelsET as a double


% --- Executes during object creation, after setting all properties.
function ChannelsET_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function PatchET_Callback(hObject, eventdata, handles)
% Hints: get(hObject,'String') returns contents of PatchET as text
%        str2double(get(hObject,'String')) returns contents of PatchET as a double


% --- Executes during object creation, after setting all properties.
function PatchET_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in ScaleDD.
function ScaleDD_Callback(hObject, eventdata, handles)
% Hints: contents = cellstr(get(hObject,'String')) returns ScaleDD contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ScaleDD


% --- Executes during object creation, after setting all properties.
function ScaleDD_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function TimeET_Callback(hObject, eventdata, handles)
% Hints: get(hObject,'String') returns contents of TimeET as text
%        str2double(get(hObject,'String')) returns contents of TimeET as a double

tmpText = get(hObject,'String');
regText =  regexp(tmpText, '([0-9]+)', 'Tokens');

handles.timeCount = str2num(regText{1}{1})*60*30000; % Samples per minute;

% If the user inputs minutes and seconds
if length(regText) == 2
    handles.timeCount = timeCount + str2num(regText{2}{1})*30000; % Samples per second
end % END IF

guidata(hObject, handles);

% END

% --- Executes during object creation, after setting all properties.
function TimeET_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in FileButton.
function FileButton_Callback(hObject, eventdata, handles)

[fileName, pathName] = uigetfile();

handles.fileName = fileName;
handles.pathName = pathName;
handles.fullNime = fullfile(pathName, fileName);

guidata(hObject, handles);
% END

function BiPhasicPlot(hObject, handles)

function MonoPhasicPlot(hObject, handles)

function UpdatePlot(hObject, handles)
