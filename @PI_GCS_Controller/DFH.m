function bRet = DFH(c,szAxes)
% function bRet = DFH(c,szAxes)
FunctionName = 'PI_DFH';
if(strmatch(FunctionName,c.dllfunctions))
	try
		[bRet,szAxes] = calllib(c.libalias,FunctionName,c.ID,szAxes);
	catch
		rethrow(lasterror);
	end
else
	error(sprintf('%s not found',FunctionName));
end
