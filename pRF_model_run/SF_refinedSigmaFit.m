function hvol = SF_refinedSigmaFit(model_file_all, condition)

% Run pRF model fit for sigma alone for natural and phase scrambled separately
% Set the current dataset to natural

if ~exist('model_file_all','var') || isempty(model_file_all)
    % Select the original model
    [model_fname, model_fpath] = uigetfile('*.mat','Select model');
end

if ~exist('hvol','var')
    hvol = initHiddenGray;
end

% Load the model ran on all conditions
model_all = (fullfile(model_fpath, model_fname));

% Run the model for the condition defined
hvol = viewSet(hvol,'curdt',condition);

% Add the pRF model and HRF to the mrVista view
hvol = rmSelect(hvol,1,model_all);
hrf = cell(1,2);
hrf{1} = hvol.rm.retinotopyParams.stim.hrfType; % hrf fitted from the all condition is used here
hrf{2} = hvol.rm.retinotopyParams.stim.hrfParams(2);

outFileName = sprintf('%s_refined_',condition);

% Run the model fit for only sigma alone
hvol = rmMain(hvol,[],7,'matFileName',outFileName,'hrf',hrf,'refine','sigma');

end