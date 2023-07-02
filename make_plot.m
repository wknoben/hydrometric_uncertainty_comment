function make_plot(x, Y_sig_unsorted_ori, Y_sig_ori, tab_ori, fit_ori, ...
                      Y_sig_unsorted_syn, Y_sig_syn, tab_syn, fit_syn, ...
                      a,b, true_error, ...
                      units, ...
                      xlims, ylims, ...
                      annotate,...
                      save_here)

% INPUTS
%
% For both []_ori and []_syn suffix:
% Y_sig_unsorted:   unsorted outcomes of error estimation [n,2], [mean flows, errors]
% Y_sig:            outcomes of error estimation [n,2], [mean flows, errors]
% tab:              outcomes of moving window error estimation [n,2], [mean flows, errors]
% fit:              outcomes of error fit [1,2]
%
% a:                alpha value of synthetic errors
% b:                beta value of synthetic errors
% true_error:       fit of the true error model
%
% units:            string with observation and error units
% xlims:            x-limits for all plots (nan uses default values)
% ylims:            x-limits for all plots (nan uses default values)
% annotate:         add annotation arrows for the Bow case (1), or not (0)
% save_here:        full path to where to save the file

% Settings
hyd_col = [0.00, 0.45, 0.74];   % Color scheme for the hydrographs
err_col = [0.85, 0.33, 0.10];   % Color scheme for error series
dot_col = [0.7, 0.7, 0.7];      % Dot color in y/sigma plots
dot_size = 7;                   % Dot size in y/sigma plots
fs = 14;                        % fontsize

% Main figure settings
fh = figure('color','w');
fh.Position = 1.0e+03.*[-3.0702   -0.0190    1.2784    1.3168];

% Subplot settings
nx = 2; ny = 5;

% Inset settings - needed to draw the boxes on plots 1 and 4
inx1 = [xlims(7,1),xlims(7,2),xlims(7,2),xlims(7,1),xlims(7,1)];
iny1 = [ylims(7,1),ylims(7,1),ylims(7,2),ylims(7,2),ylims(7,1)];
inx2 = [xlims(8,1),xlims(8,2),xlims(8,2),xlims(8,1),xlims(8,1)];
iny2 = [ylims(8,1),ylims(8,1),ylims(8,2),ylims(8,2),ylims(8,1)];

% construct the label strings
string_yt = "$\tilde{y}_t~" + units + "$";
string_st = "$\hat{\sigma}_t~" + units + "$";
string_ori = {'Real hydrograph', '(a) Step 1: Estimate errors at each time step'};
string_syn = {"Hydrograph with synthetic errors (\alpha = "+a+", \beta = "+b+")", '(a) Step 1: Estimate errors at time each step'};

% 1. Original hydrograph, with estimated sigma_t values on second Y
s1 = subplot(ny,nx,(1:2));
    yyaxis left
        hold on;
        plot(x,Y_sig_unsorted_ori(:,1),'linewidth',2,'color',hyd_col)       % data
        plot(inx1,iny1,'-r')                                                % inset box
        xlabel('$time~[h]$','Interpreter','LaTeX','fontsize',fs);
        ylabel(string_yt,'Interpreter','LaTeX','fontsize',fs);
        datetick('x','mmm');%,'keepticks');
        %title('(a) Step 1: Estimate errors at each step','fontsize',fs);
        title(string_ori,'fontsize',fs)
    yyaxis right
        plot(x,Y_sig_unsorted_ori(:,2),'color',err_col)
        ylabel(string_st,'Interpreter','LaTeX','fontsize',fs);
        box on
        
% 2. yt vs sigma_t plot using original hydrograph
s2 = subplot(ny,nx,3);
    hold on;
    scatter(Y_sig_ori(:,1),Y_sig_ori(:,2),dot_size,dot_col,'filled')
    scatter(tab_ori(:,1),tab_ori(:,2),'sb')
    plot(fit_ori(:,1),fit_ori(:,2),'k','linewidth',2)
    l1 = legend('Data pair','Moving average of error estimate','Estimated error function',...
        'Location','SouthOutside','Orientation','horizontal','fontsize',fs);
    box on;
    xlabel(string_yt,'Interpreter','LaTeX','fontsize',fs);
    ylabel(string_st,'Interpreter','LaTeX','fontsize',fs);
    title('(b) Step 2: Smoothed error estimates','fontsize',fs);
    grid on    
   
% 3. yt vs sigma_t plot using original hydrograph - LOG SCALE
s3 = subplot(ny,nx,4);
    hold on;
    scatter(Y_sig_ori(:,1),Y_sig_ori(:,2),dot_size,dot_col,'filled')
    scatter(tab_ori(:,1),tab_ori(:,2),'sb')
    plot(fit_ori(:,1),fit_ori(:,2),'k','linewidth',2)
    box on;
    xlabel(string_yt,'Interpreter','LaTeX','fontsize',fs);
    ylabel(string_st,'Interpreter','LaTeX','fontsize',fs);
    title('(c) Step 2: Smoothed error estimates - log scale','fontsize',fs);
    grid on       
    set(gca, 'XScale','log','YScale','log')

