% Bi-Phasic Data Plot


%% TODO
    % Plot
    % Constrain y axis zoom
    % Background Patches
    % Vertical Deliminators
    % Scaling

%% Test Plot

numChans = 96;

data = ones(numChans, 1000).*repmat(sind(2*pi*(1:1000)), numChans,1) + randn(numChans, 1000);

% Generate Bi-Phasic data
for i = 1:numChans/2
    
    dataBi(i,:) = data((i*2-1) ,:) - data( (i*2),:);
    
end % END FOR

offset = repmat([10:10:numChans/2*10]', 1, 1000);

dataOff = dataBi + offset;

%% Plot Patch

numPatch = 8;

elecPerPatch = numChans/2/numPatch;

YY = zeros(elecPerPatch, 4);

for i = 1:numPatch
    
    YY(i,1:4) = [elecPerPatch*(i-1)*10+5 elecPerPatch*(i-1)*10+5, elecPerPatch*i*10+5, elecPerPatch*i*10+5];
    XX(i,1:4) = [0, 1000, 1000, 0];
end % END FOR

for j = 1:numPatch
    
    pData = patch(XX(j,:), YY(j,:), 1);
    
    set(pData, 'EdgeColor', 'none')
    if ~mod(j,2)
        set(pData, 'FaceColor', 'g')
    else
        set(pData, 'FaceColor', 'b')
    end % END IF
    set(pData, 'FaceAlpha', 0.1)

end % END FOR

hold on

%% Plot Vertical lines

division = 200; % Every '30 seconds'

time = 1:1000;

numVert = floor(length(time)/division);

for i = 1:numVert
    
    plot([i*division, i*division], [0, numChans/2*10+10], 'Color', [0.5, 0.5, 0.5]);

end % END FOR

%% Plot Data
plot(1:1000,dataOff', 'k');

xlim([0, 1000])
ylim([5, numChans/2*10+5])

% Generate Y Labels
for i = 1:numChans/2
    
    labelYAxis{i} = [num2str(i*2-1), '-', num2str(i*2)];
    
end % END FOR

set(gca, 'YTick', [10:10:numChans/2*10])
set(gca, 'YTickLabel', labelYAxis)

set(zoom(gcf),'Motion','horizontal','Enable','on');
set(pan(gcf),'Motion','horizontal','Enable','on');



% EOF