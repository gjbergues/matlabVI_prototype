function [fitresult, gof] = createFit(yy, cv2)
%CREATEFIT(YY,CV2)
%  Create a fit.
%
%  Data for 'untitled fit 1' fit:
%      X Input : yy
%      Y Output: cv2
%  Output:
%      fitresult : a fit object representing the fit.
%      gof : structure with goodness-of fit info.
%
%  See also FIT, CFIT, SFIT.

%  Auto-generated by MATLAB on 25-Apr-2013 12:06:59


%% Fit: 'untitled fit 1'.
[xData, yData] = prepareCurveData( yy, cv2 );

% Set up fittype and options.
ft = fittype( 'gauss8' );
opts = fitoptions( ft );
opts.Display = 'Off';
opts.Lower = [-Inf -Inf 0 -Inf -Inf 0 -Inf -Inf 0 -Inf -Inf 0 -Inf -Inf 0 -Inf -Inf 0 -Inf -Inf 0 -Inf -Inf 0];
opts.StartPoint = [0.472770551742154 500 6.63723679588647 0.450691883055303 208 7.68156584207316 0.383666325458364 305 8.3972197202209 0.382390433846557 110 13.057591252024 0.379465770018887 598 10.3584078658333 0.376814602334289 402 9.30118901335167 0.374597835001106 14 19.4917344287928 0.352386193184021 694 13.7045251608496];
opts.Upper = [Inf Inf Inf Inf Inf Inf Inf Inf Inf Inf Inf Inf Inf Inf Inf Inf Inf Inf Inf Inf Inf Inf Inf Inf];

% Fit model to data.
[fitresult, gof] = fit( xData, yData, ft, opts );




