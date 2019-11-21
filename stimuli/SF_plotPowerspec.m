function SF_plotPowerspec(opt,dirPth,display)
% Load the images generated using SF_stimImGen and compute the average
% powerspectrum and RMS contrast of all the images


% Define the paths
stimulusImagesPath = dirPth.stimulusImagePath;

% list the stimulus image files
stimulusFiles = dir(sprintf('%s/*.mat',stimulusImagesPath));

% total number of conditions of spatial frequency
numCond = length(opt.conditions);

if ~isequal(numCond,length(stimulusFiles))
    warning('number of stimulus files dont match with the stimulus conditions used');
end

% Save the paths for all the images for all the conditions in a structure
ff = struct;
for i = 1:numCond
    ff(i).sf = fullfile(stimulusFiles(i).folder,stimulusFiles(i).name);
end

% x axis for plotting frequency spectrum
x0 = linspace(0,display.screensizeinpixels/(2*display.screensizeindeg)/2,display.screensizeinpixels/2+1);

figName = sprintf('Power spectrum distribution');
fH1 = figure(1); 
set(gcf,'Position',[66,1,1855,1001],'name',figName);

for sf_idx = 1: numCond
    
    load(ff(sf_idx).sf);
    
    
    %% Peak should be at the stimulus frequency
    
    % Calculate the average power at each frequency across all the images
    pp_all = nan(length(x0),size(s_rndPh_rndOrn,2));
    for i=1:size(s_rndPh_rndOrn,2)
        pp_all(:,i) = s_rndPh_rndOrn(i).pp;
    end
    pp_all_ave = mean(pp_all,2);
    
    % Determine the peak value and the frequency at peak value
    pk = max(pp_all_ave);
    freq = x0(pp_all_ave == pk);
    
    %% RMS contrast should be constant for all the conditions
    
    % Calculate the total contrast
    rms_con_all = nan(1,size(s_rndPh_rndOrn,2));
    for i=1:size(s_rndPh_rndOrn,2)
        rms_con_all(:,i) = s_rndPh_rndOrn(i).contrast.rms;
    end
    rms_con_all_ave = mean(rms_con_all,2);
    fprintf('\n mean RMS contrast of all image with frequency %f cycles/degree is %f \n',freq,rms_con_all_ave);
    
    %% Average image
    
    im_all = nan(size(s_rndPh_rndOrn(1).image,1),size(s_rndPh_rndOrn(1).image,2),size(s_rndPh_rndOrn,2));
    for i=1:size(s_rndPh_rndOrn,2)
        im_all(:,:,i) = s_rndPh_rndOrn(i).image;
    end
    im_all_ave(sf_idx).image = mean(im_all,3);
    
    %%
    % plots
    
    switch sf_idx
        case 1
            loglog(x0,pp_all_ave,'r','lineWidth',3); grid on;
        case 2
            loglog(x0,pp_all_ave,'g','lineWidth',3); grid on;
        case 3
            loglog(x0,pp_all_ave,'b','lineWidth',3); grid on;
        case 4
            loglog(x0,pp_all_ave,'k','lineWidth',3); grid on;
    end
    hold on; plot(freq,pk,'.','MarkerSize',15);
    text(freq,1.5*pk,['(' num2str(freq) ',' num2str(pk) ')'])
    hold on;
    
    % Display the average image
    %figure; imagesc(im_all_ave); axis off image; colormap gray;
    
end

set(gca,'FontUnits','centimeters', 'FontSize', 1.5, 'TickDir','out','LineWidth',4); box off

xgrid = get(gca,'XGridHandle');
gridWidth = 1;
set(xgrid,'LineWidth',gridWidth,'MinorLineWidth',gridWidth);
ygrid = get(gca,'YGridHandle');
set(ygrid,'LineWidth',gridWidth, 'MinorLineWidth',gridWidth);

if opt.saveFig
    saveDir = fullfile(dirPth.saveDirMSFig,'figure1');
    if ~exist(saveDir,'dir')
        mkdir(saveDir);
    end
        
    figName(regexp(figName,' ')) = '_';
    filename = figName;
    print(fH1, fullfile(saveDir,strcat(filename)), '-dpng');
    
    print(fH1, fullfile(saveDir,strcat(filename)), '-depsc2');
    
end

end