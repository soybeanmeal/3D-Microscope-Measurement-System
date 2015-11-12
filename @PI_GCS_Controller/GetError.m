function [iErr] = GetError(c)
%function [iErr] = GetError(c)
FunctionName = 'PI_GetError';
if(strmatch(FunctionName,c.dllfunctions))
	try
		[iErr] = calllib(c.libalias,FunctionName,c.ID);
	catch
		rethrow(lasterror);
	end
else
	error(sprintf('%s not found',FunctionName));
end
