function [] = EnableTCPIPScan(c)
%function [] = EnableTCPIPScan(c)
FunctionName = 'PI_EnableTCPIPScan';
if(strmatch(FunctionName,c.dllfunctions))
	try
		[] = calllib(c.libalias,FunctionName,c.ID)
	catch
		rethrow(lasterror);
	end
else
	error(sprintf('%s not found',FunctionName));
end
