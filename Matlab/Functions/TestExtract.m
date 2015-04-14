sevPath = 'D:\Data\HumanECoG\20150122_P01_D01\TestBlock\xWav - 2015-01-22 15_56_20';
pathName = 'D:\Data\HumanECoG\ECoGTank';

%% Extract SEV (RS4) files
tdtData.xWav = SEV2mat(sevPath);

%% Extract Streams
tdtData.MicA = TDT2mat(pathName, 'SampleTest', 'STORE', 'MicA');
tdtData.Sync = TDT2mat(pathName, 'SampleTest', 'STORE', 'Sync');
tdtData.Mark = TDT2mat(pathName, 'SampleTest', 'STORE', 'Mark');
%% Extract all streams from TEV
tdtData = TDT2mat(pathName, 'SampleTest');

tdtData.streams.Chan.data = [tdtData.streams.DSP2.data(:,:);...
                             tdtData.streams.DSP3.data(:,:);...
                             tdtData.streams.DSP4.data(:,:);...
                             tdtData.streams.DSP5.data(:,:);...
                             tdtData.streams.DSP6.data(:,:);...
                             tdtData.streams.DSP7.data(:,:)];
                             
tdtData.streams.Chan.fs = tdtData.streams.DSP2.fs;
tdtData.streams.Chan.name = 'Chan';

tdtData.streams = rmfield(tdtData.streams, {'DSP2', 'DSP3','DSP4','DSP5','DSP6','DSP7'});

[char(tdtData.epocs.Mark.data)]'

tdtData.epocs.Mark.data(tdtData.epocs.Mark.data>127)=tdtData.epocs.Mark.data(tdtData.epocs.Mark.data>127)-128;

[char(tdtData.epocs.Mark.data)]'