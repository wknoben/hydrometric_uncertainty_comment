function [TT_out] = keep_longest_continuous_record(TT,time,time_diff)
%keep_longest_continuous_record Keeps the longest non-missing stretch of
%'var' in 'TT'
%   Inputs
%   - TT: TimeTable witha date/time column and exactly one other column
%   - time: variable name of the date/time column in TT
%   - var: variable name of variable of interest in TT
%   - time_diff: expected time difference as string, e.g. '01:00:00'
%
%   Output
%   - TT_out: new TImeTable subset based on available data in 'var'

% Remove missing data
TT_tmp = rmmissing(TT);

% Compute time difference between entries
TT_tmp.time_diff = [0; diff(TT_tmp.(time))]; 

% Compute continuous record length
TT_tmp.recordLength = zeros(length(TT_tmp.time_diff),1);
rl = 1; % Record Length
for i = 1:length(TT_tmp.time_diff)
    % First entry: special case because timeDiff == 00:00:00
    if i == 1
        TT_tmp.recordLength(i) = rl; % First entry
        rl = rl+1; % Update current record length
        continue
    end
    % Not first entry: check record length
    if TT_tmp.time_diff(i) ~= time_diff
        % We removed a record here, so reset the record length counter
        rl = 1;
    end
    
    % Not first entry: add record length counter
    TT_tmp.recordLength(i) = rl;
    rl = rl+1;
end

% Subset the timetable to keep the longest record
[val,last_idx] = max(TT_tmp.recordLength);
first_idx = last_idx-val+1;
TT_out = TT_tmp(first_idx:last_idx,:);

end

