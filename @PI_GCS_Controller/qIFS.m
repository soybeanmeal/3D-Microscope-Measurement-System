function [szAnswer] = qIFS(c,szAxes)
%function [szAnswer] = qIFS(c,szAxes)
FunctionName = 'PI_qIFS';
if(strmatch(FunctionName,c.dllfunctions))
	szAnswer = blanks(1001);
	try
		[bRet,szAxes,szAnswer] = calllib(c.libalias,FunctionName,c.ID,szAxes,szAnswer,1000);
		if(bRet==0)
			error('function failed');
		end
	catch
		rethrow(lasterror);
	end
else
	error(sprintf('%s not found',FunctionName));
end
