folder = 'C:\Users\Labor\Documents\MATLAB\test0';
addpath(genpath(folder));
cd(folder);

row = 1024;
column = 1280;
N = 159; % N: number of z positions

for i = 1:1:N
	a(i) = load(['contrast_',num2str(i),'.mat']);
end

% % pos_mat: {'x target/mm','x actual/mm','x error/um','z target/mm','z actual/mm','z error/nm'}
load('pos_mat.mat');
% get the z actual position/mm
z_s = cell2mat(pos_mat(2:N+1,5));

Na = 0.85;
c_thr = 0.2;

for i = 1:1:row
	for j = 1:1:column
		for k = 1:1:N
			FDR(k) = a(k).contrast(i,j);
		end
		% foc_pos = find_focal_pos(algorithm,FDR,z_s,Na,c_thr)
		% algorithm: 'FPS','parable','gauss'
		% FDR: contrast(i,j,:) corresponds to z position z_s
		% z_s: z actual position
		% Na: numerical aperture of the microscope objective
		% c_thr: contrast threshold
		% foc_pos = find_focal_pos('gauss',FDR,z_s,Na,c_thr);
		foc_pos = gauss_pos(FDR,z_s,Na,c_thr);
		measure_pos(i,j) = foc_pos;
    end
    if mod(i,16) == 0
        fprintf('current row is %i.\n',i);
    end
end

save('measure_pos.mat','measure_pos');

measure = (measure_pos - min(min(measure_pos))) * 10^3; % um
save('measure.mat','measure');