function c = ConnectNIgpib(c,iValues1,iValues2)
% function c = ConnectNIgpib(c,iValues1,iValues2)
FunctionName = 'PI_ConnectNIgpib';
if(strmatch(FunctionName,c.dllfunctions))
	try
		[c.ID] = calllib(c.libalias,FunctionName,iValues1,iValues2);
	catch
		rethrow(lasterror);
	end
else
	error(sprintf('%s not found',FunctionName));
end
