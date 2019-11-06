function hvol = SF_prfFit_with_hrfFit(condition)


% open mrVista
hvol = initHiddenGray;
hvol = viewSet(hvol,'curdt',condition);

% Load the stimulus parameters
figpoint = rmEditStimParams(hvol);
%params = rmDefineParameters(hvol);
%makeStimFromScan(params);
uiwait(figpoint);

fprintf('Starting the pRF fitting with hrf');

% Run the pRF model for both the conditions together (also run the hrf fit)
hvol = rmMain(hvol,[],5);


end