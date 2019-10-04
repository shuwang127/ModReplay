function [ freqList, freqResp ] = discFreqAnalysis( sig, fs, ep )
% Analyze the discrete frequency components for a signal.
% input: sig - the signal
%        fs - sampling rate
%        ep - small value, the low threshold of frequency response.
% output: freqList - frequency List (Hz)
%         freqResp - frequency Response (No unit)
% Shu Wang

%% TEST
% [ sig, fs ] = audioread('./samples/TASCAM_0123.wav');

%% parameters
freqList = [ 10:10:90, 100:50:2000, 2100:100:4000 ]; %

%% calibration
addpath('calibration');
[ ind, sl, el, mark ] = calibration( sig, fs );

%% visualize
figure();
plot( 1:length(sig), sig, (ind-1):(length(mark)+ind), [0,mark,0] );
for i = 1 : length(sl)
    hold on;
    plot( sl(i), 0, 'b*' );
    hold on;
    plot( el(i), 0, 'go' );
end

%%
addpath('signalproc');
freqResp = zeros(size(freqList));
for i = 1 : length(freqList)
%     freq = freqList(i);
    seg = sig( sl(i):(el(i)-1) );
%     [ f, amp, ~ ] = fastFT( seg(10:end-10), fs );
%     % interpolation method
%     idx = find(freq < f, 1);
%     li = freq - f(idx-1);
%     ui = f(idx) - freq;
%     freqResp(i) = (ui * amp(idx-1) + li * amp(idx)) / (ui + li);
%     % max value method
%     % freqResp(i) = max( amp(1:end-1) );
    freqResp(i) = amplitudeStat(seg(10:end-10), 10);
end
freqResp( freqResp < ep ) = ep;

%% visualize
figure();
plot( freqList, freqResp );
title('Discrete Frequency Response');
xlabel('Frequency (Hz)');
ylabel('Frequency Response');

%% save discrete values
save model/discFreqResp.mat freqList freqResp;

end

