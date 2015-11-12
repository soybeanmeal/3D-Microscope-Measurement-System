function iValues = qRON(c,szAxes)
% function iValues = qRON(c,szAxes)
FunctionName = 'PI_qRON';
if(strmatch(FunctionName,c.dllfunctions))
	if(nargin==1)
		szAxes = '';
	end
	len = length(szAxes);
	if(len == 0)
			len = c.NumberOfAxes;
	end
	if(len == 0)
		return;
	end
	iValues = zeros(len,1);
	piValues = libpointer('int32Ptr',iValues);
	try
		[ret,szAxes,iValues] = calllib(c.libalias,FunctionName,c.ID,szAxes,piValues);
		if(ret==0)
			error('function failed');
		end
	catch
		rethrow(lasterror);
	end
else
	error(sprintf('%s not found',FunctionName));
end
