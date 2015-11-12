function bRet = MEX(c,szAxes)
% function bRet = MEX(c,szAxes)
FunctionName = 'PI_MEX';
if(strmatch(FunctionName,c.dllfunctions))
	try
		[bRet,szAxes] = calllib(c.libalias,FunctionName,c.ID,szAxes);
	catch
		rethrow(lasterror);
	end
else
	error(sprintf('%s not found',FunctionName));
end
