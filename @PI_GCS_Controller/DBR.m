function bRet = DBR(c,iValues1)
% function bRet = DBR(c,iValues1)
FunctionName = 'PI_DBR';
if(strmatch(FunctionName,c.dllfunctions))
	try
		[bRet] = calllib(c.libalias,FunctionName,c.ID,iValues1);
	catch
		rethrow(lasterror);
	end
else
	error(sprintf('%s not found',FunctionName));
end
