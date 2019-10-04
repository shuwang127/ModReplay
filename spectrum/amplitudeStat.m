function [ amp ] = amplitudeStat( sig, n )
% Stat the amplitude of the signal.
% Input: sig - the input signal.
%        n - the segment number.
% Output: the amplitude of the signal.
% Shu Wang

% segment parameters
% n = 20;

% Calculate the total length and the segment length.
len = length(sig);
seg_len = floor( len / n );

% Stat the amplitude of each segment.
stat = zeros(n, 1);
for i = 1 : n
    stat(i) = range( sig(1 + (i-1)*seg_len : i*seg_len) ) / 2; 
end

% Calculate the average of the stat value.
amp = sum(stat) / n;

end

