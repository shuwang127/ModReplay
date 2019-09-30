function [ fList, fResp ] = contFreqAnalysis( freqList, freqResp, N, fs )
% Analyze the continuous frequency components for a signal.
% input: freqList - discrete frequency list
%        freqResp - discrete frequency response
%        N - number of FFT points
%        fs - sampling rate of the test signal
% output: fList - continuous frequency list
%         fResp - continuous frequency response
% Shu Wang

%% TEST
% [ sig, fs ] = audioread('./samples/TASCAM_0123.wav');

%% Discrete Analysis
% if ~exist('model/discFreqResp.mat')
%     [ freqList, freqResp ] = discFreqAnalysis( sig, fs );
%     figure();
%     plot( freqList, freqResp );
%     title('Discrete Frequency Response');
%     xlabel('Frequency (Hz)');
%     ylabel('Frequency Response');
% else
%     load model/discFreqResp.mat;
% end

%% Cubic Spline Interpolation
% N = 2^nextpow2( length(1:fs) );  % TEST
fdelta = fs / N;
fend = ceil( freqList(end) / fdelta );
fList = fs / N * (0:1:fend); % 0 to [freqList(end)]
fResp = spline( [0,freqList], [freqResp(1),freqResp], fList );

% figure();
% plot( fList, fResp );
% title('Continuous Frequency Response');
% xlabel('Frequency (Hz)');
% ylabel('Frequency Response');

end

