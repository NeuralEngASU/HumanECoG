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

% Last Modified by GUIDE v2.5 26-Jan-2015 12:29:51

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

handles.fileName = '';  % File Name of chosen data file
handles.pathName = '';  % Path of chosen data file
handles.fullName = '';  % The full path of the data file

handles.chans = [1:96];                           % Chanels of data
handles.numChans = length(handles.chans);         % Number of channels
handles.plotChans = [1:96];                       % The channels to plot
handles.numPlotChans = length(handles.plotChans); % The number of channels to plot

handles.numPatch = 4;               % Number of patches
handles.scale = 1;                  % Scale: 1 = 1uV, 2 = 10uV, 3=100uV, 4 = 1mV
handles.data = [];                  % Data to plot
handles.plotData = [];              % Offset data
handles.pHandle = [];               % Plot Handle
handles.time = [];                  % Time points
handles.timeVals = [0,0];           % Entered time values
handles.timeBoundCount = [36000];   % Default timeBound in samples. (1 min * 500 s/sec)
handles.timeBoundVals = [1];        % Time bound on each side of the point of interest. [Min, Sec]. Default = 1min
handles.specData = [];              % Spectrogram
handles.plotMode = 1;               % Default Mode is mono-phasic plot
handles.fs = 500;                   % 500 samples/sec (Default)

handles.zoomLevel = 1; % 1 minute either side of center
handles.panLevel = 0; % Center of plot in minutes

handles.specChan = 1;
handles.specData = [];

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ClinicianPlot wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ClinicianPlot_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;


%%%% MonoPhasicButton %%%%
function MonoPhasicButton_Callback(hObject, eventdata, handles)

% If the plot mode is not MonoPhasic, switch to MonoPhasic
if handles.plotMode ~= 1
    handles.plotMode = 1;
    set(handles.StateSTOut, 'String', 'MonoPhasic');
end % END IF
guidata(hObject, handles); % Save handles object
% END FUNCTION

%%%% BiPhasicButton %%%%
function BiPhasicButton_Callback(hObject, eventdata, handles)

% If the plot mode is not BiPhasic, switch to BiPhasic
if handles.plotMode ~= 2
    handles.plotMode = 2;
    set(handles.StateSTOut, 'String', 'BiPhasic');
end % END IF
guidata(hObject, handles);% Save handles object
% END FUNCTION

%%%% ChannelsEditText %%%%
function ChannelsET_Callback(hObject, eventdata, handles)

tmpChan = get(hObject, 'String'); % Gether data
tmpChan = strrep(tmpChan, ' ', ''); % Removes spaces

chanList = []; % Allocate variable

% If there is a dash, parse pairs
if ~isempty(regexp(tmpChan, '([0-9]+)-([0-9]+)', 'Tokens'))
    tmpPair = regexp(tmpChan, '([0-9]+)-([0-9]+)', 'Tokens'); % Extract pairs
    
    % For each pair, parse pair
    for i = 1:length(tmpPair)
        chanList = [chanList, str2double(tmpPair{i}{1}):str2double(tmpPair{i}{2})];
    end % END FOR
end % END IF

% If there are numbers, parse numbers
if ~isempty(regexp(tmpChan, '([0-9]+)', 'Tokens'))
    tmpNum = regexp(tmpChan, '([0-9]+)', 'Tokens'); % Extract numbers
    
    % For each number, parse number
    for i = 1:length(tmpNum)
        chanList = [chanList, str2double(tmpNum{i}{1})];
    end % END FOR
end % END IF

% Select the unique numbers and sort them
chanList = unique(sort(chanList, 'ascend'));

handles.chans = chanList; % Set selected channels to handles.chans
handles.numChans = length(chanList); % Find how many channels there are

guidata(hObject, handles); % Save handles object
% END FUNCTION


% ChannelsEditText Creation %
function ChannelsET_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end % END IF
% END FUNCTION


%%%% PatchEditText %%%%
function PatchET_Callback(hObject, eventdata, handles)

tmpPatch = get(hObject,'String'); % Get string

handles.numPatch = str2double(tmpPatch); % Convert string to double
guidata(hObject, handles); % Save handles object
% END FUNCTION

% PatchEditText Creation %
function PatchET_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end % END IF
% END FUCNTION

%%%% ScaleDropDown %%%%
function ScaleDD_Callback(hObject, eventdata, handles)

handles.scale = get(hObject,'Value'); % Get the value of the menu (1 through n)
guidata(hObject, handles); % Save handles object
% END FUNCTION

% ScaleDropDown Creation %
function ScaleDD_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end % END IF
% END FUCNTION

%%%% TimeEditText %%%%
function TimeET_Callback(hObject, eventdata, handles)
% ************************************
% Call a SetTime() function in order to calculate the sameples required.
% The sampling rate is loaded from the chosen file.
% ************************************

tmpText = get(hObject,'String'); % Gather string
regText =  regexp(tmpText, '([0-9]+)', 'Tokens'); % Parse numbers in string

