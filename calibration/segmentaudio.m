function [ findP, findN, intv_s, len ] = segmentaudio( audio_file, th, mode, argN)
% Segment the input audio into multiple segments.
% input: audio_file : the audio file address.
%        th : threshold to segment the signal power.
%        mode : The segment mode (1 or 0)
%        argN : if mode == 1, segment based on signal number.
%               argN is the number of signals.
%               if mode == 0, segment based on power threshold.
%               argN is the power threshold.
% output: findP : 1 position of 0->1.
%         findN : 0 position of 1->0.
%         intv_s : the sort results of intervals.
%         len : extended length of signal.
% Shu Wang

%% TEST
% clear;
% close all;
% audio_file = './samples/samples_6seg.wav';
% th = 1 * 10^-3;
% mode = 1; argN = 6;
% % mode = 0; argN = 3000;

%% set parameters
if (mode)               % 1 : segment number; 0 : threshold;
    segN = argN;
else
    intv_th = argN;
end
extlen = 10;

%% Constant Path
save_path = './samples/genuine/'; % relatively constant

%% read audio file.
[ y, fs ] = audioread(audio_file);
y = [ zeros(extlen,2) ; y ; zeros(extlen,2)];
len = max(size(y));

% show the waveform.
% plot(1:len, y(:, 1));

%% calculate signal power
pw = y(:, 1) .^ 2;      % calculate the power.
mark = (pw > th);       % the power is greater than th 0/1
% show signal power
% plot(1:len, pw, 1:len, mark*max(pw)/20);

%% calculate the derivative of mark
mark_dev = [ 0; mark(2:end) - mark(1:(end-1))];
findP = find(mark_dev == 1);                % get all the rising
findN = find(mark_dev == -1);               % get all the dropping
intv = findP(2:end) - findN(1:(end-1));     % get all the gaps
intv_s = sort(intv, 'descend');             % sort for the gaps

%% calculate the threshold for selecting gaps.
if (mode)
    intv_th = intv_s(segN) + 1;
else
    intv_th = intv_th;
%     % adaptive selection : 
%     ratio = intv_s(1:end-1) ./ intv_s(2:end);
%     [~, ind] = max(ratio);
%     intv_th = intv_s(ind+1) + 1;
end

%% remove the small gaps.
for i = 1 : length(intv)
    i_d = findN(i);
    i_r = findP(i+1);
    iv = i_r - i_d;
    if (iv < intv_th)
        mark_dev(i_r) = 0;
        mark_dev(i_d) = 0;
    end
end

%% get new P and N.
findP = find(mark_dev == 1);	% get all the rising
findN = find(mark_dev == -1);   % get all the dropping

%% reconstruct the large gaps.
mark_r = zeros(size(mark));
s = 0;
for i = 1 : len
    s = s + mark_dev(i);
    mark_r(i) = s;
end
% save important value: findP findN intv_s len
save([save_path, 'para.mat'], 'findP', 'findN', 'intv_s', 'len');

%% visualize
plot(1:len, pw, 1:len, 0.05 * mark_r); ylim([0, 0.05]);

%% segmentation
seg_num = length(findP);
for i = 1 : seg_num
    i_r = findP(i);
    i_d = findN(i);
    y_save = y(i_r : (i_d-1), :);
    % plot(y_save);
    
    f_name = [num2str(i, '%04d'), '.wav'];
    audiowrite([save_path, f_name], y_save, fs);
end

end

