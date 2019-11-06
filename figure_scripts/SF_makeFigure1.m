% SF_makeFigure1 - To make the figure showing the spatial frequency
% disribution of the stimulus images

subjID = 'dlsubj003';

dirPth = SF_loadPaths(subjID);

opt = SF_getOpts(subjID);

%%
% Display parameters
display.screensizeinpixels = 1080;
display.height             = 39.29;
display.distance           = 220;
display.screensizeindeg    = rad2deg(atan(display.height./(2*display.distance))); % radius
display.stepsindeg         = linspace(-display.screensizeindeg,display.screensizeindeg,display.screensizeinpixels);

close all;
SF_plotPowerspec(opt,dirPth,display);


