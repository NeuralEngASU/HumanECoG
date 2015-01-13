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

% Last Modified by GUIDE v2.5 12-Jan-2015 11:47:03

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

handles.fileName = '';
handles.pathName = '';
handles.fullName = '';

handles.chans = [1:96]; % Channels to plot
handles.numChans = length(handles.chans); % Number of channels

handles.numPatch = 4; % Number of patches
handles.scale = 1;    % Scale: 1 = 1uV, 2 = 10uV, 3=100uV, 4 = 1mV
handles.data = []; % Data to plot
handles.specData = []; % Spectrogram
handles.plotMode = 1; % Default Mode is mono-phasic plot
handles.fs = 100; % 30,000 samples/sec

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

if handles.plotMode ~= 1
    handles.plotMode = 1;
    set(handles.StateSTOut, 'String', 'MonoPhasic');
end % END IF
guidata(hObject, handles);

% --- Executes on button press in BiPhasicButton.
function BiPhasicButton_Callback(hObject, eventdata, handles)

if handles.plotMode ~= 2
    handles.plotMode = 2;
    set(handles.StateSTOut, 'String', 'BiPhasic');
end % END IF
guidata(hObject, handles);

function ChannelsET_Callback(hObject, eventdata, handles)
% Hints: get(hObject,'String') returns contents of ChannelsET as text
%        str2double(get(hObject,'String')) returns contents of ChannelsET as a double

tmpChan = get(hobject, 'String');

if ~isempty(regexp(tmpChan, '([0-9]+)-([0-9]+)', 'Tokens'))
    
    tmpChan = regexp(tmpChan, '([0-9]+)-([0-9]+)', 'Tokens');
    switch handles.plotMode
        case 1
            
            tmpList = [];
            for i = 1:length(tmpChan)
                tmpList = [tmpList, str2double(tmpChan{i}{1}):str2double(tmpChan{i}{2})];
            end % END FOR
            
        case 2
            
            tmpList = [];
            for i = 1:length(tmpChan)
                tmpList = [tmpList, str2double(tmpChan{i}{1}), str2double(tmpChan{i}{2})];
            end % END FOR
            
            diffList = diff(tmpList);
            diffIdx = find(diffList(1:2:end) > 1 == 1);
            
            for i = 1:length(diffIdx)
                idx = diffIdx(i);
                
            end % END FOR
            
            % Extract pairs
            % if pair is more than 1 off, then make pairs between input
                % 1-10 -> 1-2, 3-4, 5-6, 7-8, 9-10
            % List pairs as the odd component
                % 1-10 -> chans = 1,3,5,7,9
            
        otherwise
    end % END SWITCH
else     
    tmpChan = regexp(tmpChan, '([0-9]+)', 'Tokens');
    tmpList = [];
    
    for i = 1:length(tmpChan)
        tmpList(1,i) = num2str(tmpChan{i}{1});
    end % END FOR
    switch handles.ploMode
        case 1
            handles.chans = tmpList;

        case 2
            tmpList(mod(tmpList,2)~=0) =  tmpList(mod(tmpList,2)~=0) + 1;
            
            % TODO Check for duplicates
            
            tmpList = tmpList - 1;
        otherwise
    end % END SWITCH
end % END IF
guidata(hObject, handles);
% EOF

% --- Executes during object creation, after setting all properties.
function ChannelsET_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function PatchET_Callback(hObject, eventdata, handles)
% Hints: get(hObject,'String') returns contents of PatchET as text
%        str2double(get(hObject,'String')) returns contents of PatchET as a double

tmpPatch = get(hObject,'String');

handles.numPatch = str2double(tmpPatch);
guidata(hObject, handles);




% --- Executes during object creation, after setting all properties.
function PatchET_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in ScaleDD.
function ScaleDD_Callback(hObject, eventdata, handles)
% Hints: contents = cellstr(get(hObject,'String')) returns ScaleDD contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ScaleDD

handles.scale = get(hObject,'Value');
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function ScaleDD_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function TimeET_Callback(hObject, eventdata, handles)
% Hints: get(hObject,'String') returns contents of TimeET as text
%        str2double(get(hObject,'String')) returns contents of TimeET as a double

% ************************************
% Call a SetTime() function in order to calculate the sameples required.
% The sampling rate is loaded from the chosen file.
% ************************************

tmpText = get(hObject,'String');
regText =  regexp(tmpText, '([0-9]+)', 'Tokens');

handles.timeCount = str2double(regText{1}{1})*60*handles.fs; % Samples per minute;

