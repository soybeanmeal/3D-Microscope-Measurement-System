function [] = WGR(c)
%function [] = WGR(c)
FunctionName = 'PI_WGR';
if(strmatch(FunctionName,c.dllfunctions))
	try
		[] = calllib(c.libalias,FunctionName,c.ID)
	catch
		rethrow(lasterror);
	end
else
	error(sprintf('%s not found',FunctionName));
end
