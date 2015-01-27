function varargout = ClinicianPlot(varargin)
% CLINICIANPLOT MATLAB code for ClinicianPlot.fig
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ClinicianPlot

% Last Modified by GUIDE v2.5 27-Jan-2015 15:36:40

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


%%%% Initialization of Vairables %%%%
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
% END FUNCTION

% Output commands to command line %
function varargout = ClinicianPlot_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;
% END FUNCTION

%%%% MonoPhasicButton %%%%
function MonoPhasicButton_Callback(hObject, eventdata, handles)
% If the plot mode is not MonoPhasic, switch to MonoPhasic
if handles.plotMode ~= 1
    handles.plotMode = 1;
    set(handles.StateSTOut, 'String', 'MonoPhasic');
    handles.reLoad = 1;
end % END IF
guidata(hObject, handles); % Save handles object
% END FUNCTION

%%%% BiPhasicButton %%%%
function BiPhasicButton_Callback(hObject, eventdata, handles)
% If the plot mode is not BiPhasic, switch to BiPhasic
if handles.plotMode ~= 2
    handles.plotMode = 2;
    set(handles.StateSTOut, 'String', 'BiPhasic');
    handles.reLoad = 1;
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
    
    % For each number, parse
    for i = 1:length(tmpNum)
        chanList = [chanList, str2double(tmpNum{i}{1})];
    end % END FOR
end % END IF

% Select the unique numbers and sort them
chanList = unique(sort(chanList, 'ascend'));

handles.chans = chanList; % Set selected channels to handles.chans
handles.numChans = length(chanList); % Find how many channels there are
handles.reLoad = 1;

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
handles.reLoad = 1;
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
end % END IF
% END FUNCTION

%%%% Time Slide Bar %%%%
function TimeSB_Callback(hObject, eventdata, handles)
handles.panLevel = get(hObject,'Value');  % Get the slide bar value
SetZoomPan(handles); % Move the plot figure
guidata(hObject, handles); % Save the handles object
% END FUNCTION

% Time Slide Bar Creation Function %
function TimeSB_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

%%%% Zoom Slide Bar %%%%
function ZoomSB_Callback(hObject, eventdata, handles)
x = get(hObject,'Value'); % Get slide bar value

% Gaussian fit coefficients
a1 = 10.61;
b1 =  1.096;
c1 =  0.3976;

handles.zoomLevel = a1*exp(-((x-b1)/c1)^2)+0.0947; % Zoom equation
SetZoomPan(handles); % Scale the plot figure

guidata(hObject, handles); % Save the handles object
% END FUNCTION

% Zoom Slide Bar Creation Function %
function ZoomSB_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end % END IF
% END FUNCTION 

%%%% Set Zoom and Pan %%%%
function SetZoomPan(handles)
% Sets the figure's zoom and pan
set(gca, 'XLim', [handles.panLevel-handles.zoomLevel, handles.panLevel+handles.zoomLevel]);
% END FUNCTION

%%%% Load File Button %%%%
function FileButton_Callback(hObject, eventdata, handles)

[fileName, pathName] = uigetfile();

handles.fileName = fileName;
handles.pathName = pathName;
handles.fullName = fullfile(pathName, fileName);

set(handles.FileButton, 'String', handles.fileName);

handles.reLoad = 1;

guidata(hObject, handles);
% END FUNCTION

%%%% Update Plot Button %%%%
function UpdatePlotButton_Callback(hObject, eventdata, handles)
handles = UpdatePlot(hObject,handles); % Calls the update plot function
guidata(hObject, handles);
% END FUNCTION

%%%% Make Spectrogram Button %%%%
function MakeSpecPB_Callback(hObject, eventdata, handles)
handles = MakeSpectrogram(handles); % Calls the make spectrogram function
guidata(hObject, handles);
% END FUNCTION

%%%% Spectrogram Edit Text %%%%
function SpecChannelET_Callback(hObject, eventdata, handles)
handles.specChan = str2double(get(hObject, 'String')); % Gather the inputted number
guidata(hObject, handles);
% END FUNCTION

% Spectrogram Edit Text Creation Function %
function SpecChannelET_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end % END IF
% END FUNCTION

%%%% Update Plot - Updates the main figure %%%%
function handles = UpdatePlot(hObject,handles)

% If we need to reload the data, reload the data
if handles.reLoad
    handles = ChanSelect(handles);
    handles = LoadData(hObject,handles);
    handles.reLoad = 0;
end % END IF

