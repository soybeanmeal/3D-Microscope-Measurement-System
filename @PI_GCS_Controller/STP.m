function [] = STP(c)
%function [] = STP(c)
FunctionName = 'PI_STP';
if(strmatch(FunctionName,c.dllfunctions))
	try
		[] = calllib(c.libalias,FunctionName,c.ID)
	catch
		rethrow(lasterror);
	end
else
	error(sprintf('%s not found',FunctionName));
end
