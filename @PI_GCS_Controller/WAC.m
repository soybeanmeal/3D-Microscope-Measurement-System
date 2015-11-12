function bRet = WAC(c,szAxes)
% function bRet = WAC(c,szAxes)
FunctionName = 'PI_WAC';
if(strmatch(FunctionName,c.dllfunctions))
	try
		[bRet,szAxes] = calllib(c.libalias,FunctionName,c.ID,szAxes);
	catch
		rethrow(lasterror);
	end
else
	error(sprintf('%s not found',FunctionName));
end
