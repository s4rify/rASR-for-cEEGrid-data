function [] = load_ceegrid_data()
    %
    % load_and_preprocess.m--
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
    % Sarah Blum (sarah.blum@uol.de), 2019-02-11 14:08
    %-------------------------------------------------------------------------
    % path things
    pathin_raw = 'Otto_folders\Rawdata\'; % art, then choi, then spe01 for every subject
    pathout_raw = 'data\raw\'; % all set files will be here
    flist = dir([pathin_raw, '*.xdf']);
    
    % boot eeglab once
    [ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
    
    % read in xdf files and save as *.set files
    for s = 1 : length(flist)
        % create file name
        filename = flist(s).name;
        % make set from cEEGrid data including channel names: streamname EEG is ceegrid
        EEG = import_stuff(pathin_raw, filename, pathout_raw);
    end
    
    
    
    function EEG = import_stuff(pathname_in, filename, pathname_out)
        EEG = pop_loadxdf([pathname_in, filename], 'streamname', 'EEG', 'exclude_markerstreams', {'Keyboard' 'BrainAmpSeries-Markers'});
        [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 0,'setname',[filename],'gui','off');
        EEG = correct_channel_names_ceegrid1(EEG, 'smarting v27');
        EEG = eeg_checkset( EEG );
        EEG=pop_chanedit(EEG, 'lookup','elec_cEEGrid.elp','lookup','elec_cEEGrid.elp');
        EEG = eeg_checkset( EEG );
        EEG = pop_saveset( EEG, 'filename',[filename],'filepath',pathname_out);
        % remove if from ALLEEG
    end
end

