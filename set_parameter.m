addpath(genpath('C:\Users\Oliver\Documents\MATLAB\3D_Microscope_System'));
cd('C:\Users\Oliver\Documents\MATLAB\3D_Microscope_System');
load('parameter.mat');
% set 'grating period/um'
parameter{2,1} = 84.8;
% set 'steps per period'
parameter{2,2} = 4;
% set 'original position/mm'
parameter{2,3} = 10.5;
save('parameter.mat','parameter');