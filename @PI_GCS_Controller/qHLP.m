function szAnswer = qHLP(c)
% function szAnswer = qHLP(c)
FunctionName = 'PI_qHLP';
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
