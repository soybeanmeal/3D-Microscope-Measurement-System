function bRet = MAC_DEF(c,szAxes)
% function bRet = MAC_DEF(c,szAxes)
FunctionName = 'PI_MAC_DEF';
if(strmatch(FunctionName,c.dllfunctions))
	try
		[bRet,szAxes] = calllib(c.libalias,FunctionName,c.ID,szAxes);
	catch
		rethrow(lasterror);
	end
else
	error(sprintf('%s not found',FunctionName));
end
