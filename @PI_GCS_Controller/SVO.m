function bRet = SVO(c,szAxes,iValues)
% function bRet = SVO(c,szAxes,iValues)
FunctionName = 'PI_SVO';
if(strmatch(FunctionName,c.dllfunctions))
	piValues = libpointer('int32Ptr',iValues);
	try
		[bRet,szAxes,iValues] = calllib(c.libalias,FunctionName,c.ID,szAxes,piValues);
	catch
		rethrow(lasterror);
	end
else
	error(sprintf('%s not found',FunctionName));
end
