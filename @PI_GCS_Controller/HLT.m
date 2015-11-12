function bRet = HLT(c,szAxes)
% function bRet = HLT(c,szAxes)
FunctionName = 'PI_HLT';
if(strmatch(FunctionName,c.dllfunctions))
	try
		[bRet,szAxes] = calllib(c.libalias,FunctionName,c.ID,szAxes);
	catch
		rethrow(lasterror);
	end
else
	error(sprintf('%s not found',FunctionName));
end
