function [] = filter_ceegrid(filt, pathout)
%
% filter_ceegrid.m--
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
% Sarah Blum (sarah.blum@uol.de), 2019-02-11 15:29
%-------------------------------------------------------------------------
[ALLEEG, EEG, CURRENTSET, ALLCOM] = eeglab;
flist = dir(['data/raw/', '*.set']);


    for s = 1 : length(flist)
        EEG = pop_loadset('filename',flist(s).name,'filepath','data/raw/');
        [ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
        EEG = eeg_checkset( EEG );
        % hp filter 
        EEG = pop_eegfiltnew(EEG, [],filt,16500,1,[],0);
        [ALLEEG, EEG, CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'overwrite','on','gui','off'); 
        EEG = eeg_checkset( EEG );
        
        [ALLEEG, EEG, CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'overwrite','on','gui','off'); 
        EEG = eeg_checkset( EEG );
        EEG = pop_saveset( EEG, 'filename',flist(s).name,'filepath', pathout);
        % remove if from ALLEEG
        ALLEEG = pop_delset( ALLEEG, [1] );
    end
end