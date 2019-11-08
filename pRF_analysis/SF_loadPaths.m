function dirPth = SF_loadPaths(subjID)

%% ----- General -----
dirPth  = struct();
dirPth.rootPth = SF_rootPath;
dirPth.subjID  = subjID;

dirPth.sessionPath     = fullfile(SF_rootPath, 'data','functionals',subjID,'vistaSession');

%% ----- mrVista paths -----
% Define the location of the files

dirPth.roiPath = fullfile(dirPth.sessionPath,'anatomy','ROIs');
dirPth.modelPath = fullfile(dirPth.sessionPath,'Gray');
dirPth.coordsPath = fullfile(dirPth.sessionPath,'Gray');

%% ----- mrVista paths -----
dirPth.functionalPath = fullfile(SF_rootPath, 'data','functionals',subjID);

%% ----- stimuli paths -----
% Define the location of the files

dirPth.stimulusImagePath     = fullfile(SF_rootPath,'data','stimuli','spatialFrequency_images','Used_for_experiment');
dirPth.stimulusfilesPath     = fullfile(SF_rootPath,'data','stimuli','stimulus_files');


%% ----- save figures -----
dirPth.saveDirFig            = fullfile(dirPth.functionalPath,'figures');

%% ----- save manuscript figures (general not subject specific) -----
dirPth.saveDirMSFig          = fullfile(SF_rootPath,'data','MS','figures');
dirPth.saveDirStatsRes       = fullfile(SF_rootPath,'data','MS','stats_results');

%% ----- save results -----
dirPth.saveDirRes            =  fullfile(SF_rootPath, 'data','functionals',subjID,'results');
