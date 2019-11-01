function dirPth = loadPaths(subjID)

%% ----- General -----
dirPth  = struct();
dirPth.rootPth = SF_rootPath;
dirPth.subjID  = subjID;

dirPth.sessionPth     = fullfile(SF_rootPath, 'data','functionals',subjID,'vistaSession');

%% ----- mrVista paths -----
% Define the location of the files

dirPth.roiPath = strcat(dirPth.sessionPth,'/anatomy/ROIs/');
dirPth.modelPath = strcat(dirPth.sessionPth,'/Gray/');
dirPth.coordsPath = strcat(dirPth.sessionPth,'/Gray/');

%% ----- mrVista paths -----
% Directories to save results

