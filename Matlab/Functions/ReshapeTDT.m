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

tdtData.data = [tdtData.stream.DSP1.data(:,:);...
                tdtData.stream.DSP2.data(:,:);...
                tdtData.stream.DSP3.data(:,:);...
                tdtData.stream.DSP4.data(:,:);...
                tdtData.stream.DSP5.data(:,:);...
                tdtData.stream.DSP6.data(:,:);...
                tdtData.stream.DSP7.data(:,:)];
            
tdtData.Header.fs = tdtData.tdtData.stream.DSP1.fs;
tdtData.ts = tdtData.stream.DSP1.ts;

tdtData.stream = rmfield(tdtData.stream,{'DSP1', 'DSP2', 'DSP3', 'DSP4', 'DSP5', 'DSP6', 'DSP7'});

tdtData.mic.fs = tdtData.stream.MicA.fs;
tdtData.mic.data = tdtData.stream.MicA.data;
tdtData.mic.ts = tdtData.stream.MicA.ts;


save('tdtData.mat', tdtData);



end % END FUNCTION

% EOF