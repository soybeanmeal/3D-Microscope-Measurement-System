function [bRet] = SAI(c,s1,s2)
% function  [bRet] = SAI(c,s1,s2)
FunctionName = 'PI_SAI';
if(strmatch(FunctionName,c.dllfunctions))
	try
		[bRet,s1,s2] = calllib(c.libalias,FunctionName,c.ID,s1,s2);
	catch
		rethrow(lasterror);
	end
else
	error(sprintf('%s not found',FunctionName));
end
