clear all
close all

myStartup('+','matFileAddOn')
myStartup('+','afni_matlab')

filenameList = dir('*.log');

for i=1:length(filenameList)
    filenames{i} = filenameList(i).name;
end

% filenames{1} = 'SCANPHYSLOG20150922172827.log';
% filenames{2} = 'SCANPHYSLOG20150915184908.log';
% filenames{3} = 'SCANPHYSLOG20150915185454.log';
% filenames{4} = 'SCANPHYSLOG20150915190044.log';
% filenames{5} = 'SCANPHYSLOG20150915190651.log';
% filenames{6} = 'SCANPHYSLOG20150915191235.log';
% filenames{7} = 'SCANPHYSLOG20150915191901.log';

params.tr = 0.85;
params.nSlices = 13;
params.sliceOrder = 'alt+z';
params.sequenceLenght = 306;
params.resamplingSeries = 0.005;
params.RVT_out = 0;

for k = 1 : length(filenames)
    params.fileOutput = sprintf('oba%d', k);
    params.filename = filenames{k};
    retroicorPredictor( params )
end
