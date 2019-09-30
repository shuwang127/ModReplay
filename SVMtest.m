function [ out1, out2 ] = SVMtest( sig, fs, th, dim )
% Input : sig - the input signal.
%         fs - the sampling rate.
%         th - the power ratio threshold.
%         dim - the dimension of time-domain feature.
% Output: out1 - the result of frequency domain check. [ 1 - high frequency
%         dominant (replay attack); 0 - low frequency dominant (normal) ] 
%         out2 - the result of time domain check. [ 1 - burr (modulated
%         replay attack); 0 - smooth (normal) ]
% Shu Wang

%% TEST
% clear;
% close all;
% [sig, fs] = audioread('./samples/modreplay/0001.wav');
% th = 0.1;
% dim = 20;

%--------------------- Check replay attack.---------------------%
%% Calculate the frequency spectrum
addpath('signalproc');
[f, amp, ~] = fastFT(sig(:, 1), fs);

%% Calculate the corresponding points of 2K / 4K
find2k = find(f > 2000, 1);
find4k = find(f > 4000, 1);

%% Calculate the ratio of HF(2K-4K) / LF(0-2K)
P = sum(amp(find2k:find4k-1).^2) / sum(amp(1:find2k-1).^2);

if (P > th)
    out1 = 1;
    disp('Frequency Domain Abnormal! [ The replay attack! ]');
else
    out1 = 0;
    disp('Frequency Domain Normal!');
end

%---------------- Check modulated replay attack.----------------%
%% Get the modulated feature
addpath('timedomain');
feature = [];
for v = 1 : dim
    [~, rt] = Peakratio(sig, v);
    feature(end+1) = rt;
end

%% Constant path
model_path = './model/SVMmodel.mat';

%% Load model
load(model_path);

%% Preprocess feature
out2 = svmpredict(0, feature, SVMSTRUCT);

%% Display
if (out2)
    disp('Time Domain Abnormal! [ The modulated replay attack! ]');
else
    disp('Time Domain Normal!');
end

end

