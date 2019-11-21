function NP_makeFigure1(data,modelData,opt,dirPth)

TR               = 1.5; % sampling rate at which fMRI data was acquired
numTRs           = size(data.timeSeries_rois_thr{1,1,1}.tSeries,1); % total number of sampling points
numTimePoints    = numTRs * TR;
time             = linspace(1,numTimePoints,numTRs);

conditions       = opt.conditions;
numCond          = length(conditions);
numRoi           = length(opt.rois);

numVox_toPlot  = 4;
vox_idx_toPlot = nan(numVox_toPlot,numRoi);
for roi_idx = 1:numRoi
    % find the voxels with maximum variance explained in all conditions
    [v, v_index]               = sort(modelData.all.modelInfo_thr{roi_idx}.varexp,'descend');
    vox_idx_toPlot(:,roi_idx)  = v_index(1:numVox_toPlot)'; % select top 4 voxels with highest variance explained
end

% change colors here
color_map_pred = [1 0.5 0.5;...
    0.5 1 0.5;...
    0.5 0.5 1;...
    0.5 0.5 0.5];

% change colors here
color_map_ts = [0.65 0.25 0.25;...
    0.25 0.65 0.25;...
    0.25 0.25 0.65;...
    0.5 0.5 0.5];


plot_response = {'meas','pred','both'};

for i = 1:length(plot_response)
    
    cur_plotResponse = plot_response{i};
    
    numVox = length(vox_idx_toPlot);
    for vox_idx = 1:numVox
        
        for roi_idx = 1:numRoi
            % current voxel to plot
            cur_vox = vox_idx_toPlot(vox_idx,roi_idx);
            
            %current roi to plot
            curRoi = opt.rois{roi_idx};
            
            figName = sprintf('Original and predicted timeSeries for roi %s',curRoi);
            fprintf('%s...',curRoi);
            fH1 = figure(1);clf;
            set(gcf,'position',[66,1,1855,1001],'Name',figName);
            
            for cond_idx = 1:numCond
                curCond = opt.conditions{cond_idx};
                
                % Plot the time series
                switch cur_plotResponse
                    case 'meas'
                        plot(time, data.timeSeries_rois_thr{cond_idx,roi_idx}.tSeries(:,cur_vox),'--','color',color_map_ts(cond_idx,:),'LineWidth',4,'markerSize',7);
                        hold on;
                        
                        
                    case 'pred'
                        plot(time, data.predictions_rois_thr{cond_idx,roi_idx}(:,cur_vox),'color',color_map_pred(cond_idx,:),'LineWidth',4);
                        hold on;
                        
                    otherwise
                        plot(time, data.timeSeries_rois_thr{cond_idx,roi_idx}.tSeries(:,cur_vox),'--','color',color_map_ts(cond_idx,:),'LineWidth',4,'markerSize',7);
                        hold on;
                        plot(time, data.predictions_rois_thr{cond_idx,roi_idx}(:,cur_vox),'color',color_map_pred(cond_idx,:),'LineWidth',4);
                        hold on;
                end
                
                xlim(opt.xLimTs);
                ylim([-inf inf]);
                legend(opt.conditions,'location','southeast');
                
                %--- texts in the plot
                x_cond                = modelData.comp.modelInfo_thr{cond_idx,roi_idx}.x(cur_vox);
                y_cond                = modelData.comp.modelInfo_thr{cond_idx,roi_idx}.y(cur_vox);
                ve_cond               = modelData.comp.modelInfo_thr{cond_idx,roi_idx}.varexp(cur_vox);
                s_cond                = modelData.comp.modelInfo_thr{cond_idx,roi_idx}.sigma(cur_vox);
                b_cond                = modelData.comp.modelInfo_thr{cond_idx,roi_idx}.beta(cur_vox);
                coords_cond           = data.timeSeries_rois_thr{cond_idx,roi_idx}.params.roi.coords(:,cur_vox);
                %---------------------
                
                txt_inPlot = sprintf('coords: [%d,%d,%d]',coords_cond(1),coords_cond(2),coords_cond(3));
                text(0.2,0.2,txt_inPlot,'Color',[0.2 0.2 0.2],'FontSize',15,'Units','normalized');
                
            end
            
            xlabel('time (sec)');
            ylabel('% BOLD response');
            set(gca,'FontUnits','centimeters','FontSize',1.1,'TickDir','out','LineWidth',3); box off;
            
            if opt.saveFigTseries
                saveDir = fullfile(dirPth.saveDirMSFig,'figure2',sprintf('figure2_%s_%s',opt.plotType));
                if ~exist(saveDir,'dir')
                    mkdir(saveDir);
                end
                
                figName(regexp(figName,' ')) = '_';
                filename                     = figName;
                fullFilename                 = sprintf([filename,'_ts_%s_%d_%s'],curRoi,vox_idx_toPlot(vox_idx),cur_plotResponse);
                print(fH1, fullfile(saveDir,fullFilename), '-depsc2');
            end
            
        end
    end
end


%% Average responses across voxels

for i = 1:length(plot_response)
    
    cur_plotResponse = plot_response{i};
    
    for roi_idx = 1:numRoi
        
        
        %current roi to plot
        curRoi = opt.rois{roi_idx};
        
        figName = sprintf('Original and predicted timeSeries for roi %s',curRoi);
        fprintf('%s...',curRoi);
        fH2 = figure(1);clf;
        set(gcf,'position',[66,1,1855,1001],'Name',figName);
        
        for cond_idx = 1:numCond
            curCond = opt.conditions{cond_idx};
            
            % Plot the time series
            switch cur_plotResponse
                case 'meas'
                    plot(time, nanmean(data.timeSeries_rois_thr{cond_idx,roi_idx}.tSeries,2),'--','color',color_map_ts(cond_idx,:),'LineWidth',4,'markerSize',7);
                    hold on;
                    
                    
                case 'pred'
                    plot(time,nanmean(data.predictions_rois_thr{cond_idx,roi_idx},2),'color',color_map_pred(cond_idx,:),'LineWidth',4);
                    hold on;
                    
                otherwise
                    plot(time, nanmean(data.timeSeries_rois_thr{cond_idx,roi_idx}.tSeries,2),'--','color',color_map_ts(cond_idx,:),'LineWidth',4,'markerSize',7);
                    hold on;
                    plot(time,nanmean(data.predictions_rois_thr{cond_idx,roi_idx},2),'color',color_map_pred(cond_idx,:),'LineWidth',4);
                    hold on;
            end
            
            xlim(opt.xLimTs);
            ylim([-inf inf]);
            legend(opt.conditions,'location','southeast');
            
            
        end
        
        xlabel('time (sec)');
        ylabel('% BOLD response');
        set(gca,'FontUnits','centimeters','FontSize',1.1,'TickDir','out','LineWidth',3); box off;
        
        if opt.saveFigTseries
            saveDir = fullfile(dirPth.saveDirMSFig,'figure2',sprintf('figure2_average_%s_%s',opt.plotType,cur_plotResponse));
            if ~exist(saveDir,'dir')
                mkdir(saveDir);
            end
            
            figName(regexp(figName,' ')) = '_';
            filename                     = figName;
            fullFilename                 = sprintf([filename,'_ts_%s_%d'],curRoi,vox_idx_toPlot(vox_idx));
            print(fH2, fullfile(saveDir,fullFilename), '-depsc2');
        end
        
    end
    
    
end


end