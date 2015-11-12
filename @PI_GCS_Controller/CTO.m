function [bRet] = CTO(c,iValues1,iValues2,dValues,nValues)
%function [bRet] = CTO(c)
FunctionName = 'PI_CTO';
if(strmatch(FunctionName,c.dllfunctions))
	piValues = libpointer('int32Ptr',iValues1);
	piValues1 = libpointer('int32Ptr',iValues2);
	pdValues = libpointer('doublePtr',dValues);
	nValues = length(iValues1);
	try
		[bRet,iValues,iValues2,dValues] = calllib(c.libalias,FunctionName,c.ID,piValues,piValues1,pdValues,nValues);
	catch
		rethrow(lasterror);
	end
else
	error(sprintf('%s not found',FunctionName));
end
