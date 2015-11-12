function bRet = DRT(c,iValues1,iValues2,szAxes)
% function bRet = DRT(c,iValues1,iValues2,szAxes)
FunctionName = 'PI_DRT';
if(strmatch(FunctionName,c.dllfunctions))
	piValues1 = libpointer('int32Ptr',iValues1);
	piValues2 = libpointer('int32Ptr',iValues2);
	iValues3 = length(iValues2);
	try
		[bRet,piValues1,piValues2,szAxes] = calllib(c.libalias,FunctionName,c.ID,piValues1,piValues2,szAxes,iValues3);
	catch
		rethrow(lasterror);
	end
else
	error(sprintf('%s not found',FunctionName));
end
