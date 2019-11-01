%% this script calculates the total train duration of an EPI sequence in order to provide an input for the SPM toolbox FieldMap. It was adapted by Christian Keysers with Help from Wietske van der Zwaag from a script by Pieter Buur that calculates the echo spacing.


water_fat_shift_pixel       = 24.627; % water-fat shift per pixel to be found in the .par file, e.g. "Water Fat shift [pixels]           :   24.627

fieldstrength_tesla         = 7.0;  % magnetic field strength (T)

 

% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ not change below line ~~~~~~~~

 

water_fat_diff_ppm          = 3.35; 

resonance_freq_mhz_tesla    = 42.576; % gyromagnetic ratio for proton (1H)

water_fat_shift_hz          = fieldstrength_tesla * water_fat_diff_ppm * resonance_freq_mhz_tesla % water_fat_shift_hz 3T = 434.215 Hz

total_train_duration_ms     = water_fat_shift_pixel * 1000 / water_fat_shift_hz

