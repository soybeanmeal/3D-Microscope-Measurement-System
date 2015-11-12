function [] = OpenPiStagesEditDialog(c)
%function [] = OpenPiStagesEditDialog(c)
FunctionName = 'PI_OpenPiStagesEditDialog';
if(strmatch(FunctionName,c.dllfunctions))
	try
		[] = calllib(c.libalias,FunctionName,c.ID)
	catch
		rethrow(lasterror);
	end
else
	error(sprintf('%s not found',FunctionName));
end
