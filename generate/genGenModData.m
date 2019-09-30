function [ Mgenuine, Mmodreplay ] = genGenModData( segN, vr )
% generate the data for genuine audio and modulated replay audio.
% input : segN - the number of segments.
%         vr - the dimension of the features (depth of granularity)
% output : Mgenuine - the features of genuine audio.
%          Mmodreplay - the features of modulated replay audio.
% Shu Wang

%% TEST
% clear;
% close all;
% vr = 20;
% segN = 100;

%% Constant Path
genuine_path = './samples/genuine/';
modreplay_path = './samples/modreplay/';
save_file = './data/Matrix.mat';
addpath('timedomain');

%% Load initial data
% initial_file = './data/initMatrix.mat';
% load(initial_file);
Mgenuine = [];
Mmodreplay = [];

%% Get genuine data
for i = 1 : segN
    f_name = [num2str(i, '%04d'), '.wav'];
    [y, ~] = audioread([genuine_path, f_name]);
    
    rlist = [];
    for v = 1 : vr
        [~, rt] = Peakratio(y, v);
        rlist(end+1) = rt;
    end
    
    Mgenuine = [Mgenuine; rlist];
end

%% Get modulated data
for i = 1 : segN
    f_name = [num2str(i, '%04d'), '.wav'];
    [y, ~] = audioread([modreplay_path, f_name]);
    
    rlist = [];
    for v = 1 : vr
        [~, rt] = Peakratio(y, v);
        rlist(end+1) = rt;
    end

    Mmodreplay = [Mmodreplay; rlist];
end

%% Save
save(save_file, 'Mgenuine', 'Mmodreplay');

end

