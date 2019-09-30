function [freqFilter, respFilter] = contInvFilter( fList, fResp, ep )
% Calculate the inverse filter based on continuous frequency response
% input: fList - continuous frequency list
%        fResp - continuous frequency response
%        ep - very small value, ep can be fResp(fList==500Hz)
% output: freqFilter - frequency list of inverse filter
%         respFilter - frequency response of inverse filter

%% preprocess
fResp( fResp < ep ) = ep;

%% inverse
freqFilter = fList;
respFilter = 1 ./ fResp;

%% visualize
% figure();
% plot( freqFilter, respFilter );
% title('Inverse Filter Frequency Response');
% xlabel('Frequency (Hz)');
% ylabel('Frequency Response');

end

