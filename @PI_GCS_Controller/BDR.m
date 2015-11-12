function bRet = BDR(c,iValues1)
% function bRet = BDR(c,iValues1)
FunctionName = 'PI_BDR';
if(strmatch(FunctionName,c.dllfunctions))
	try
		[bRet] = calllib(c.libalias,FunctionName,c.ID,iValues1);
	catch
		rethrow(lasterror);
	end
else
	error(sprintf('%s not found',FunctionName));
end
