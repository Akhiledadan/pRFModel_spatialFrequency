function dirPth = SF_loadPaths(subjID,bb)

%% ----- General -----
dirPth  = struct();
dirPth.rootPth = SF_rootPath;
dirPth.subjID  = subjID;

if ~exist('bb','var') || isempty(bb)
    bb = 0;
end

%% ----- mrVista paths -----
dirPth.functionalPath = fullfile(SF_rootPath, 'data','functionals',subjID);


%% ----- mrVista paths -----
% Define the location of the files

if ~bb
    dirPth.sessionPath     = fullfile(SF_rootPath, 'data','functionals',subjID,'vistaSession');
else
    dirPth.sessionPath     = fullfile(SF_rootPath, 'data','functionals',subjID,'vistaSession_bb'); % if broadband condition is included
end

dirPth.roiPath = fullfile(dirPth.sessionPath,'anatomy','ROIs');
dirPth.modelPath = fullfile(dirPth.sessionPath,'Gray');
dirPth.coordsPath = fullfile(dirPth.sessionPath,'Gray');

if ~bb
    % ----- save figures -----
    dirPth.saveDirFig            = fullfile(dirPth.functionalPath,'figures');
    % ----- save manuscript figures (general not subject specific) -----
    dirPth.saveDirMSFig          = fullfile(SF_rootPath,'data','MS','figures');
    dirPth.saveDirStatsRes       = fullfile(SF_rootPath,'data','MS','stats_results');
    % ----- save results -----
    dirPth.saveDirRes            =  fullfile(SF_rootPath, 'data','functionals',subjID,'results');
else
    % ----- save figures -----
    dirPth.saveDirFig            = fullfile(dirPth.functionalPath,'figures_bb');
    % ----- save manuscript figures (general not subject specific) -----
    dirPth.saveDirMSFig          = fullfile(SF_rootPath,'data','MS','figures_bb');
    dirPth.saveDirStatsRes       = fullfile(SF_rootPath,'data','MS','stats_results_bb');
    % ----- save results -----
    dirPth.saveDirRes            =  fullfile(SF_rootPath, 'data','functionals',subjID,'results_bb');
end


%% ----- stimuli paths -----
% Define the location of the files

dirPth.stimulusImagePath     = fullfile(SF_rootPath,'data','stimuli','spatialFrequency_images','Used_for_experiment');
dirPth.stimulusfilesPath     = fullfile(SF_rootPath,'data','stimuli','stimulus_files');

