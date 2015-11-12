function bRet = FNL(c,szAxes)
% function bRet = FNL(c,szAxes)
FunctionName = 'PI_FNL';
if(strmatch(FunctionName,c.dllfunctions))
	try
		[bRet,szAxes] = calllib(c.libalias,FunctionName,c.ID,szAxes);
	catch
		rethrow(lasterror);
	end
else
	error(sprintf('%s not found',FunctionName));
end
