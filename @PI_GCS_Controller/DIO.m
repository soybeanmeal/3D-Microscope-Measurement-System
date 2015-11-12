function [bRet] = DIO(c,iValues1,iValues2)
%function [bRet] = DIO(c,iValues1,iValues2)
FunctionName = 'PI_DIO';
if(strmatch(FunctionName,c.dllfunctions))
	piValues1 = libpointer('int32Ptr',iValues1);
	piValues2 = libpointer('int32Ptr',iValues2);
	nValues = length(iValues1);
	try
		[bRet] = calllib(c.libalias,FunctionName,c.ID,piValues1,piValues2,nValues);
	catch
		rethrow(lasterror);
	end
else
	error(sprintf('%s not found',FunctionName));
end
