function [bRet,iOutValues1] = IsRunningMacro(c)
%function [bRet,iOutValues1] = IsRunningMacro(c)
FunctionName = 'PI_IsRunningMacro';
if(strmatch(FunctionName,c.dllfunctions))
	iOutValues1 = zeros(1);
	piOutValues1 = libpointer('int32Ptr',iOutValues1);
	try
		[bRet,iOutValues1] = calllib(c.libalias,FunctionName,c.ID,piOutValues1);
	catch
		rethrow(lasterror);
	end
else
	error(sprintf('%s not found',FunctionName));
end
