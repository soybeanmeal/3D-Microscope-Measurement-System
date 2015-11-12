function foc_pos = gauss_pos(FDR,z_s,Na,c_thr)

	la = 0.5;
	z_r=(1/2)*la/(Na^2); % Rayleigh length
	
	ind_c=find(FDR>=c_thr); % Find the contrast values beyond the contrast threshold
	c_sel=FDR(ind_c); % Save the selected contrast values
	z_sel = z_s(ind_c);

	if length(ind_c) < 3
		foc_pos = NaN;
	else
		mdl = @(a,x)a(1)*exp(-(x-a(2)).^2 ./ (a(3)^2)); % Gauss
		z_pos_0=sum(c_sel.*z_sel')/sum(c_sel); % focal position from centroid
		a0 = [max(c_sel); z_pos_0; (z_sel(end)-z_sel(1))/z_r/2]; % Initial conditions
		options = optimset('Display','off','MaxIter',100,'TolX',1e-2);
		% lb=[0 z_sel(1)   0];   % lower bounds
		% ub=[2 z_sel(end) inf]; % upper bounds
		lb=[0 min(z_sel(1),z_sel(end)) 0];   % lower bounds
		ub=[2 max(z_sel(1),z_sel(end)) inf]; % upper bounds
		[koeff,resnorm,residual,exitflag,output]= lsqcurvefit(mdl,a0,z_sel',c_sel,lb,ub,options);
		foc_pos = koeff(2); % Focal position of the object point

		% Check if fit was successful
		if exitflag <= 0;
			foc_pos=NaN;
		end
	end
end