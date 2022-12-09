function [c,Y_sig,Y_sig_unsorted,tab] = error_estimation (Y,k,tol , method ,m)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Function that estimates the error of a time series of data                       %
    % Requirements                                                                     %
    % [1] the underlying data - generating function , h(t), is sufficiently smooth     %
    % [2] the sampling interval is high compared to the time - scale of h(t)           %
    % [3] the errors exhibit a constant or heteroscedastic variance                    %
    %                                                                                  %
    % SYNOPSIS [c,Y_sig , tab] = error_estimation (Y);                                 %
    % [c,Y_sig , tab ] = error_estimation (Y,k,tol , method ,m);                       %
    %                                                                                  %
    % INPUTS                                                                           %
    % Y [ required ]: n x 1 vector with values of measured signal                      %
    % k [ optional ]: difference operator applied k times ( default k: 3)              %
    % tol [ optional ]: value below which estimated errors are discarded               %
    % method [ optional ]: 1 use all data ( default method : 2)                        %
    % 2 use average estimates of sigma                                                 %
    % m [ optional ]: tab window size to left and right ( default m: 100)              %
    %                                                                                  %
    % OUTPUTS                                                                          %
    % c: vector with slope and intercept                                               %
    % Y_sig : n-k x 2 matrix with data versus the error sigma                          %
    % tab : n-k x 2 matrix with sliding average values of sigma                        %
    %                                                                                  %
    % SOURCE                                                                           %
    % de Oliveira, D. Y., & Vrugt, J. A. (2022). The treatment of                      %
    % uncertainty in hydrometric observations: A probabilistic description             %
    % of streamflow records. Water Resources Research, 58, e2022WR032263.              %
    % https://doi.org/10.1029/2022WR032263                                             %
    %                                                                                  %
    % MODIFICATION                                                                     %                                                        
    % Added unsorted [Y,sigma] as output for easier plotting                           %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    if nargin < 2, k = 3; end % how many times does one want to difference ?
    if nargin < 3, tol = 0; end % remove errors smaller than tol
    if nargin < 4, method = 2; end % fitting method
    if nargin < 5, m = 100; end % window size of moving average

    %% Matrix form ( Zhou et al., 2015) - see Supporting Information (SI) file
    N = numel(Y);

    % get d entries
    d_pas = pascal(k+1,1); 
    d = d_pas(k+1,1:k +1);

    % normalize d entries
    d_norm = d./norm(d); % Eq. (11) of the SI

    % Note : sum ( d_norm ) = 0; and sum ( d_norm .^2) = 1
    D = zeros(N-k,N); A = D; wghts = 1/(k+1) * ones (1,k +1);
    for i = 1:N-k
        D(i,i:i+k) = d_norm ; % entries of D (Eq. (15) of the SI)
        A(i,i:i+k) = wghts ; % to get mean discharge
    end

    % Now we yield sigma2 estimate
    sigma2_est = (D*Y(1:N)).^2; % Eq. (16) of the SI

    % Compute mean values of discharge
    Y_m = A*Y; % Eq. (17) of the SI

    %% Estimate slope and intercept
    if tol > 0
        % Remove small errors
        idx = sqrt(sigma2_est ) > 1e-10; 
        Y_m = Y_m(idx); 
        sigma2_est = sigma2_est(idx);
    end

    % Prepare return argument - sort first column for moving average in tab
    Y_sig = sortrows([ Y_m sqrt(sigma2_est) ],1);
    Y_sig_unsorted = [Y_m sqrt(sigma2_est)];
    if method == 1
        % Get slope and intercept estimates using all data
        c = polyfit(Y_m,sqrt(sigma2_est),1); % Eq. (14) ( all data )
        tab = [];
    elseif method == 2
        % Now use moving average with window to get average estimates of sigma
        tab = [ Y_sig(:,1) sqrt(movmean(Y_sig(: ,2).^2 ,[ m m ])) ];
        tab(end-m+1:end ,:) = []; % discard endpoints
        tab(1:m,:) = []; % discard endpoints
        idx = find(isnan(tab(: ,2))); tab(idx,:) = [];
        % Now fit line to tabular ( averaged ) data
        c = polyfit(tab(:,1),tab(:,2),1); % Eq. (14) ( moving window )
    end
end