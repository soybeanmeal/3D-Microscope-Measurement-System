function [iErr] = GetAsyncBufferIndex(c)
%function [iErr] = GetAsyncBufferIndex(c)
FunctionName = 'PI_GetAsyncBufferIndex';
if(strmatch(FunctionName,c.dllfunctions))
	try
		[iErr] = calllib(c.libalias,FunctionName,c.ID);
	catch
		rethrow(lasterror);
	end
else
	error(sprintf('%s not found',FunctionName));
end
