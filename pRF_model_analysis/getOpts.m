function opt = getOpts(varargin)
% Function to get struct with default analysis pipeline options 
% example:
%
% Example 1:
%   opt = getOpts('verbose', false)
% Example 2:
%   opt = getOpts('foo', true)


% --- GENERAL ---
opt.skipMEGPreproc        = true;               % General
opt.skipMRIPreproc        = true;               % General
opt.verbose               = true;               % General
opt.saveData              = false;               % General
opt.saveFig               = false;               % General
opt.fullSizeMesh          = false;              % General: if true, execute analysis with fullsize meshes and gain matrix (FS size), if false, downsample to Brainstorm mesh size
opt.surfVisualize         = false;              % General: visualize surface meshes
opt.subfolder             = 'original'; 

% --- prf parameters ---
opt.rois = [{'V1';'V2';}];
opt.conditions = {'sf03';'sf06';'sf12';'sf12'};
opt.plotType = 'Ecc_Sig';
% Model thresholds
opt.varExpThr = 0.2;
opt.eccThr = [0.5 4];
opt.meanMapThr = 1000;

% --- fitting parameters ---
opt.binType = 'Eq_size'; % Eq_size : bins contain equal number of points (unequal intervals however).
                         % Eq_interval : bins with equal intervals (some bins might not contain any points however).
opt.bootType='bin'; % bin : bin the data, bootstrap the bins (this will avoid the problems due to upsampling of functionals to anatomical space)
                    % all : bootstrap all the points 
                    
% --- plotting options ---
opt.markerSize = 6;

% --- parameters to calculate ---
opt.centralVal = false;
opt.AUC = true;

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