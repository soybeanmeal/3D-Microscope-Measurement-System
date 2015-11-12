function bRet = VEL(c,szAxes,dValues)
% function bRet = VEL(c,szAxes,dValues)
FunctionName = 'PI_VEL';
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
