function [ yr ] = compFilter( y, fs )
% Compensated filter used to filter single-channel signals.
% input : y - a single channel signal.
%         fs - the sampling rate.
% output : yr - the modulated signal after filtering.
% Shu Wang 2019-09-20

%% TEST
% clear;
% close all;
% [y, fs] = audioread('./samples/genuine/0001.wav');
% y = y(:, 1);
% addpath('signalproc');
% addpath('spectrum');

%% FFT
[~, amp, ph] = fastFT( y(:,1), fs );
N = 2^nextpow2(length(y));

% generate inverse filter
load model/discFreqResp.mat;
[fList, fResp] = contFreqAnalysis( freqList, freqResp, N, fs );
[freqFilter, respFilter] = contInvFilter( fList, fResp, 0.001 );  % need to confirm
invFilter = zeros(size(amp));
invLen = length(freqFilter);
invFilter(1:invLen) = respFilter;
invFilter(end-invLen+1:end) = respFilter(end:-1:1);

% modulate the amplitude spectrum
amp_r = amp .* invFilter;

% signal power balance
pw = sum(amp(1:invLen) .^ 2);
pw_r = sum(amp_r(1:invLen) .^ 2);
scale = pw / pw_r;   % power
amp_r = amp_r * sqrt(scale);

%% visualize
% spkFilter = zeros(size(amp));
% spkFilter(1:invLen) = fResp;
% spkFilter(end-invLen+1:end) = fResp(end:-1:1);
% amp_rr = amp_r .* spkFilter / sqrt(scale);
% figure();
% subplot(3,1,1); plot((1:invLen), amp(1:invLen)); title('genuine');
% subplot(3,1,2); plot((1:invLen), amp_r(1:invLen)); title('modulated');
% subplot(3,1,3); plot((1:invLen), amp_rr(1:invLen)); title('modulated replay');

%% IFFT
z = amp_r .* exp(1i * ph);
yr = real(ifft(z) * N / 2);
yr = yr(1:length(y));

%% visualize
% zr = amp_rr .* exp(1i * ph);
% yrr = real(ifft(zr) * N / 2);
% yrr = yrr(1:length(y));
% figure();
% subplot(3,1,1); plot(y(1000:2000, 1)); title('Genuine Audio');
% subplot(3,1,2); plot(yr(1000:2000, 1)); title('Modulated Audio');
% subplot(3,1,3); plot(yrr(1000:2000, 1)); title('ModReplay Audio (Sim)');


end

