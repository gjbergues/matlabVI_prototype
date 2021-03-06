function [fitresult, gof] = createFit(x, cv)
%CREATEFIT(X,CV)
%  Create a fit.
%
%  Data for 'untitled fit 1' fit:
%      X Input : x
%      Y Output: cv
%  Output:
%      fitresult : a fit object representing the fit.
%      gof : structure with goodness-of fit info.
%
%  See also FIT, CFIT, SFIT.

%  Auto-generated by MATLAB on 29-May-2018 10:07:48


%% Fit: 'untitled fit 1'.
[xData, yData] = prepareCurveData( x, cv );

% Set up fittype and options.
ft = fittype( 'gauss1' );
opts = fitoptions( ft );
opts.Display = 'Off';
opts.Lower = [-Inf -Inf 0];
opts.StartPoint = [233.2 605 83.5247251703489];
opts.Upper = [Inf Inf Inf];

% Fit model to data.
[fitresult, gof] = fit( xData, yData, ft, opts );




