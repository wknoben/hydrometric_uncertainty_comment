function make_plot(x, Y_sig_unsorted_ori, Y_sig_ori, tab_ori, fit_ori, ...
                      Y_sig_unsorted_syn, Y_sig_syn, tab_syn, fit_syn, a,b, true_error, ...
                      units, ...
                      inx, iny, xlims, save_here)

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
% units:            string with observation and error units
% inx:              x-indices of the inset plots
% iny:              y-values of the inset plots
% xlims:            x-limits for the hydrograph plots
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

% Inset settings
inxx = [x(inx(1)),x(inx(2)),x(inx(2)),x(inx(1)),x(inx(1))];
inyy = [iny(1),iny(1),iny(2),iny(2),iny(1)];

% construct the label strings
string_yt = "$\tilde{y_t}~" + units + "$";
string_st = "$\hat{\sigma_t^o}~" + units + "$";
string_syn = "Synthetic hydrograph (a = "+a+", b = "+b+")";

% 1. Original hydrograph, with estimated sigma_t values on second Y
s1 = subplot(ny,nx,(1:2));
    yyaxis left
        hold on;
        plot(x,Y_sig_unsorted_ori(:,1),'linewidth',2,'color',hyd_col)
        plot(inxx,inyy,'-r')
        xlabel('$time~[h]$','Interpreter','LaTeX','fontsize',fs);
        ylabel(string_yt,'Interpreter','LaTeX','fontsize',fs);
        datetick('x','mmm');%,'keepticks');
        title('(a) Original hydrograph','fontsize',fs);
    yyaxis right
        plot(x,Y_sig_unsorted_ori(:,2),'color',err_col)
        ylabel(string_st,'Interpreter','LaTeX','fontsize',fs);
        box on
        xlim([x(xlims(1)),x(xlims(2))]);
        
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
    title('(b) Original hydrograph','fontsize',fs);
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
    title('(c) Original hydrograph','fontsize',fs);
    grid on       
    set(gca, 'XScale','log','YScale','log')

% 4. Synthetic hydrograph, with estimated sigma_t values as colors
s4 = subplot(ny,nx,(5:6));
    yyaxis left
        hold on;
        plot(x,Y_sig_unsorted_syn(:,1),'linewidth',2,'color',hyd_col)
        plot(inxx,inyy,'-r')
        xlabel('$time~[h]$','Interpreter','LaTeX','fontsize',fs);
        ylabel(string_yt,'Interpreter','LaTeX','fontsize',fs);
        datetick('x','mmm');%,'keepticks');
        title("(a) " + string_syn,'fontsize',fs);
    yyaxis right
        plot(x,Y_sig_unsorted_syn(:,2),'color',err_col)
        ylabel(string_st,'Interpreter','LaTeX','fontsize',fs);
        box on
        xlim([x(xlims(1)),x(xlims(2))]);

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
    title("(b) " + string_syn,'fontsize',fs);
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
    title("(c) " + string_syn,'fontsize',fs);
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
    plot(inxx,inyy,'-r')
    xlim([inxx(1),inxx(2)]); ylim([iny(1),iny(2)]);
    box on; xticklabels([]); %yticklabels([]);
s8 = subplot(ny,nx,10);
    hold on; % Needed because without it we get a white background
    plot(x, Y_sig_unsorted_syn(:,1),'color',hyd_col,'marker','o')
    %scatter(x, Y_sig_unsorted_syn(:,1), sub_size, Y_sig_unsorted_syn(:,2), 'filled')
    plot(inxx,inyy,'-r')
    xlim([inxx(1),inxx(2)]); ylim([iny(1),iny(2)]);
    box on; xticklabels([]); % Keep only the Y-ticks for clarity

s7.YTick = s8.YTick; % Ensure both use the same Y-ticks    
    
% Shuffle plots
s1.Position = [0.1300 0.7500 0.7750 0.2000];
s2.Position = [0.1300 0.5700 0.3347 0.1200];
s3.Position = [0.5703 0.5700 0.3347 0.1200];
l1.Position = [0.2545 0.5100 0.5490 0.0211];
s4.Position = [0.1300 0.2553 0.7750 0.2000];
s5.Position = [0.1300 0.0700 0.3347 0.1200];
s6.Position = [0.5703 0.0700 0.3347 0.1200];
l2.Position = [0.1727 0.0100 0.7090 0.0211];
s7.Position = [0.6539 0.8272 0.2397 0.1094];
s8.Position = [0.6558 0.3311 0.2397 0.1094];

% To file
export_fig(save_here,'-r300')

end

