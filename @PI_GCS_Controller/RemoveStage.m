function bRet = RemoveStage(c,szAxes)
% function bRet = RemoveStage(c,szAxes)
FunctionName = 'PI_RemoveStage';
if(strmatch(FunctionName,c.dllfunctions))
	try
		[bRet,szAxes] = calllib(c.libalias,FunctionName,c.ID,szAxes);
	catch
		rethrow(lasterror);
	end
else
	error(sprintf('%s not found',FunctionName));
end
