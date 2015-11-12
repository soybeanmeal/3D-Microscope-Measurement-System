function [szAnswer] = TranslateError(c,iErrorCode)
%function [szAnswer] = TranslateError(c,iErrorCode)
FunctionName = 'PI_TranslateError';
if(strmatch(FunctionName,c.dllfunctions))
	szAnswer = blanks(1001);
	try
		[bRet,szAnswer] = calllib(c.libalias,FunctionName,iErrorCode,szAnswer,1000);
	catch
		rethrow(lasterror);
	end
else
	error(sprintf('%s not found',FunctionName));
end
