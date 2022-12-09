function plot_missing_data(TT,var)
%plot_missing_data Plots data in TT.var, indicating missing values in red
%   Inputs
%   - TT: TimeTable 
%   - var: variable name of variable of interest in TT

% Find location(s) of missing values
idx_mis = find(isnan(TT.(var)));

% Determine Y-location of missing data lines
ymin = min(TT.(var));
ymax = max(TT.(var));

% Plot
figure; hold on;
plot(TT.(var))
if ~isempty(idx_mis)
    plot([idx_mis,idx_mis],[ymin,ymax],'r')
end
end

