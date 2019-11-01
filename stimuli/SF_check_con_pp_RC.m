% script tpo quickly check the contrast and power spectrum of the bar
% stimuli after applying the raised cosine edge 
tmp_1 = checks(:,:,1);
tmp_2 = tmp_1(:);
idx_tmp_var = tmpvar > 0;
tmp_3 = tmp_2(idx_tmp_var);
tmp = imagestat(tmp_3);
disp(tmp.contrast);

display.screensizeinpixels = 1080;
display.height = 39.29;
display.distance = 220;
display.screensizeindeg = rad2deg(atan(display.height./(2*display.distance))); % radius
display.stepsindeg = linspace(-display.screensizeindeg,display.screensizeindeg,display.screensizeinpixels);

% x axis for plotting frequncy spectrum
x0 = linspace(0,display.screensizeinpixels/(2*display.screensizeindeg)/2,display.screensizeinpixels/2+1);

pp = powerspec(tmp_1);
figure, loglog(x0,pp);