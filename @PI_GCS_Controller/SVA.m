function bRet = SVA(c,szAxes,dValues)
% function bRet = SVA(c,szAxes,dValues)
FunctionName = 'PI_SVA';
if(strmatch(FunctionName,c.dllfunctions))
	pdValues = libpointer('doublePtr',dValues);
	try
		[bRet,szAxes,dValues] = calllib(c.libalias,FunctionName,c.ID,szAxes,pdValues);
	catch
		rethrow(lasterror);
	end
else
	error(sprintf('%s not found',FunctionName));
end