% Save the minute time
handles.timeCount = str2double(regText{1}{1})*60*handles.fs; % Samples per minute;
handles.timeVals = [str2double(regText{1}{1})]; % Store the minute 
set(hObject, 'String', [regText{1}{1}, ':00']); % Display time in clock format

% If the user inputs minutes and seconds
if length(regText) == 2
    handles.timeCount = handles.timeCount + str2double(regText{2}{1})*handles.fs; % Samples per second
    set(hObject, 'String', [regText{1}{1}, ':', regText{2}{1}]); % Display time in clock format
    handles.timeVals(2) = [str2double(regText{2}{1})]; % Store the second
else
    handles.timeVals(2) = [0]; % If no second was entered, set second to be 0
end % END IF

% Set the TimeSlideBar default position
handles.panLevel = handles.timeCount/60/handles.fs;

handles.reLoad = 1; % Force the data to reload

guidata(hObject, handles); % Save handles obect
% END FUNCTION

% TimeEditText Creation %
function TimeET_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end % END IF
% END FUNCTION

%%%% TimeBoundEditText %%%%
function TimeBoundET_Callback(hObject, eventdata, handles)
% ************************************
% Call a SetTime() function in order to calculate the sameples required.
% The sampling rate is loaded from the chosen file.
% ************************************

tmpText = get(hObject,'String'); % Gather string
regText =  regexp(tmpText, '([0-9]+)', 'Tokens'); % Parse numbers in string

% Save the minute time
handles.timeBoundCount = str2double(regText{1}{1})*60*handles.fs; % Samples per minute;
handles.timeBoundVals = [str2double(regText{1}{1})]; % Store the minute 
set(hObject, 'String', [regText{1}{1}, ':00']);  % Display time in clock format

% If the user inputs minutes and seconds
if length(regText) == 2
    handles.timeBoundCount = handles.timeBoundCount + str2double(regText{2}{1})*handles.fs; % Samples per second
    set(hObject, 'String', [regText{1}{1}, ':', regText{2}{1}]);  % Display time in clock format
    handles.timeBoundVals(2) = [str2double(regText{2}{1})]; % Store the second 
else
    handles.timeBoundVals(2) = [0]; % If no second was entered, set second to be 0
end % END IF

handles.reLoad = 1; % Force the data to reload

guidata(hObject, handles); % Save the handles object
% END FUNCTION

% TimeBoundEditText Creation %
function TimeBoundET_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on slider movement.
function TimeSB_Callback(hObject, eventdata, handles)

handles.panLevel = get(hObject,'Value');

SetZoomPan(handles);

guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function TimeSB_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on slider movement.
function ZoomSB_Callback(hObject, eventdata, handles)
% hObject    handle to ZoomSB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

x = get(hObject,'Value');

a1 = 10.61;
b1 =  1.096;
c1 =  0.3976;

handles.zoomLevel = a1*exp(-((x-b1)/c1)^2)+0.0947;

SetZoomPan(handles);

guidata(hObject, handles);


function SetZoomPan(handles)

set(gca, 'XLim', [handles.panLevel-handles.zoomLevel, handles.panLevel+handles.zoomLevel]);

% --- Executes during object creation, after setting all properties.
function ZoomSB_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on button press in FileButton.
function FileButton_Callback(hObject, eventdata, handles)

[fileName, pathName] = uigetfile();

handles.fileName = fileName;
handles.pathName = pathName;
handles.fullNime = fullfile(pathName, fileName);

handles.reLoad = 1;

guidata(hObject, handles);
% END FUNCTION

% --- Executes on button press in UpdatePlotButton.
function UpdatePlotButton_Callback(hObject, eventdata, handles)
handles = UpdatePlot(hObject,handles);
guidata(hObject, handles);
% END FUNCTION

% --- Executes on button press in MakeSpecPB.
function MakeSpecPB_Callback(hObject, eventdata, handles)
handles = MakeSpectrogram(handles);
guidata(hObject, handles);
% END FUNCTION



function SpecChannelET_Callback(hObject, eventdata, handles)
handles.specChan = str2double(get(hObject, 'String'));
guidata(hObject, handles);
% END FUNCTION

% --- Executes during object creation, after setting all properties.
function SpecChannelET_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end % END IF
% END FUNCTION

function handles = UpdatePlot(hObject,handles)

if handles.reLoad
    handles = ChanSelect(handles);
    handles = LoadData(hObject,handles);
    handles.reLoad = 0;
end % END IF

cla
% axes(handles.plotAxis) 
hold on
numPlot = handles.numPlotChans;

