function [ out ] = genMultiFreq( )
% Generate multiple frequency components
% [] [1kstart] [] [..] [] [..] [] [1kend] []
% 10 : 10 : 90
% 100 : 50 : 2000
% 2100 : 100 : 4000
%
% Shu Wang

%% parameters
freqList = [ 10:10:90, 100:50:2000, 2100:100:4000 ];
sigInt = 1; % sec
blkInt = 1; % sec
fs = 96000;

%% init
sigT = sigInt * fs;
blkT = blkInt * fs;
out = [];

%% generate the audio
out = [ out, zeros( 1, blkT ) ]; 
out = [ out, genSingleFreq( 1000, sigInt, fs) ]; 

for i = 1 : length( freqList )
    out = [ out, zeros( 1, blkT ) ]; 
    out = [ out, genSingleFreq( freqList(i), sigInt, fs) ]; 
end

out = [ out, zeros( 1, blkT ) ]; 
out = [ out, genSingleFreq( 1000, sigInt, fs) ]; 
out = [ out, zeros( 1, blkT ) ];

%% write the audio to file
audiowrite('../samples/TEST_FREQ.wav', out, fs);

end

