function [ y, yr ] = genAdvSamples( audio_file, segN )
% generate the adversarial samples for testing.
% input : audio_file - the audio file address.
%         segN - the number of signal segments.
% output : y - the genuine audio that needs to playback.
%          yr - the modulated audio that needs to playback.
%          the two files will store in ./output folder.
% Shu Wang

%% TEST
% clear;
% close all;
% audio_file = './samples/samples_6seg.wav';
% segN = 6;

%% Constant Path
audio_path = './samples/genuine/';
save_path = './outputs/';

%% parameters
chn = 1;            % channel number

%% reconstruct unmodulated audio
[ y, fs ] = audioread(audio_file);
y = [ zeros(2*fs, chn) ; y(:, 1:chn) ; zeros(2*fs, chn) ]; 
% plot(y);
audiowrite([save_path, 'unmodulated.wav'], y, fs);

%% reconstruct modulated audio
addpath('signalproc');
load([audio_path, 'para.mat']); % position parameters               
yr = zeros(len, chn);           % reconstructed signal
for i = 1 : segN
    % read the genuine segments.
    f_name = [num2str(i, '%04d'), '.wav'];
    [ys, fs] = audioread([audio_path, f_name]);
    
    ysr = compFilter(ys(:, 1), fs);
    
    i_r = findP(i);
    i_d = findN(i);
    yr(i_r : (i_d-1), 1) = ysr;
    
    if (chn == 2)
        ysr = compFilter(ys(:, 2), fs);
        yr(i_r : (i_d-1), 2) = ysr;
    end
end
yr = [ zeros(2*fs, chn) ; yr ; zeros(2*fs, chn)];
% plot(yr);
audiowrite([save_path, 'modulated.wav'], yr, fs);


end

