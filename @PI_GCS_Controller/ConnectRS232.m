function c = ConnectRS232(c,iValues1,iValues2)
% function c = ConnectRS232(c,iValues1,iValues2)
FunctionName = 'PI_ConnectRS232';
if(strmatch(FunctionName,c.dllfunctions))
	try
		[c.ID] = calllib(c.libalias,FunctionName,iValues1,iValues2);
	catch
		rethrow(lasterror);
	end
else
	error(sprintf('%s not found',FunctionName));
end
