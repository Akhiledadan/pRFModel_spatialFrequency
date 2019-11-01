% This script is to compare the tSNRMaps of seperated scans and the averaged
% tSNRMap, which could be helpful to calculate how many scans for 3T are 
% needed to analogize to 7T.
% 
ipSNR.org = load('Inplane/Original/snrMap.mat');
iptSNR.org = load('Inplane/Original/tSNRMap.mat');
ipCoh.org = load('Inplane/Original/corAnal.mat');


ipSNR.avg = load('Inplane/Averages/snrMap.mat');
iptSNR.avg = load('Inplane/Averages/tSNRMap.mat');
ipCoh.avg = load('Inplane/Averages/corAnal.mat');


%% 3T
brainmask = iptSNR.avg.map{1}>1.5;
% to visualize mask
figure;imagesc(brainmask(:,:,12));

tsnr_avg = zeros(size(iptSNR.avg.map{1}));

tsnr_avg = sqrt( iptSNR.org.map{1}.^2 + iptSNR.org.map{2}.^2 + iptSNR.org.map{3}.^2 + iptSNR.org.map{4}.^2 + iptSNR.org.map{5}.^2);

figure;
subplot(2,3,1);
plot(iptSNR.org.map{1}(brainmask),iptSNR.avg.map{1}(brainmask),'.');
axis([0 250 0 250]) 
axis square
hold on;
plot([0 250],[0 250],'r');
title('scan 1 vs avg');

subplot(2,3,2);
plot(iptSNR.org.map{2}(brainmask),iptSNR.avg.map{1}(brainmask),'.');
axis([0 250 0 250]) 
axis square
hold on;
plot([0 250],[0 250],'r');
title('scan 2 vs avg')

subplot(2,3,3);
plot(iptSNR.org.map{3}(brainmask),iptSNR.avg.map{1}(brainmask),'.');
axis([0 250 0 250]) 
axis square
hold on;
plot([0 250],[0 250],'r');
title('scan 3 vs avg')

subplot(2,3,4);
plot(iptSNR.org.map{4}(brainmask),iptSNR.avg.map{1}(brainmask),'.');
axis([0 250 0 250]) 
axis square
hold on;
plot([0 250],[0 250],'r');
title('scan 4 vs avg')

subplot(2,3,5);
plot(iptSNR.org.map{5}(brainmask),iptSNR.avg.map{1}(brainmask),'.');
axis([0 250 0 250]) 
axis square
hold on;
plot([0 250],[0 250],'r');
title('scan 5 vs avg')

subplot(2,3,6);
plot(tsnr_avg(brainmask),iptSNR.avg.map{1}(brainmask),'.');
hold on;
plot([0 250],[0 250],'r');
axis([0 250 0 250]) 
axis square
title('scan 1~5 vs avg')

%% 7T
tsnr_avg = zeros(size(iptSNR.avg.map{1}));
tsnr_avg = sqrt( iptSNR.org.map{1}.^2 + iptSNR.org.map{2}.^2);
brainmask = iptSNR.avg.map{1}>24;
a = tsnr_avg(brainmask);

figure;
subplot(211);plot(iptSNR.org.map{1}(brainmask),iptSNR.avg.map{1}(brainmask),'.');
axis([0 250 0 250]);
axis square;hold on;
plot([0 250],[0 250],'r');
title('scan 1 vs avg');
subplot(212);plot(iptSNR.org.map{2}(brainmask),iptSNR.avg.map{1}(brainmask),'.');
axis([0 250 0 250]);
axis square;hold on;
plot([0 250],[0 250],'r');
title('scan 2 vs avg');

figure;
subplot(221);plot(ipSNR.org.map{1}(brainmask),ipSNR.avg.map{1}(brainmask),'.');
axis([1 2.5 1 2.5]);
axis square;hold on;
plot([1 2.5],[1 2.5],'r');
title('scan 1 vs avg');
subplot(222);plot(ipSNR.org.map{2}(brainmask),ipSNR.avg.map{1}(brainmask),'.');
axis([1 2.5 1 2.5]);
axis square;hold on;
plot([1 2.5],[1 2.5],'r');
title('scan 2 vs avg');
subplot(223);plot(snr_avg(brainmask),ipSNR.avg.map{1}(brainmask),'.');
axis([1 2.5 1 2.5]);
axis square;hold on;
plot([1 2.5],[1 2.5],'r');
title('scan 1+2 vs avg');

%%  VOlume view
% whole brain maps
vlSNR.org = load('Gray/Original/snrMap.mat');
vltSNR.org = load('Gray/Original/tSNRMap.mat');
vlCoh.org = load('Gray/Original/corAnal.mat');

vlSNR.avg = load('Gray/Averages/snrMap.mat');untitled
vltSNR.avg = load('Gray/Averages/tSNRMap.mat');
vlCoh.avg = load('Gray/Averages/corAnal.mat');