% Offset Data
offset = repmat([10:10:numPlot*10]', 1, length(handles.data(1,:)));
handles.plotData = handles.data(handles.plotChans,:) + offset;

handles.time = [handles.timeCount - handles.timeBoundCount : handles.timeCount + handles.timeBoundCount];

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
        
        pData = patch(XX(j,:), YY(j,:), 1);
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

division = 1; % Have a vertical line every 60 seconds

numVert = floor((handles.time(end)-handles.time(1))/division) + 4;

for i = 1:numVert
    hold on
    
    vertBounds = [(handles.timeVals(1)-handles.timeBoundVals(1)-1) + division*i,...
                  (handles.timeVals(1)-handles.timeBoundVals(1)-1) + division*i];
    
    plot(vertBounds, [0, numPlot*10+10], 'Color', [0.5, 0.5, 0.5]);
    hold on
end % END FOR

switch handles.plotMode
    case 1
%         plot(handles.time,handles.plotData(handles.chans,:)', 'k');
        handles.pHandle = plot(handles.time,handles.plotData(:,:)', 'k');
        
        xlim([handles.time(1), handles.time(end)])
        ylim([5, handles.numPlotChans*10+5])
        
        set(gca, 'YTick', [10:10:handles.numPlotChans*10])
        set(gca, 'YTickLabel', [handles.plotChans])
        
        set(zoom(gcf),'Motion','horizontal','Enable','on');
        set(pan(gcf),'Motion','horizontal','Enable','on');
        
    case 2
        
        handles.pHandle = plot(handles.time,handles.plotData(:,:)', 'k');
        
        xlim([handles.time(1), handles.time(end)])
        ylim([5, numPlot*10+5])
        
        % Generate Y Labels
        for i = 1:handles.numPlotChans
            
            labelYAxis{i} = [num2str(handles.plotChans(i)*2-1), '-', num2str(handles.plotChans(i)*2)];
            
        end % END FOR
        
        set(gca, 'YTick', [10:10:numPlot*10])
        set(gca, 'YTickLabel', labelYAxis)
        
        set(zoom(gcf),'Motion','horizontal','Enable','on');
        set(pan(gcf),'Motion','horizontal','Enable','on');
        
    otherwise
end % END SWITCH

zoom(gcf, 10)
set(handles.TimeSB, 'Max', ((handles.timeVals(1)+handles.timeVals(2)/60) + (handles.timeBoundVals(1)+handles.timeBoundVals(2)/60)));
set(handles.TimeSB, 'Value', (handles.timeVals(1)+handles.timeVals(2)/60));
set(handles.TimeSB, 'Min', ((handles.timeVals(1)+handles.timeVals(2)/60) - (handles.timeBoundVals(1)+handles.timeBoundVals(2)/60)));

guidata(hObject, handles);
% END FUNCTION
 
function handles = LoadData(hObject, handles)

tmpChans = max(handles.chans);

dataLen = length([handles.timeCount - handles.timeBoundCount: handles.timeCount + handles.timeBoundCount]);

data = ones(tmpChans, dataLen).*repmat(sind(2*pi*(1:dataLen)), tmpChans,1) + randn(tmpChans, dataLen);

scalePos = [1000,100,10,1, 0.1];

scaleVal = scalePos(handles.scale);

handles.data = data.*scaleVal;

% if handles.plotMode == 2
%     handles.data = handles.data([1:2:tmpChans],:) - handles.data([2:2:tmpChans],:);
% end % END IF
   

guidata(hObject, handles);
% END FUNCTION

function handles = ChanSelect(handles)

if handles.plotMode == 1
    handles.plotChans = handles.chans;
    handles.numPlotChans = length(handles.chans);
else
    handles.plotChans = handles.chans;
    
    handles.plotChans(logical(mod(handles.plotChans,2))) = handles.plotChans(logical(mod(handles.plotChans,2)))+1;
    
    handles.plotChans = unique(handles.plotChans)/2;
    
    handles.numPlotChans = length(handles.plotChans);
end % END IF

% END FUNCTION


function handles = MakeSpectrogram(handles)

timeSpan = (handles.timeBoundVals(1)*60+handles.timeBoundVals(2))*2;

handles.specWindow = [2, 0.5];
handles.specparams.tapers = [1,1];
handles.specParams.Fs = 1000;
handles.specParams.Fpass = [0,500];
handles.specParams.pad = 2;

[handles.specS,handles.specT,handles.specF]=mtspecgramc(handles.data(handles.specChan,:),handles.specWindow,handles.specParams);

figure(2)
imagesc(handles.specT,handles.specF,10*log10(handles.specS)'); axis xy;

% set(gca, 'YTick', [handles.timeVals(1)-handles.timeBoundVals(1):]
cbar_axes = colorbar('peer', gca);
set(get(cbar_axes, 'ylabel'), 'String', 'Power, dB');
title(sprintf('Channel %d', handles.specChan));
xlabel('Time, sec')
ylabel('Frequency, Hz')

guidata(hObject, handles);
% END FUNCTION


% EOF



function edit8_Callback(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit8 as text
%        str2double(get(hObject,'String')) returns contents of edit8 as a double


% --- Executes during object creation, after setting all properties.
function edit8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
