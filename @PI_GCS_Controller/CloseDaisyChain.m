function CloseDaisyChain(c)
%function CloseDaisyChain(c)
FunctionName = 'PI_CloseDaisyChain';
if(strmatch(FunctionName,c.dllfunctions))
	try
		calllib(c.libalias,FunctionName,c.ID);
	catch
		rethrow(lasterror);
	end
else
	error(sprintf('%s not found',FunctionName));
end
