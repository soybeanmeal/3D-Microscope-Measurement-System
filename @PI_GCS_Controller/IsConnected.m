function [bRet] = IsConnected(c)
%function [] = IsConnected(c)
FunctionName = 'PI_IsConnected';
if(strmatch(FunctionName,c.dllfunctions))
	try
		[bRet] = calllib(c.libalias,FunctionName,c.ID);
	catch
		rethrow(lasterror);
	end
else
	error(sprintf('%s not found',FunctionName));
end
