function [] = epoch_and_plot_erp(PATHIN_clean, PATHIN_filtered, PATHOUT, marker, session);
%
% epoch_and_plot.m--
%   
%
%
% Developed in Matlab 9.0.0.341360 (R2016a) on PCWIN64
% at University of Oldenburg.
% Sarah Blum (sarah.blum@uol.de), 2019-03-14 15:29
%-------------------------------------------------------------------------
flist_clean = dir([PATHIN_clean, session]);
flist_filtered = dir([PATHIN_filtered, session]);

figure('rend', 'painters', 'pos', [100,100, 1200, 800]);
supertitle('Teeth squeezing cleaned and filtered only');

for i = 1 : length(flist_clean) % they have the same length
   % load data sets
   EEGc = pop_loadset('filename',[pwd,filesep, PATHIN_clean, flist_clean(i).name]);
   EEGf = pop_loadset('filename',[pwd,filesep, PATHIN_filtered,flist_filtered(i).name]);
   
   % filter for plot
   EEG = pop_eegfiltnew(EEGf, 1,40,1650,0,[],0);
   
   % epoch
   EEGc = pop_epoch(EEGc, marker, [-1, 2]);
   EEGf = pop_epoch(EEGf, marker, [-1, 2]);
   
   % plot side by side in one big overview figure
   subplot(6,3,i)
   hold on
   title(flist_clean(i).name, 'Interpreter', 'none');
   R1 = 3; R7 = 8;
   R2 = 4; R8 = 7;
   L1 = 12; L7 = 9;
   L2 = 13; L8 = 16;
   plot(EEGf.times, mean(mean(EEGf.data([L1,L2],:,:),1),3));
   plot(EEGf.times, mean(mean(EEGf.data([L7,L8],:,:),1),3));
   ylim([-5,5]);
   %legend('filtered', 'rASR');
   
    
end

end