%% Setup
addpath('./export_fig-master')
mkdir('./fig') % this is helpful for users grabbing the code of GitHub

%% Data preprocessing
% Data was extracted from the Environment and Climate Change Canada 
% Real-time Hydrometric Data web site 
% (https://wateroffice.ec.gc.ca/mainmenu/real_time_data_index_e.html) on 
% Dec-22 2021.

% Create a timetable for further processing
% Source data description:
% - 11 header lines
% - 3 columns: Time, Variable ID, Variable Value
% - Variable ID = 47 means the 'Variable Value' coulmn is Discharge [m^3/s]
opts = detectImportOptions('05BB001_QR_Dec-22-2021_10_08_18PM.csv');
time_var = 'time';
qobs_var = 'discharge_m3s';
qobs_units = '[m^3 s^{-1}]';
opts.VariableNames = {time_var,'variable_id',qobs_var};
opts.SelectedVariableNames = {time_var,qobs_var}; % Don't need the var ID column
opts.DataLines = [12,Inf];

data_5min = readtimetable('05BB001_QR_Dec-22-2021_10_08_18PM.csv', opts);

% Resample 5-minute data to hourly to match paper
data_h = retime(data_5min,'hourly','mean');

%% Analysis
% Prepare for a plot that shows four things:
% 1. Original hydrograph, with estimated sigma_t values as colors
% 2. Synthetic hydrograph (original + synthetic error as per Eq. 4 in OV22), with estimated sigma_t values as colors
% 3. yt vs sigma_t plot using original hydrograph (e.g. Fig. 2 in OV22)
% 4. yt vs sigma_t plot using synthetic hydrograph (e.g. Fig. 1 in OV22)
%
% We'll use the default settings for 'k', 'tol', 'method' and 'm' during error estimation

% 1. Original hydrograph error estimation
[coef_1, Y_sig_1, Y_sig_unsorted_1, tab_1] = error_estimation(data_h.(qobs_var));

% 2. Synthetic hydrograph (original + synthetic error as per Eq. 4 in OV22)
% Create synthetic data
alpha = 0.01; beta = 0;
variance = (alpha.*data_h.(qobs_var) + beta.*mean(data_h.(qobs_var))).^2; % Eq. 4
rng_settings = rng(0); % For reproducibility
data_h.synthetic_discharge_m3s = data_h.(qobs_var) + normrnd(0,sqrt(variance));

% Error estimation
[coef_2, Y_sig_2, Y_sig_unsorted_2, tab_2] = error_estimation(data_h.synthetic_discharge_m3s);

% 3. Original hydrograph error function estimate
fit_1(:,1) = [min(tab_1(:,1)),max(tab_1(:,1))];
fit_1(:,2) = [coef_1(1)*fit_1(1,1) + coef_1(2), coef_1(1)*fit_1(2,1) + coef_1(2)];

% 4. Synthetic hydrograph error function estimate
fit_2(:,1) = [min(tab_2(:,1)),max(tab_2(:,1))];
fit_2(:,2) = [coef_2(1)*fit_2(1,1) + coef_2(2), coef_2(1)*fit_2(2,1) + coef_2(2)];
true_error = [alpha*fit_2(1,1) + beta*mean(tab_2(:,1)), alpha*fit_2(2,1) + beta*mean(tab_2(:,1))];

%% Figure 1 - 6 plots + insets
x = datenum(data_h.(time_var)(1:end-3)); % error_estimation() returns mean flow over a 4-timestep window, so we don't use the full timeseries here
xlims = [datenum('01-May-2021'), datenum('01-Oct-2021');                    % Plot: original hydrograph
         nan , nan;                                                         % Plot: sorted flows vs estimated sigma
         nan , nan;                                                         % Plot: sorted flows vs estimated sigma on double log scale
         datenum('01-May-2021'), datenum('01-Oct-2021');                    % Plot: corrupted hydrograph
         nan , nan;                                                         % Plot: sorted corrupted flows vs estimated sigma
         nan , nan;                                                         % Plot: sorted corrupted flows vs estimated sigma on double log scale
         datenum('03-Jun-2021 23:00:00'), datenum('06-Jun-2021 01:00:00');  % Plot: top inset, flow peak
         datenum('03-Jun-2021 23:00:00'), datenum('06-Jun-2021 01:00:00')]; % Plot: bottom inset, flow peak
ylims = [nan, nan;
         0  , 0.5;
         nan, nan;
         nan, nan;
         nan, nan;
         nan, nan;
         228, 240;
         228, 240];
annotate = true;
     
make_plot(x,Y_sig_unsorted_1, Y_sig_1, tab_1, fit_1, ...
            Y_sig_unsorted_2, Y_sig_2, tab_2, fit_2, alpha, beta, true_error, ...
            qobs_units, ...
            xlims, ylims, annotate, './fig/Fig1_Bow_8Plots_300dpi.png')