% 4. Synthetic hydrograph, with estimated sigma_t values as colors
s4 = subplot(ny,nx,(5:6));
    yyaxis left
        hold on;
        plot(x,Y_sig_unsorted_syn(:,1),'linewidth',2,'color',hyd_col)
        plot(inx2,iny2,'-r')
        xlabel('$time~[h]$','Interpreter','LaTeX','fontsize',fs);
        ylabel(string_yt,'Interpreter','LaTeX','fontsize',fs);
        datetick('x','mmm');%,'keepticks');
        title(string_syn,'fontsize',fs);
    yyaxis right
        plot(x,Y_sig_unsorted_syn(:,2),'color',err_col)
        ylabel(string_st,'Interpreter','LaTeX','fontsize',fs);
        box on

% 5. yt vs sigma_t plot using synthetic hydrograph
s5 = subplot(ny,nx,7);
    hold on;
    scatter(Y_sig_syn(:,1),Y_sig_syn(:,2),dot_size,dot_col,'filled')
    scatter(tab_syn(:,1),tab_syn(:,2),'sb')
    plot(fit_syn(:,1),fit_syn(:,2),'k','linewidth',2)
    plot(fit_syn(:,1),true_error,'--r','linewidth',2)
    l2 = legend('Data pair','Moving average of error estimate','Estimated error function','True error function',...
        'Location','SouthOutside','Orientation','horizontal','fontsize',fs);
    box on;
    xlabel(string_yt,'Interpreter','LaTeX','fontsize',fs);
    ylabel(string_st,'Interpreter','LaTeX','fontsize',fs);
    title('(b) Step 2: Smoothed error estimates','fontsize',fs);
    grid on

% 6. yt vs sigma_t plot using synthetic hydrograph - LOG SCALE
s6 = subplot(ny,nx,8);
    hold on;
    scatter(Y_sig_syn(:,1),Y_sig_syn(:,2),dot_size,dot_col,'filled')
    scatter(tab_syn(:,1),tab_syn(:,2),'sb')
    plot(fit_syn(:,1),fit_syn(:,2),'k','linewidth',2)
    plot(fit_syn(:,1),true_error,'--r','linewidth',2)
    box on;
    xlabel(string_yt,'Interpreter','LaTeX','fontsize',fs);
    ylabel(string_st,'Interpreter','LaTeX','fontsize',fs);
    title('(c) Step 2: Smoothed error estimates - log scale','fontsize',fs);
    set(gca, 'XScale','log','YScale','log')
    grid on

% Match the y-limits
% We need this because the original hydrograph has various cases where Qobs
% remains at identical values for several timesteps, and this leads to tiny
% (10^-17 or so) sigma estimates
s3.YLim = s6.YLim;

% Create the in-sets for (a) and (c)
s7 = subplot(ny,nx,9);
    hold on; % Needed because without it we get a white background
    plot(x, Y_sig_unsorted_ori(:,1),'color',hyd_col,'marker','o');
    %scatter(x, Y_sig_unsorted_ori(:,1), sub_size, Y_sig_unsorted_ori(:,2), 'filled')
    plot(inx1,iny1,'-r')
    plot(x,Y_sig_unsorted_ori(:,2),'color',err_col)
    box on; xticklabels([]); %yticklabels([]);
s8 = subplot(ny,nx,10);
    hold on; % Needed because without it we get a white background
    plot(x, Y_sig_unsorted_ori(:,1),'color',dot_col);
    plot(x, Y_sig_unsorted_syn(:,1),'color',hyd_col,'marker','o')
    %scatter(x, Y_sig_unsorted_syn(:,1), sub_size, Y_sig_unsorted_syn(:,2), 'filled')
    plot(inx2,iny2,'-r')
    legend('Original','Synthetic','Location','NorthWest')
    box on; xticklabels([]); % Keep only the Y-ticks for clarity  
 
% Update Y-limits
for i = 1:8
    h = eval("s"+i); % grab the subplot handle
    if ~isnan(xlims(i,1)); h.XLim(1) = xlims(i,1); end
    if ~isnan(xlims(i,2)); h.XLim(2) = xlims(i,2); end
    if ~isnan(ylims(i,1)); h.YLim(1) = ylims(i,1); end
    if ~isnan(ylims(i,2)); h.YLim(2) = ylims(i,2); end
end

% Ensure both insets use the same Y-ticks, if they cover the same area
if all(iny1 == iny2); s7.YTick = s8.YTick; end 

% Shuffle plots
s1.Position = [0.1300 0.7500 0.7750 0.2000];
s2.Position = [0.1300 0.5700 0.3347 0.1200];
s3.Position = [0.5703 0.5700 0.3347 0.1200];
l1.Position = [0.2545 0.5100 0.5490 0.0211];
s4.Position = [0.1300 0.2553 0.7750 0.2000];
s5.Position = [0.1300 0.0700 0.3347 0.1200];
s6.Position = [0.5703 0.0700 0.3347 0.1200];
l2.Position = [0.1727 0.0100 0.7090 0.0211];
s7.Position = [0.65   0.8272 0.2397 0.1094];
s8.Position = [0.65   0.3311 0.2397 0.1094];

% Add some helpful markers
if annotate
    a1 = annotation('textarrow',[0.3575, 0.3575], [0.735, 0.75], 'String','14-15 Jun', 'HeadLength', 6, 'HeadWidth',8);
    a2 = annotation('arrow',[0.3575, 0.3575], [0.965, 0.95], 'HeadLength', 6, 'HeadWidth',8);
end

% To file
export_fig(save_here,'-r300')

end

