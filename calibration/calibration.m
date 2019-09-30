function [ ind, sl, el, mark ] = calibration( sig, fs )
% Calibrate the signal with the propriate start.
% input: sig - the original signal.
%        fs - the sampling rate
% output: ind - the offset of the mark.
%         sl - the start list of every segments.
%         el - the end list of every segments.
%         mark - the original distribution of signal.
% Shu Wang

%% TEST
% clear;
% [ sig, fs ] = audioread('../samples/TEST_FREQ.wav');

%% preprocess
sig = abs(sig( :, 1 ));

%% parameters
n1 = length( sig );
freqList = [ 10:10:90, 100:50:2000, 2100:100:4000 ]; %
sigInt = 1; % sec
blkInt = 1; % sec
sigT = sigInt * fs;
blkT = blkInt * fs;

%% MARK
mark = [];
for i = 1 : length( freqList ) + 2
    if i > 1
        mark = [ mark, zeros( 1, blkT ) ]; 
    end
    mark = [ mark, ones( 1, sigT ) ];
end
n2 = length( mark );

%% calibrate: get the start point
% 1st
cal = zeros( n1-n2+1, 1 );
for i = 1 : 1000 : length(cal)
    cal(i) = mark * sig( i:(i+n2-1) );
    disp( ['> ', num2str(i), '/', num2str(length(cal)), ' - ',...
        num2str(i*100/length(cal)), '%'] );
end
[ ~, ind ] = max(cal);
% 2nd
for i = max((ind-2000), 1) : 100 : min((ind+2000), length(cal))
    cal(i) = mark * sig( i:(i+n2-1) );
end
[ ~, ind ] = max(cal);
% 3rd
for i = max((ind-200), 1) : 10 : min((ind+200), length(cal))
    cal(i) = mark * sig( i:(i+n2-1) );
end
[ ~, ind ] = max(cal);
% 4th
for i = max((ind-20), 1) : 1 : min((ind+20), length(cal))
    cal(i) = mark * sig( i:(i+n2-1) );
end
[ ~, ind ] = max(cal);

%plot( 1:n1, sig, ind:(ind+n2-1), mark);

%% get the list of intervals
sl = zeros( length( freqList ), 1 );
el = zeros( length( freqList ), 1 );
sl(1) = ind + sigT + blkT;
el(1) = sl(1) + sigT;
for i = 2 : length(freqList)
    sl(i) = sl(i-1) + sigT + blkT;
    el(i) = sl(i) + sigT;
end

% for i = 1 : length(freqList)
%     plot( sig( sl(i):el(i) ) );
%     pause;
% end

end

