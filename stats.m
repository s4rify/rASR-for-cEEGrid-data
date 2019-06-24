function [] = stats(PATHIN_clean, PATHIN_filtered, marker, session)
%
% stats.m--
%
%
%
% Developed in Matlab 9.0.0.341360 (R2016a) on PCWIN64
% at University of Oldenburg.
% Sarah Blum (sarah.blum@uol.de), 2019-02-12 09:28
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

    % epoch according to alpha marker
    EEGc = pop_epoch(EEGc, marker, [0, 50]);
    EEGf = pop_epoch(EEGf, marker, [0, 50]);

    plotlimits = [-20,30];
    freqrange = [2,20];
    % compute spectra but do not plot again
    [spectra_f, freqs_f, sepccomp_f, contrib_f, specstd_f] = spectopo(EEGf.data,  size(EEGf.data,2), EEGf.srate,  ...
       'percent', 100, ...
       'freqrange',freqrange,'electrodes','on', ...
        'winsize', EEGf.srate*10, ...
        'limits', [NaN, NaN, plotlimits, NaN, NaN], ...
        'plot', 'off'...
    );

    [spectra_c, freqs_c, sepccomp_c, contrib_c, specstd_c] = spectopo(EEGc.data, size(EEGc.data,2), EEGc.srate , ...
       'percent', 100,  ...
       'freqrange',freqrange,'electrodes','on', ...
        'winsize', EEGc.srate*10, ...
       'limits', [NaN, NaN, plotlimits, NaN, NaN], ...
        'plot', 'off'...
    );

    % save the values from the current subj
    SPECTRA_f(i,:,:) = spectra_f;
    FREQS_f(i,:) = freqs_f;
    SPECTRA_c(i,:,:) = spectra_c;
    FREQS_c(i,:) = freqs_c;
end

% stats here
% check whether the frequency power in the alpha range (8-13) on the best
% channel is significantly different than the power of neighboring frequencies that lie
% outside the alpha range

% paired t-test

% sanity check plot
figure;plot(FREQS_c(1,:), squeeze(SPECTRA_c(1,:,:))); % one subj, all channels, all frequencies
figure;plot(FREQS_c(1,80:130),squeeze(SPECTRA_c(1,:,80:130))); % one subj, all channels, alpha range
figure;plot(FREQS_f(1,80:130),squeeze(SPECTRA_f(1,:,80:130))); % one subj, all channels, alpha range

% % t z-transform or not to z-transform
% SPECTRA_c = zscore(SPECTRA_c);
% SPECTRA_f = zscore(SPECTRA_f);

alphabin = [80:130];
neighboringbins = [60:80, 130:150];
for s = 1: size(SPECTRA_c,1)
    % search for the channel that captures alpha best for this subject
    [amp,chan] = max( mean(SPECTRA_f(s,:,alphabin),3));
    % use this channel from now on
    peak_alpha_f(s) = max(SPECTRA_f(s,chan,alphabin)); % 8 to 13 hz
    neighboring_freqs_f(s) = mean(SPECTRA_f(s,chan,neighboringbins),3); % 
    % continue here with poster analysis
    %relative_f(s) = abs(peak_alpha_f(s))/ sum(SPECTRA_f(s,chan, :));

    peak_alpha_c(s) = max(SPECTRA_c(s,chan,alphabin)); % 8 to 13 hz
    neighboring_freqs_c(s) = mean(SPECTRA_c(s,chan,neighboringbins),3); % 
end
[H_c, P_c, CI_c, STATS_c] = ttest(peak_alpha_c, neighboring_freqs_c);
computeCohen_d(peak_alpha_c, neighboring_freqs_c);
[H_f, P_f, CI_f, STATS_f] = ttest(peak_alpha_f, neighboring_freqs_f);
computeCohen_d(peak_alpha_f, neighboring_freqs_f);

% second stat: here we do not want to compare the alpha peak versus the neighboring
% frequencies for both methods, but we want to compare the differences. If the difference
% is significant, 
diff_c = peak_alpha_c - neighboring_freqs_c;
diff_f = peak_alpha_f - neighboring_freqs_f;
[H_diff, P_diff, CI_diff, STATS_diff] = ttest(diff_f, diff_c);
computeCohen_d(diff_f, diff_c);




