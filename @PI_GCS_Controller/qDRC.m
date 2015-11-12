function [szSourceIds,iRecordOptions] = qDRC(c,iRecordTables)
%function [szSourceIds,iRecordOptions] = qDRC(c,iRecordTables)
FunctionName = 'PI_qDRC';
if(strmatch(FunctionName,c.dllfunctions))
	piRecordTables = libpointer('int32Ptr',iRecordTables);
	iRecordOptions = zeros(size(iRecordTables));
	piRecordOptions = libpointer('int32Ptr',iRecordOptions);
	nValues = length(iRecordTables);
	szSourceIds = blanks(1001);
	try
		[bRet,iRecordTables,szSourceIds,iRecordOptions] = calllib(c.libalias,FunctionName,c.ID,piRecordTables,szSourceIds,piRecordOptions,1000,nValues);
		if(bRet==0)
			error('function failed');
		end
	catch
		rethrow(lasterror);
	end
else
	error(sprintf('%s not found',FunctionName));
end
