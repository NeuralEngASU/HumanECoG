%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TDTMatReshape.m
%   Desc: Will extract the TDT data and save it in a new structure format
%   Author: Kevin O'Neill
%   Date: 2015.02.02
%
%   PI: Bradley Greger, PhD
%   Lab: Neural Engineering Laboratory, Arizona State University
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [] = TDTMatReshape(tdtDataPath)

tdtData = TDT2mat('');

for i = 2:7
    for j = 1:22
        
        if ~(i==7)&&(j>=18)
            eval(['tdtData.channels.C', num2str((i-1)*22+j), '= tdtData.streams.DSP', num2str(i)','.data(j,:);']);
        end
        
    end % END FOR
end % END FOR



tdtData.channels.fs = tdtData.streams.DSP2.fs;


tdtData.streams = rmfield(tdtData.streams, {'DSP2', 'DSP3','DSP4','DSP5','DSP6','DSP7'});

tdtData.mic.fs = tdtData.stream.MicA.fs;
tdtData.mic.data = tdtData.stream.MicA.data;
tdtData.mic.ts = tdtData.stream.MicA.ts;

% [char(tdtData.epocs.Mark.data)]'

tdtData.markers.data = tdtData.epocs.Mark.data;
tdtData.markers.data(tdtData.Markers.data > 127)=tdtData.Markers.data(tdtData.Markers.data > 127) - 128;

tdtData.markers.name = 'Markers';
tdtData.markers.timestamps = tdtData.epocs.Mark.onset;

tdtData.tick = tdtData.epocs.Tick;

tdtData = rmfield(tdtData, {'epocs'});

% [char(tdtData.epocs.Mark.data)]'

end % END FUNCTION

% EOF