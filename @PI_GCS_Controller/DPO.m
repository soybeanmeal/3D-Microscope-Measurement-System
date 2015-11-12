function bRet = DPO(c,szAxes)
% function bRet = DPO(c,szAxes)
FunctionName = 'PI_DPO';
if(strmatch(FunctionName,c.dllfunctions))
	try
		[bRet,szAxes] = calllib(c.libalias,FunctionName,c.ID,szAxes);
	catch
		rethrow(lasterror);
	end
else
	error(sprintf('%s not found',FunctionName));
end
