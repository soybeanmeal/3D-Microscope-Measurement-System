function szAnswer = qHDR(c)
% function szAnswer = qHDR(c)
FunctionName = 'PI_qHDR';
if(strmatch(FunctionName,c.dllfunctions))
	szAnswer = blanks(5001);
	try
		[bRet,szAnswer] = calllib(c.libalias,FunctionName,c.ID,szAnswer,5000);
		if(bRet==0)
			error('function failed');
		end
	catch
		rethrow(lasterror);
	end
else
	error(sprintf('%s not found',FunctionName));
end
