tmpChan = '8'
tmpChan = strrep(tmpChan, ' ', ''); % Removes spaces

chanList = [];

if ~isempty(regexp(tmpChan, '([0-9]+)-([0-9]+)', 'Tokens'))
    tmpPair = regexp(tmpChan, '([0-9]+)-([0-9]+)', 'Tokens');
    
    for i = 1:length(tmpPair)
        chanList = [chanList, str2double(tmpPair{i}{1}):str2double(tmpPair{i}{2})]
    end
end

if ~isempty(regexp(tmpChan, '([0-9]+)', 'Tokens'))
        tmpNum = regexp(tmpChan, '([0-9]+)', 'Tokens');
    
    for i = 1:length(tmpNum)
        chanList = [chanList, str2double(tmpNum{i}{1})]
    end
end

chanList = unique(sort(chanList, 'ascend'))

%%
% if ~isempty(regexp(tmpChan, '([0-9]+)-([0-9]+)', 'Tokens'))
%     
%     tmpChan = regexp(tmpChan, '([0-9]+)-([0-9]+)', 'Tokens');
%     switch handles.plotMode
%         case 1
%             
%             tmpList = [];
%             for i = 1:length(tmpChan)
%                 tmpList = [tmpList, str2double(tmpChan{i}{1}):str2double(tmpChan{i}{2})];
%             end % END FOR
%             
%         case 2
%             
%             tmpList = [];
%             for i = 1:length(tmpChan)
%                 tmpList = [tmpList, str2double(tmpChan{i}{1}), str2double(tmpChan{i}{2})];
%             end % END FOR
%             
%             diffList = diff(tmpList);
%             diffIdx = find(diffList(1:2:end) > 1 == 1);
%             
%             for i = 1:length(diffIdx)
%                 idx(i) = diffList(i);
%                 
%             end % END FOR
%             
%             % Extract pairs
%             % if pair is more than 1 off, then make pairs between input
%                 % 1-10 -> 1-2, 3-4, 5-6, 7-8, 9-10
%             % List pairs as the odd component
%                 % 1-10 -> chans = 1,3,5,7,9
%             
%         otherwise
%     end % END SWITCH
% else     
%     tmpChan = regexp(tmpChan, '([0-9]+)', 'Tokens');
%     tmpList = [];
%     
%     for i = 1:length(tmpChan)
%         tmpList(1,i) = str2double(tmpChan{i}{1});
%     end % END FOR
%     switch handles.ploMode
%         case 1
%             handles.chans = tmpList;
% 
%         case 2
%             tmpList(mod(tmpList,2)~=0) =  tmpList(mod(tmpList,2)~=0) + 1;
%             
%             tmpList = unique(tmpList);
%             
%             tmpList = tmpList - 1;
%         otherwise
%     end % END SWITCH
% end % END IF
% 
% chans = tmpList