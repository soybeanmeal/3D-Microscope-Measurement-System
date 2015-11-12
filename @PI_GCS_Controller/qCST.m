function [szAnswer] = qCST(c,szAxes)
%function [szAnswer] = qCST(c,szAxes)
FunctionName = 'PI_qCST';
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
