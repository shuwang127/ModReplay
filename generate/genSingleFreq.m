function [ out ] = genSingleFreq( freq, time, fs )
% Generate a wave with a single frequency.
% Input:  freq - The output frequency (Hz)
%         time - The output time (s)
%         fs - The sampling rate to write (Hz/s)
% Output: out - The output wave.
%
% Shu Wang

%% TEST
% freq = 1000;
% time = 1;
% fs = 96000;

total = time * fs;
in = (1 : total) / fs;
out = sin( 2 * pi * freq * in );

%% TEST
% plot(out);

end

