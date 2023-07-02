%% Setup
addpath('./export_fig-master')
mkdir('./fig') % this is helpful for users grabbing the code of GitHub

%% Data preprocessing
% Data was extracted from the hourly observations made available by Gauch
% et al. (2020).
%
% Gauch, M., Kratzert, F., Klotz, D., Nearing, G., Lin, J., & Hochreiter, 
% S. (2020). Data for “rainfall-runoff prediction at multiple timescales 
% with a single long short-term memory network”. Zenodo. Retrieved from 
% https://doi.org/10.5281/zenodo.4072701 doi: 10.5281/zenodo.4072701

% Create a timetable for further processing
file = '02472000-usgs-hourly.csv';
opts = detectImportOptions(file);
time_var = 'date';
qobs_var = 'QObs_mm_h_';
qobs_units = '[mm \cdot h^{-1}]';
opts.SelectedVariableNames = {time_var,qobs_var};
data_h = readtimetable(file, opts);

%% Analysis
% Prepare for a plot that shows four things:
% 1. Original hydrograph, with estimated sigma_t values as colors
% 2. Synthetic hydrograph (original + synthetic error as per Eq. 4 in OV22), with estimated sigma_t values as colors
% 3. yt vs sigma_t plot using original hydrograph (e.g. Fig. 2 in OV22)
% 4. yt vs sigma_t plot using synthetic hydrograph (e.g. Fig. 1 in OV22)
%
% We'll use the default settings for 'k', 'tol', 'method' and 'm' during error estimation

% 0. Subset the data because full time series requires ~800GB memory
% Select a stretch of continuous data
plot_missing_data(data_h,qobs_var)
idxS = 307000; idxE = 316000;
data_h_sub = rmmissing(data_h(idxS:idxE,:));

% 1. Original hydrograph error estimation
[coef_1, Y_sig_1, Y_sig_unsorted_1, tab_1] = error_estimation(data_h_sub.(qobs_var));

% 2. Synthetic hydrograph (original + synthetic error as per Eq. 4 in OV22)
% Create synthetic data
alpha = 0.01; beta = 0; 
variance = (alpha.*data_h_sub.(qobs_var) + beta.*mean(data_h_sub.(qobs_var))).^2; % Eq. 4
rng_settings = rng(10); % For reproducibility
data_h_sub.synthetic_discharge = data_h_sub.(qobs_var) + normrnd(0,sqrt(variance));

% Error estimation
[coef_2, Y_sig_2, Y_sig_unsorted_2, tab_2] = error_estimation(data_h_sub.synthetic_discharge);

% 3. Original hydrograph error function estimate
fit_1(:,1) = [min(tab_1(:,1)),max(tab_1(:,1))];
fit_1(:,2) = [coef_1(1)*fit_1(1,1) + coef_1(2), coef_1(1)*fit_1(2,1) + coef_1(2)];

% 4. Synthetic hydrograph error function estimate
fit_2(:,1) = [min(tab_2(:,1)),max(tab_2(:,1))];
fit_2(:,2) = [coef_2(1)*fit_2(1,1) + coef_2(2), coef_2(1)*fit_2(2,1) + coef_2(2)];
true_error = [alpha*fit_2(1,1) + beta*mean(tab_2(:,1)), alpha*fit_2(2,1) + beta*mean(tab_2(:,1))];

%% Figure 1
x = datenum(data_h_sub.(time_var)(1:end-3)); % error_estimation() returns mean flow over a 4-timestep window, so we don't use the full timeseries here
xlims = [datenum('01-Nov-2018'), datenum('01-Jun-2019');                    % Plot: original hydrograph
         nan , nan;                                                         % Plot: sorted flows vs estimated sigma
         nan , nan;                                                         % Plot: sorted flows vs estimated sigma on double log scale
         datenum('01-Nov-2018'), datenum('01-Jun-2019');                    % Plot: corrupted hydrograph
         nan , nan;                                                         % Plot: sorted corrupted flows vs estimated sigma
         nan , nan;                                                         % Plot: sorted corrupted flows vs estimated sigma on double log scale
         datenum('30-Dec-2018 13:00:00'), datenum('31-Dec-2018 14:00:00');  % Plot: top inset, flow peak
         datenum('30-Dec-2018 13:00:00'), datenum('31-Dec-2018 14:00:00')]; % Plot: bottom inset, flow peak
ylims = [nan, nan;
         0  , 0.002;
         nan, nan;
         nan, nan;
         nan, nan;
         nan, nan;
         0.91,0.99;
         0.91,0.99];
annotate = false;

make_plot(x,Y_sig_unsorted_1, Y_sig_1, tab_1, fit_1, ...
            Y_sig_unsorted_2, Y_sig_2, tab_2, fit_2, alpha, beta, true_error, ...
            qobs_units, ...
            xlims, ylims, annotate, './fig/Fig1_Leaf_8Plots_300dpi.png')


