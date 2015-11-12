function bRet = DRC(c,iValues1,szAxes,iValues2)
% function bRet = DRC(c,iValues1,szAxes,iValues2)
FunctionName = 'PI_DRC';
if(strmatch(FunctionName,c.dllfunctions))
	piValues1 = libpointer('int32Ptr',iValues1);
	piValues2 = libpointer('int32Ptr',iValues2);
	try
		[bRet,piValues1,szAxes,piValues2] = calllib(c.libalias,FunctionName,c.ID,piValues1,szAxes,piValues2);
	catch
		rethrow(lasterror);
	end
else
	error(sprintf('%s not found',FunctionName));
end
