function bRet = RTO(c,szAxes)
% function bRet = RTO(c,szAxes)
FunctionName = 'PI_RTO';
if(strmatch(FunctionName,c.dllfunctions))
	try
		[bRet,szAxes] = calllib(c.libalias,FunctionName,c.ID,szAxes);
	catch
		rethrow(lasterror);
	end
else
	error(sprintf('%s not found',FunctionName));
end
