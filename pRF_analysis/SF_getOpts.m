function opt = SF_getOpts(subjID,varargin)
% Function to get struct with default analysis pipeline options 
% example:
%
% Example 1:
%   opt = getOpts('verbose', false)
% Example 2:
%   opt = getOpts('foo', true)

opt.subjID = subjID;

% --- GENERAL ---
opt.verbose               = true;               % General
opt.plotTimeSeries        = false;
opt.detailedPlot          = false;
opt.aucBsPlot             = false;

opt.saveData              = true;               % General
opt.saveFig               = true;               % General
opt.saveFigTseries        = true;               % General
opt.subfolder             = 'original'; 
opt.visPRF                = false;

opt.extractPrfParams      = true;
opt.getTimeSeries         = false;
opt.getPredictedResponse  = true;
  
% --- prf parameters ---
opt.rois = [{'V1';'V2';'V3'}]; 
opt.conditions = {'sf03';'sf06';'sf12'};
opt.modelType = '2DGaussian'; % DoGs for difference of gaussians 
opt.plotType = 'Ecc_Sig';
% Model thresholds
opt.varExpThr = 0.2;
opt.eccThr = [0.5 4];
opt.meanMapThr = 1000;

% --- fitting parameters ---
opt.binType = 'Eq_interval'; % Eq_size : bins contain equal number of points (unequal intervals however).
                         % Eq_interval : bins with equal intervals (some bins might not contain any points however).
opt.bootType='all'; % bin : bin the data, bootstrap the bins (this will avoid the problems due to upsampling of functionals to anatomical space)
                    % all : bootstrap all the points 
                    
% --- plotting options ---
opt.markerSize = 6;

% --- parameters to calculate ---
opt.cenDifference = false;
opt.aucDifference = false;
opt.aucBootstrap  = false;
opt.cenEcc = 2.5;
opt.centralVal = false;
opt.AUC = true;

opt.xLimTs = [0 380];
opt.yLimTs = [-7 7];

opt.yLimAuc = [-1 3];
opt.yLimCen = [-0.05 0.2].*100;

%% Check for extra inputs in case changing the default options
if exist('varargin', 'var')
    
    % Get fieldnames
    fns = fieldnames(opt);
    for ii = 1:2:length(varargin)
        % paired parameter and value
        parname = varargin{ii};
        val     = varargin{ii+1};
        
        % check whether this parameter exists in the defaults
        idx = cellfind(fns, parname);
        
        % if so, replace it; if not add it to the end of opt
        if ~isempty(idx), opt.(fns{idx}) = val;
        else, opt.(parname) = val; end
        
        
    end
end

return