cla; % Clear axis
hold on
numPlot = handles.numPlotChans; % Temporary variable for the number of channels to plot

% Offset Data
offset = repmat([10:10:numPlot*10]', 1, length(handles.data(1,:)));
handles.plotData = handles.data(handles.plotChans,:) + offset;

handles.time = [handles.timeCount - handles.timeBoundCount : handles.timeCount + handles.timeBoundCount];

handles.time = handles.time./(60*handles.fs);

% Plot pathces
if handles.numPatch > 0
    
    % Calculate the number of electrodes contained in each patch
    elecPerPatch = floor(numPlot/handles.numPatch); 
   
    YY = zeros(elecPerPatch, 4); % Allocate variable 
    
    % For each patch (plus one extra) generate limits of patch
    for i = 1:handles.numPatch + 1
        YY(i,1:4) = [elecPerPatch*(i-1)*10+5,...  % Min Y
                     elecPerPatch*(i-1)*10+5,...  % Min Y
                     elecPerPatch*i*10+5,...      % Max Y
                     elecPerPatch*i*10+5];        % Max Y
                 
        XX(i,1:4) = [handles.timeVals(1)-handles.timeBoundVals(1)-2,... % Min X
                     handles.timeVals(1)+handles.timeBoundVals(1)+2,... % Max X
                     handles.timeVals(1)+handles.timeBoundVals(1)+2,... % Max X
                     handles.timeVals(1)-handles.timeBoundVals(1)-2];   % Min X
    
    end % END FOR
    
    YY(i,1:4) = [elecPerPatch*(i-1)*10+5,... % Max Y
                 elecPerPatch*(i-1)*10+5,... % Max Y
                 elecPerPatch*i*50,...       % Min Y
                 elecPerPatch*i*50];         % Min Y
    
    % For each patch, plot
    for j = 1:handles.numPatch + 1
        
        % Plot Patch
        pData = patch(XX(j,:), YY(j,:), 1);
        hold on
        
        set(pData, 'EdgeColor', 'none'); % Remove edge
        set(pData, 'FaceAlpha', 0.25); % Set alpha
        
        % Change color depending on the patch number
        if ~mod(j,2)
            set(pData, 'FaceColor', 'g')
        else
            set(pData, 'FaceColor', 'b')
        end % END IF
    end % END FOR
    hold on
end % END IF

% Plot verticial divisions
division = 1; % Have a vertical line every 60 seconds

% Calculate the number of vertical lines needed
numVert = floor((handles.time(end)-handles.time(1))/division) + 4;

% For each vertical line, generate the bounds and plot
for i = 1:numVert
    hold on
    
    % Vertical bounds are set for every 60 seconds
    vertBounds = [(handles.timeVals(1)-handles.timeBoundVals(1)-2) + division*i,...
                  (handles.timeVals(1)-handles.timeBoundVals(1)-2) + division*i];
    
    % Plot each vertical line
    plot(vertBounds, [0, numPlot*10+10], 'Color', [0.5, 0.5, 0.5]);
    hold on
end % END FOR

% Switch plotting based on plotMode
switch handles.plotMode
    case 1 % MonoPhasic
        handles.pHandle = plot(handles.time,handles.plotData(:,:)', 'k'); % Plot data
        
        % Set limits
        xlim([handles.time(1), handles.time(end)]) 
        ylim([5, handles.numPlotChans*10+5])
        
        % Set Y tick and label
        set(gca, 'YTick', [10:10:handles.numPlotChans*10])
        set(gca, 'YTickLabel', [handles.plotChans])
        
    case 2 % BiPhasic
        handles.pHandle = plot(handles.time,handles.plotData(:,:)', 'k'); % Plot data
        
        % Set limits
        xlim([handles.time(1), handles.time(end)])
        ylim([5, numPlot*10+5])
        
        % Generate Y Labels
        for i = 1:handles.numPlotChans
            labelYAxis{i} = [num2str(handles.plotChans(i)*2-1), '-', num2str(handles.plotChans(i)*2)];
        end % END FOR
        
        % Set Y tick and label
        set(gca, 'YTick', [10:10:numPlot*10])
        set(gca, 'YTickLabel', labelYAxis)
    otherwise
end % END SWITCH

% Enable zoom and pan
set(zoom(gcf),'Motion','horizontal','Enable','on');
set(pan(gcf),'Motion','horizontal','Enable','on');

SetZoomPan(handles);

% Set the slide bar limits and value
set(handles.TimeSB, 'Max', ((handles.timeVals(1)+handles.timeVals(2)/60) + (handles.timeBoundVals(1)+handles.timeBoundVals(2)/60)));
set(handles.TimeSB, 'Value', (handles.timeVals(1)+handles.timeVals(2)/60));
set(handles.TimeSB, 'Min', ((handles.timeVals(1)+handles.timeVals(2)/60) - (handles.timeBoundVals(1)+handles.timeBoundVals(2)/60)));

guidata(hObject, handles);
% END FUNCTION
 
%%%% Load Data %%%% Currently setup for temporary data
function handles = LoadData(hObject, handles)

tmpChans = max(handles.chans)+mod(max(handles.chans),2);

dataLen = length([handles.timeCount - handles.timeBoundCount: handles.timeCount + handles.timeBoundCount]);

data = ones(tmpChans, dataLen).*repmat(sin(pi*350*(1:dataLen)./handles.fs), tmpChans,1) + randn(tmpChans, dataLen)/2;

if handles.plotMode == 2
    data = data([1:2:tmpChans],:) - data([2:2:tmpChans],:);
end % END IF

scalePos = [1000,100,10,1, 0.1];
scaleVal = scalePos(handles.scale);
handles.data = data.*scaleVal;

guidata(hObject, handles);
% END FUNCTION

%%%% Channel Select %%%% Remap the selected channels based on the chosen mode
function handles = ChanSelect(handles)

% If MonoPhasic was chosen
if handles.plotMode == 1
    handles.plotChans = handles.chans;
    handles.numPlotChans = length(handles.chans);
else % If BiPhasic was chosen
    handles.plotChans = handles.chans;
    
    % Force all odd channels to be even channels
    handles.plotChans(logical(mod(handles.plotChans,2))) = handles.plotChans(logical(mod(handles.plotChans,2)))+1;
    
    % Gather the selected channels, but neglect repeats
    handles.plotChans = unique(handles.plotChans)/2;
    
    % Number of plots to plot
    handles.numPlotChans = length(handles.plotChans);
end % END IF
% END FUNCTION

%%%% Make Multi-Taper Spectrogram %%%%
function handles = MakeSpectrogram(handles)

% Window size and overlap
handles.specWindow = [1.5, 0.5];

% MT-Spectrogram params
handles.specParams.tapers = [3,5];  % Tapers
handles.specParams.Fs = 1000;       % Fs
handles.specParams.Fpass = [0,500]; % Fpass
handles.specParams.pad = 2;         % Padding (next,nextpow2)

% Testing Chirp data
% chirpData = chirp(0:0.001:10*60, 0, 60*10, 500);

% Choosing the correct channel (depends on plotMode)
if handles.plotMode == 1
    handles.specChanPlot = handles.specChan;
elseif handles.plotMode == 2
    handles.specChanPlot = (handles.specChan + mod(handles.specChan,2))/2; % Forces the channel to be even, then divide by 2
end % END IF

% Calculates the multi-taper spectrogram
[handles.specS,handles.specT,handles.specF]=mtspecgramc(handles.data(handles.specChanPlot,:),handles.specWindow,handles.specParams);
% [handles.specS,handles.specT,handles.specF]=mtspecgramc(chirpData,handles.specWindow,handles.specParams);

figure(2)  % Open a new figure window

% Create a time vector corrosponding to the desired time bound
specTime = linspace(handles.timeCount - handles.timeBoundCount,...
                    handles.timeCount + handles.timeBoundCount, length(handles.specT));

% Display the spectrogram
imagesc(specTime./(handles.fs*60),handles.specF,10*log10(handles.specS)'); 
axis xy;

cbar_axes = colorbar('peer', gca); % Display colorbar
set(get(cbar_axes, 'ylabel'), 'String', 'Power, dB'); % Colorbar title

% Display the correct channel information based on plotMode
if handles.plotMode == 1
    title(sprintf('Channel %d', handles.specChan)); % Plot Title
elseif handles.plotMode == 2
    title(sprintf('Channel %d-%d', handles.specChanPlot*2-1, handles.specChanPlot*2)); % Plot Title
end % END IF

xlabel('Time, min') % Time label
ylabel('Frequency, Hz') % Frequency label

% Time offset
timeOffset = [handles.timeVals(1)-handles.timeBoundVals(1)-1, handles.timeVals(1)+handles.timeBoundVals(1)+1];

% Set tick and tick label
set(gca, 'XTick', [timeOffset(1):1:timeOffset(2)]);
set(gca, 'XTickLabel', [timeOffset(1):1:timeOffset(2)]);
% END FUNCTION

% EOF
