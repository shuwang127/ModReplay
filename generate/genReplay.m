function [ outP, outN ] = genReplay( audio_file, segN, initP )
% generate the replay segments from the recorded replay audio.
% input: audio_file - the audio file address.
%        segN - the number of segments.
%        initP - the start point of the first segment.
%                if initP == 0, adaptive calibration.
%                if initP != 0, the manual calibration.
% output: outP - findP of the replay audio.
%         outN - findN of the replay audio.
% Shu Wang

%% TEST
% clear;
% close all;
% audio_file = './samples/samples_replay.wav';
% segN = 6;
% %initP = 2.8*10^5;
% initP = 0;

%% Constant Path
addpath('./samples/');
para_path = './samples/genuine/';
save_path = './samples/replay/';

%% Parameters
load([para_path, 'para.mat']);
ext = 1; % the time added before the signal (second)

%% Read the signal
[ y, fs ] = audioread(audio_file);
y = [zeros(fs*ext, 2); y];
len = length(y);

%% Set intial mark
len_mark = max(findP(end), findN(end));
mark = zeros(1, len_mark);
for i = 1 : segN
    i_r = findP(i);
    i_d = findN(i);
    mark(i_r:(i_d-1)) = ones(1, i_d-i_r);
end

%% calibration
if (0 == initP)
    % if initP == 0, adaptive calibration
    sig = abs(y( :, 1 ));
    cal = zeros( len-len_mark+1, 1 );
    for i = 1 : 1000 : length(cal)
        cal(i) = mark * sig( i:(i+len_mark-1) );
        disp( ['> ', num2str(i), '/', num2str(length(cal)), ' - ',...
            num2str(i*100/length(cal)), '%'] );
    end
    [ ~, ind ] = max(cal);
    % 2nd
    for i = max((ind-2000), 1) : 100 : min((ind+2000), length(cal))
        cal(i) = mark * sig( i:(i+len_mark-1) );
    end
    [ ~, ind ] = max(cal);
    % 3rd
    for i = max((ind-200), 1) : 10 : min((ind+200), length(cal))
        cal(i) = mark * sig( i:(i+len_mark-1) );
    end
    [ ~, ind ] = max(cal);
    % 4th
    for i = max((ind-20), 1) : 1 : min((ind+20), length(cal))
        cal(i) = mark * sig( i:(i+len_mark-1) );
    end
    [ ~, ind ] = max(cal);
    shift = ind - 1;
else
    % if initP != 0
    shift = initP - findP(1);
end
plot(1:len, y(:,1), shift+(1:len_mark), 0.05*mark);

%% Save the segments
for i = 1 : segN
    i_r = findP(i) + shift;
    i_d = findN(i) + shift;
    y_save = y(i_r : (i_d-1), :);
    % plot(y_save);
    
    f_name = [num2str(i, '%04d'), '.wav'];
    audiowrite([save_path, f_name], y_save, fs);
end

%% Calculate only for the outputs
outP = findP + shift - fs*ext;
outN = findN + shift - fs*ext;

end

