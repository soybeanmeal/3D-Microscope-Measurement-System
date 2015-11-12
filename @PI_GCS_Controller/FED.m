function [bRet] = FED(c,szAxes,iInValues1,iInValues2)
%function [bRet] = FED(c,szAxes,iInValues1,iInValues2)
FunctionName = 'PI_FED';
if(strmatch(FunctionName,c.dllfunctions))
	piInValues1 = libpointer('int32Ptr',iInValues1);
	piInValues2 = libpointer('int32Ptr',iInValues2);
	try
		[bRet,szAxes,iInValues1,iInValues2] = calllib(c.libalias,FunctionName,c.ID,szAxes,piInValues1,piInValues2);
	catch
		rethrow(lasterror);
	end
else
	error(sprintf('%s not found',FunctionName));
end
