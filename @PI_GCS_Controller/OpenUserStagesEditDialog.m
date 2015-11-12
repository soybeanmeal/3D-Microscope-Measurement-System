function [] = OpenUserStagesEditDialog(c)
%function [] = OpenUserStagesEditDialog(c)
FunctionName = 'PI_OpenUserStagesEditDialog';
if(strmatch(FunctionName,c.dllfunctions))
	try
		[] = calllib(c.libalias,FunctionName,c.ID)
	catch
		rethrow(lasterror);
	end
else
	error(sprintf('%s not found',FunctionName));
end
