function [iOutValues] = qOSN(c,iInValues)
%function [iOutValues] = qOSN(c,iInValues)
FunctionName = 'PI_qOSN';
if(strmatch(FunctionName,c.dllfunctions))
	piValues = libpointer('int32Ptr',iInValues);
	iOutValues = zeros(size(iInValues));
	piOutValues = libpointer('int32Ptr',iOutValues);
	nValues = length(iInValues);
	try
		[bRet,iValues,iOutValues] = calllib(c.libalias,FunctionName,c.ID,piValues,piOutValues,nValues);
	catch
		rethrow(lasterror);
	end
else
	error(sprintf('%s not found',FunctionName));
end
