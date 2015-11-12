function iVal = qERR(c)
% function iVal = qERR(c)
FunctionName = 'PI_qERR';
if(strmatch(FunctionName,c.dllfunctions))
	iVal = 1;
	piValue = libpointer('int32Ptr',iVal);
	try
		[bRet,iVal] = calllib(c.libalias,FunctionName,c.ID,piValue);
		if(bRet==0)
			error('function failed');
		end
	catch
		rethrow(lasterror);
	end
else
	error(sprintf('%s not found',FunctionName));
end