% get original ROI tSNR
for i = 1:5
ROI1_3t.org.tSNR(i,:) = getCurDataROI(VOLUME{1},'map',i);
end
% get original ROI SNR
for i = 1:5
ROI1_3t.org.SNR(i,:) = getCurDataROI(VOLUME{1},'map',i);
end
% get original ROI Coh
for i = 1:5
ROI1_3t.org.Coh(i,:) = getCurDataROI(VOLUME{1},'co',i);
end

% Get ROI average tSNR map in volume view gui
ROI1_3t.avg.tSNR(1,:) = ROI1_3t.org.tSNR(1,:);
ROI1_3t.avg.tSNR(2,:) = getCurDataROI(VOLUME{1},'map',1); % Select condition:average_12 in GUI, 3rd row next condition...

ROI1_3t.avg.SNR(1,:) = ROI1_3t.org.SNR(1,:);
ROI1_3t.avg.SNR(2,:) = getCurDataROI(VOLUME{1},'map',1);% select different conditons:average_12

ROI1_3t.avg.Coh(1,:) = ROI1_3t.org.Coh(1,:);
ROI1_3t.avg.Coh(2,:) = getCurDataROI(VOLUME{1},'co',1);

% One way to calculate avg(tSNR)
wstat(ROI1_3t.avg.tSNR(1,:)) % row1: run1; row2:r1-2; row3:r1-3; etc.
wstat(ROI1_3t.avg.SNR(1,:))
wstat(ROI1_3t.org.Coh(1:5,:)) % use original Coh rather than average Coh, because with noise average again and again, averaged Coh will increase? 

% Another way to calculate avg(tSNR): flexible combination as you want
% avg_tsnr_3t.ROI1(5,:) = sqrt( ROI1_3t.org.tSNR(1,:).^2 + ROI1_3t.org.tSNR(2,:).^2 + ROI1_3t.org.tSNR(3,:).^2 + ROI1_3t.org.tSNR(4,:).^2 + ROI1_3t.org.tSNR(5,:).^2);
% avg_tsnr_3t.ROI1(4,:) = sqrt( ROI1_3t.org.tSNR(1,:).^2 + ROI1_3t.org.tSNR(2,:).^2 + ROI1_3t.org.tSNR(3,:).^2 + ROI1_3t.org.tSNR(4,:).^2);
% avg_tsnr_3t.ROI1(3,:) = sqrt( ROI1_3t.org.tSNR(1,:).^2 + ROI1_3t.org.tSNR(2,:).^2 + ROI1_3t.org.tSNR(3,:).^2);
% avg_tsnr_3t.ROI1(2,:) = sqrt( ROI1_3t.org.tSNR(1,:).^2 + ROI1_3t.org.tSNR(2,:).^2);
% avg_tsnr_3t.ROI1(1,:) = ROI1_3t.org.tSNR(1,:);

% 7t avg2(tSNR)
% avg_tsnr_7t.ROI1(2,:) = sqrt( ROI1_7t.org.tSNR(1,:).^2 + ROI1_7t.org.tSNR(2,:).^2);
% avg_tsnr_7t.ROI1(1,:) = ROI1_7t.org.tSNR(1,:);

% plot VE
x1 = [1 2 3 4 5];
x2 = [1 2];
for i = 1:5
    A{1,i} = wstat(ROI1_3t.avg.Coh(i,:));
    a(1,i) = A{1,i}.mean;
end
B{1,1} = wstat(ROI1_7t.org.Coh(1,:));
B{1,2} = wstat(ROI1_7t.avg.Coh);
b = [B{1,1}.mean B{1,2}.mean];
figure; plot(x1,a,'b*-');hold on;
plot(x2,b,'r*-');legend('3t','7t');axis([0 6 0 1]);
xlabel('number of scans');ylabel('variance explained');title('compare ve on 3t and 7t');

% plot tSNR
x1 = [1 2 3 4 5];
x2 = [1 2];
% ROI1 3t avg1(tSNR)
for i = 1:5
    Y1{1,i} = wstat(ROI1_3t.avg.tSNR(i,:));
    y1(1,i) = Y1{1,i}.mean; 
end
% ROI1 7t avg1(tSNR)
Y2{1,1} = wstat(ROI1_7t.org.tSNR(1,:));
Y2{1,2} = wstat(ROI1_7t.avg.tSNR);
y2 = [Y2{1,1}.mean Y2{1,2}.mean];
% ROI1 3t avg2(tSNR)
% for i = 1:5
%     Y3{1,i} = wstat(avg_tsnr_3t.ROI1(i,:));
%     y3(1,i)=Y3{1,i}.mean; %roi1 3t avg2(tSNR)
% end
% % ROI1 7t avg2(tSNR)
% for i =1 :2
%     Y4{1,i} = wstat(avg_tsnr_7t.ROI1(i,:));
%     y4(1,i)=Y4{1,i}.mean;
% end
figure; 
plot(x1,y1,'b*-');hold on;
plot(x2,y2,'r*-');hold on;
% plot(x1,y3,'k*-');hold on;plot(x2,y4,'g*-');
legend('3t','7t');axis([0 6 0 180]);
xlabel('number of scans');ylabel('tSNR');title('compare tSNR on 3t and 7t');
