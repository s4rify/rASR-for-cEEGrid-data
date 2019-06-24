function [] = extract_calib_data(pathin, pathout)
%
% extract_calib_data.m--
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
% Sarah Blum (sarah.blum@uol.de), 2019-02-12 09:28
%-------------------------------------------------------------------------

% here lie the 3 sessions of every subject: artifact session, choi session and spe01 session which contains
% the eyes open - eyes closed data which we want to use for calibration
condition = 'spe';
% we only want to load the speaker session containing the eye task
flist = dir([pathin, '*spe01.set']);

[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;

for s = 1 : length(flist)
    EEG = pop_loadset('filename',flist(s).name,'filepath',pathin);
    [ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
    EEG = eeg_checkset( EEG );
    newname = [flist(s).name(1:end-4), '_calib'];
    % extract 60 seconds beginning with eyes-open trigger
    EEG = pop_epoch( EEG, {  'EyesOpenBegin'  }, [0  59], 'newname', newname, 'epochinfo', 'yes');
    EEG = pop_rmbase( EEG, [0  58998]);
    EEG = pop_jointprob(EEG,1,[1:16] ,2,2,1,0,0,[],0); % reject epoch if > 2 std
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'overwrite','on','gui','off'); 
    EEG = eeg_checkset( EEG );
    % save calib data for every subject in new folder for later cleaning
    EEG = pop_saveset( EEG, 'filename',newname,'filepath', pathout);
end

end
