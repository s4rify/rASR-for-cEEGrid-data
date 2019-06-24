function [] = epoch_and_plot_freq(PATHIN_clean, PATHIN_filtered, PATHOUT, marker, session, freqrange, epochlen, window)
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
[ALLEEG, EEG, CURRENTSET, ALLCOM] = eeglab;
ALLEEG_c = ALLEEG;
ALLEEG_f = ALLEEG;
for i = 1 : length(flist_clean) % they have the same length
    % load data sets
    EEGc = pop_loadset('filename',[pwd,filesep, PATHIN_clean, flist_clean(i).name]);
    [ALLEEG_c, ~, ~] = eeg_store( ALLEEG_c, EEGc, i);
    EEGf = pop_loadset('filename',[pwd,filesep, PATHIN_filtered,flist_filtered(i).name]);
    [ALLEEG_f, ~, ~] = eeg_store( ALLEEG_f, EEGf, i);
end
MERGED_c = pop_mergeset(ALLEEG_c, 1:size(ALLEEG_c,2), false);
MERGED_f = pop_mergeset(ALLEEG_f, 1:size(ALLEEG_f,2), false);


EEG_c = pop_epoch(MERGED_c, marker, epochlen);
EEG_f = pop_epoch(MERGED_f, marker, epochlen);

plotlimits = [-20,30];

if freqrange(2) > 40 % this is the EMG case, no topo needed
    figure('rend', 'painters', 'pos', [100,100,1280,800]);
    subplot(1,2,1)
    pop_spectopo(EEG_f, 1,  [], 'EEG',  ...
        'percent', 100, ... 
        'freqrange',freqrange,'electrodes','on', ...
        'winsize', EEG_f.srate*window, ...
        'limits', [NaN, NaN, plotlimits, NaN, NaN] ...
        ...'title', 'filtered only'...
        );
    set(gca, 'FontSize', 20);
    
    subplot(1,2,2)
    pop_spectopo(EEG_c, 1,  [], 'EEG',  ...
        'percent', 100,  ...
        'freqrange',freqrange,'electrodes','on', ...
        'winsize', EEG_c.srate*window, ...
        'limits', [NaN, NaN, plotlimits, NaN, NaN] ...
        ...'title', 'rASR cleaned'...
        );
    set(gca, 'FontSize', 20);
    
else % alpha case, let's have a topo, shall we
    figure('rend', 'painters', 'pos', [100,100,1280,800]);
    subplot(1,2,1)
    pop_spectopo(EEG_f, 1,  [], 'EEG',  ...
        'percent', 100, 'freq', [9.4], ...
        'freqrange',freqrange,'electrodes','on', ...
        'winsize', EEG_f.srate*10, ...
        'limits', [NaN, NaN, plotlimits, NaN, NaN] ...
        ...'title', 'Filtered only'...
        );
    set(gca, 'FontSize', 20);
    subplot(1,2,2)
    pop_spectopo(EEG_c, 1,  [], 'EEG',  ...
        'percent', 100, 'freq', [9.4], ...
        'freqrange',freqrange,'electrodes','on', ...
        'winsize', EEG_c.srate*10, ...
        'limits', [NaN, NaN, plotlimits, NaN, NaN] ...
        ...'title', 'rASR cleaned'...
        );
    set(gca, 'FontSize', 20);
end




end