set(hObject, 'String', [regText{1}{1}, ':00']);

% If the user inputs minutes and seconds
if length(regText) == 2
    handles.timeCount = handles.timeCount + str2double(regText{2}{1})*handles.fs; % Samples per second
    set(hObject, 'String', [regText{1}{1}, ':', regText{2}{1}]);
end % END IF

handles.reLoad = 1;

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

handles.reLoad = 1;

guidata(hObject, handles);
% END

% --- Executes on button press in UpdatePlotButton.
function UpdatePlotButton_Callback(hObject, eventdata, handles)
% hObject    handle to UpdatePlotButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

UpdatePlot(hObject,handles);
guidata(hObject, handles);
% END

function UpdatePlot(hObject,handles)

if handles.reLoad
    handles = LoadData(hObject,handles);
    handles.reLoad = 0;
end % END IF

cla
% axes(handles.plotAxis) 
hold on
numPlot = handles.numChans / handles.plotMode;
chanPlot = 1:numPlot;
% Offset Data
offset = repmat([10:10:numPlot*10]', 1, length(handles.data(1,:)));
handles.plotData = handles.data(chanPlot,:) + offset;

handles.time = [handles.timeCount - 1*60*handles.fs : handles.timeCount + 1*60*handles.fs];

handles.time = handles.time./(60*handles.fs);

% Plot pathces
elecPerPatch = floor(numPlot/handles.numPatch);
if mod(elecPerPatch,2) == 0
    YY = zeros(elecPerPatch, 4);
    
    for i = 1:handles.numPatch
        YY(i,1:4) = [elecPerPatch*(i-1)*10+5 elecPerPatch*(i-1)*10+5, elecPerPatch*i*10+5, elecPerPatch*i*10+5];
        XX(i,1:4) = [0, 1000, 1000, 0];
    end % END FOR
    
    for j = 1:handles.numPatch
        
        pData = patch(XX(j,:), 1);
        hold on
        
        set(pData, 'EdgeColor', 'none')
        if ~mod(j,2)
            set(pData, 'FaceColor', 'g')
        else
            set(pData, 'FaceColor', 'b')
        end % END IF
        set(pData, 'FaceAlpha', 0.1)
        
    end % END FOR
    hold on
end % END IF

% Plot verticial divisions

division = 30*handles.fs; % Have a vertical line every 30 seconds

numVert = floor(length(handles.time)/division);

for i = 1:numVert
    hold on
    plot([i*division, i*division], [0, numPlot*10+10], 'Color', [0.5, 0.5, 0.5]);
    hold on
end % END FOR

switch handles.plotMode
    case 1
        plot(handles.time,handles.plotData(handles.chans,:)', 'k');
        
        xlim([handles.time(1), handles.time(end)])
        ylim([5, handles.numChans*10+5])
        
        set(gca, 'YTick', [10:10:handles.numChans*10])
        set(gca, 'YTickLabel', [1:handles.numChans])
        
        set(zoom(gcf),'Motion','horizontal','Enable','on');
        set(pan(gcf),'Motion','horizontal','Enable','on');
        
    case 2
        
        plot(handles.time,handles.plotData(chanPlot,:)', 'k');
        
        xlim([handles.time(1), handles.time(end)])
        ylim([5, numPlot*10+5])
        
        % Generate Y Labels
        for i = 1:handles.numChans/2
            
            labelYAxis{i} = [num2str(handles.chans(i)*2-1), '-', num2str(handles.chans(i)*2)];
            
        end % END FOR
        
        set(gca, 'YTick', [10:10:numPlot*10])
        set(gca, 'YTickLabel', labelYAxis)
        
        set(zoom(gcf),'Motion','horizontal','Enable','on');
        set(pan(gcf),'Motion','horizontal','Enable','on');
        
    otherwise
end % END SWITCH

zoom(gcf, 10)

guidata(hObject, handles);
% END FUNCTION
 
function handles = LoadData(hObject, handles)

tmpChans = 96;

dataLen = length([handles.timeCount - 1*60*handles.fs : handles.timeCount + 1*60*handles.fs]);

data = ones(tmpChans, dataLen).*repmat(sind(2*pi*(1:dataLen)), tmpChans,1) + randn(tmpChans, dataLen);

scalePos = [1000,100,10,1];

scaleVal = scalePos(handles.scale);

handles.data = data.*scaleVal;

if handles.plotMode == 2
    handles.data = handles.data([1:2:tmpChans],:) - handles.data([2:2:tmpChans],:);
end % END IF
   

guidata(hObject, handles);
% END FUNCTION

% EOF