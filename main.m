function [] = main()
%
% main.m--
%
% Input arguments: 
%
% Output arguments: 
%
% Other m-files required:   
%
% Example usage:   
%
%
% Developed in Matlab 9.0.0.341360 (R2016a) on PCWIN64
% at University of Oldenburg.
% Sarah Blum (sarah.blum@uol.de), 2019-02-11 14:07
%-------------------------------------------------------------------------

% read in xdf files and save including channel names as set file in data/
load_ceegrid_data();

% filter set files 1-60 Hz and save in data/filtered/
filter_ceegrid(0.1,'data/filtered/preprocessed/');
%filter_ceegrid(1,40,'data/filtered/ERP/');


% extract calibration data from eyes open condition
extract_calib_data('data/filtered/preprocessed/', 'data/calibdata/');

%% use rASR
%rASR('*choi.set'); % look at ERP here
TIMES_art = rASR( '*art.set'); % look  at EMG here
TIMES_spe = rASR('*spe01.set'); % look a alpha here

% info for computational efficiency
mean(cell2mat(TIMES_art));
std(cell2mat(TIMES_art));
 

% time-domain EMG plot
PATHIN_clean = 'data/rASRout/';
PATHIN_filtered = 'data/filtered/preprocessed/';
marker = {'SqueezeTeeth'};
PATHOUT = 'Figures/Artifacts/';
epoch_and_plot(PATHIN_clean, PATHIN_filtered, PATHOUT, marker, '*art.set');

% EMG
PATHIN_clean = 'data/rASRout/';
PATHIN_filtered = 'data/filtered/preprocessed/';
marker = {'SqueezeTeeth'};
PATHOUT = 'Figures/Signal/';
epochlen = [0,2];
window = 2; % seconds for the spectrum
epoch_and_plot_freq(PATHIN_clean, PATHIN_filtered, PATHOUT, marker, '*art.set', [1 100], epochlen, window);

% alpha
PATHIN_clean = 'data/rASRout/';
PATHIN_filtered = 'data/filtered/preprocessed/';
marker = {'EyesClosedBegin'};
PATHOUT = 'Figures/Signal/';
epochlength = [0, 50];
window = 10; % seconds for the spectrum
epoch_and_plot_freq(PATHIN_clean, PATHIN_filtered, PATHOUT, marker, '*spe01.set', [2,20], epochlength, window);

%  stats: alpha
PATHIN_clean = 'data/rASRout/';
PATHIN_filtered = 'data/filtered/preprocessed/';
marker = {'EyesClosedBegin'};
stats(PATHIN_clean, PATHIN_filtered, marker, '*spe01.set');

% stats_ EMG (in time domain, not in frequency domain
PATHIN_clean = 'data/rASRout/';
PATHIN_filtered = 'data/filtered/preprocessed/';
marker = {'SqueezeTeeth'};
stats_EMG(PATHIN_clean, PATHIN_filtered, marker, '*art.set')


% this was not used so far
% one page paper: speech spectra
PATHIN_clean = 'data/rASRout/';
PATHIN_filtered = 'data/filtered/preprocessed/';
PATHOUT = 'Figures/Signal/';
marker = {'Smile'};
epochlen = [0,2];
window = 2; % seconds for the spectrum
epoch_and_plot_freq_speech(PATHIN_clean, PATHIN_filtered, '*art.set', [1 100], epochlen, window, marker);
% one page paper: speech time course
PATHIN_clean = 'data/rASRout/';
PATHIN_filtered = 'data/filtered/preprocessed/';
marker = {'MoveJaw', 'speak_up', 'speak_softer', 'speak_on'};
PATHOUT = 'Figures/Artifacts/';
epoch_and_plot(PATHIN_clean, PATHIN_filtered, PATHOUT, marker, '*art.set');

