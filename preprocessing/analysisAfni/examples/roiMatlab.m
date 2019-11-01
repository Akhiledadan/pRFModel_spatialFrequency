function showPeaks(myN,myTitle,myPNG,name)
% show the the peaks
% usage:
%           showPeaks(N,Title,FileName)
%           http://scriptdemo.blogspot.ca

if nargin~=4
   disp('Usage: ')
   disp(' showPeaks(N,Title,FileName) ')
   return
end

sprintf('%d',myN)
sprintf('%s',name)

hf=figure('visible','off');
set(hf,'color','w','render','zbuffer');
hp=pcolor(peaks(myN));
set(hp,'linestyle','none');
title(myTitle,'fontweight','bold','fontsize',16);
set(gca,'linewidth',2)
eval(['print -dpng -r300 ',myPNG,'.png'])
close;
exit
