function [] = MAC_END(c)
%function [] = MAC_END(c)
FunctionName = 'PI_MAC_END';
if(strmatch(FunctionName,c.dllfunctions))
	try
		[] = calllib(c.libalias,FunctionName,c.ID)
	catch
		rethrow(lasterror);
	end
else
	error(sprintf('%s not found',FunctionName));
end
