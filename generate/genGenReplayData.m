function [ Vgenuine, Vreplay ] = genGenReplayData( segN )
% generate the data for genuine audio an replay audio.
% input : segN - the number of segments.
% output : Vgenuine - the features of genuine audio.
%          Vreplay - the features of replay audio.
% Shu Wang

%% TEST
% clear;
% close all;
% segN = 6;

%% Give path and parameters
genuine_path = './samples/genuine/';
replay_path = './samples/replay/';
save_file = './data/Vector.mat';

%% Load initial data
% initial_file = './data/initVector.mat';
% load(initial_file);
Vgenuine = [];
Vreplay = [];

%% Get genuine results
for i = 1 : segN
    f_name = [num2str(i, '%04d'), '.wav'];
    [y, fs] = audioread([genuine_path, f_name]);
    
    [f, amp, ~] = fastFT(y(:,1), fs);
    find2k = find(f > 2000, 1);
    find4k = find(f > 4000, 1);
    
    P = sum(amp(find2k:find4k-1).^2) / sum(amp(1:find2k-1).^2);
    Vgenuine = [Vgenuine; P];
end

%% Get replay results
for i = 1 : segN
    f_name = [num2str(i, '%04d'), '.wav'];
    [y, fs] = audioread([replay_path, f_name]);
    
    [f, amp, ~] = fastFT(y(:,1), fs);
	find2k = find(f > 2000, 1);
    find4k = find(f > 4000, 1);
    
    P = sum(amp(find2k:find4k-1).^2) / sum(amp(1:find2k-1).^2);
    Vreplay = [Vreplay; P];
end

%% Save
save(save_file, 'Vgenuine', 'Vreplay');

end