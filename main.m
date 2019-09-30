clear;
close all;
addpath('spectrum');

%% Discrete Analysis
[ sig, fs ] = audioread('./samples/TEST_REC_IPHONE_50.wav');
if ~exist('model/discFreqResp.mat')
    [ freqList, freqResp ] = discFreqAnalysis( sig, fs, 0.000 );
else
    load model/discFreqResp.mat;
end
clear sig fs;

%% Suppose a 1-sec test signal with 96kHz sampling rate
fs = 96000;         % TEST
sig = 1 : fs;       % TEST
N = 2^nextpow2( length(sig) );  

[fList, fResp] = contFreqAnalysis( freqList, freqResp, N, fs );
[freqFilter, respFilter] = contInvFilter( fList, fResp, 0.001 );  
% if change ep, also need to change compFilter function (real implementation).

%%