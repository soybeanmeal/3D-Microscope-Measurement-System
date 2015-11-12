function bRet = GOH(c,szAxes)
% function bRet = GOH(c,szAxes)
FunctionName = 'PI_GOH';
if(strmatch(FunctionName,c.dllfunctions))
	try
		[bRet,szAxes] = calllib(c.libalias,FunctionName,c.ID,szAxes);
	catch
		rethrow(lasterror);
	end
else
	error(sprintf('%s not found',FunctionName));
end
