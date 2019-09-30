clear;
close all;

%% read genuine audio file and segment. (store in ./samples/genuine/)
addpath('calibration');
audio_file = './samples/samples_111seg.wav';   %-------
segN = 111;                                    %-------
[ findP, findN, intv_s, len ] = segmentaudio( audio_file, 10^-3, 1, segN);

%% reconstruct the modulated segment. (store in ./output/)
addpath('./generate');
addpath('./spectrum');
genAdvSamples( audio_file, segN );

%%-----------------------------------------------------------------------%%
% After playback the modulated and unmodulated audio files,
% We can get the modulated replay and replay audio. (store in ./samples/)
% modulated ---> modulated replay 
% unmodulated (genuine) ---> replay
%%-----------------------------------------------------------------------%%

%% read replay audio file and segment. (store in ./samples/replay)
replay_file = './samples/samples_111seg_replay.wav';  %-------
genReplay( replay_file, segN, 0 );

%% read modulated replay audio file and segment. (store in ./samples/modreplay)
modreplay_file = './samples/samples_111seg_modreplay.wav';  %-------
genModReplay( modreplay_file, segN, 0 );

%% generate the features for geniune audio and replay audio. (frequency domain)
[Vgenuine, Vreplay] = genGenReplayData( segN );

% visualize the ratio range for different replay audio.
for i = 1 : segN
    plot( 1, Vgenuine(i, :), 'bo');
    hold on;
    plot( 2, Vreplay(i, :), 'rx');
    hold on;
end
axis([0.5,2.5,0,1]);
title('Power ratio (HF/LF)');
xlabel('Audio type');
ylabel('Power ratio');
legend('Genuine audio', 'Replay audio');

%% generate the features for geniune audio and modulated replay audio. (time domain)
dim = 20;     %--------------
[Mgenuine, Mmodreplay] = genGenModData( segN, dim );

%% Visualize
% % visualize frequency domain
figure();
[y1, fs] = audioread('./samples/genuine/0001.wav');
[y2, ~] = audioread('./samples/replay/0001.wav');
[y3, ~] = audioread('./samples/modreplay/0001.wav');
addpath('signalproc');
[f, amp1, ~] = fastFT(y1(:,1), fs);
[~, amp2, ~] = fastFT(y2(:,1), fs);
[~, amp3, ~] = fastFT(y3(:,1), fs);
len = floor( 4000 * 2^nextpow2(length(y1)) / fs);
subplot(3,1,1); plot(f(3:len), amp1(3:len)); title('Genuine Audio');
subplot(3,1,2); plot(f(3:len), amp2(3:len)); title('Replay Audio');
subplot(3,1,3); plot(f(3:len), amp3(3:len)); title('ModReplay Audio');

% % visualize time domain
figure();
y1 = audioread('./samples/genuine/0001.wav');
y2 = audioread('./samples/replay/0001.wav');
y3 = audioread('./samples/modreplay/0001.wav');
subplot(3,1,1); plot(y1(11000:12000, 1)); title('Genuine Audio');
subplot(3,1,2); plot(y2(11000:12000, 1)); title('Replay Audio');
subplot(3,1,3); plot(y3(11000:12000, 1)); title('ModReplay Audio');

% % visualize extrema ratio features
figure();
for i = 1 : segN
    plot(Mgenuine(i, :), 'b');
    hold on;
    plot(Mmodreplay(i, :), 'r');
    hold on;
end
title('Extrema Ratio with different Granularities');
xlabel('Window Size');
ylabel('Extrema Ratio');
legend('Genuine audio', 'ModReplay audio');
