function [bRet,szAnswer] = GcsGetAnswer(c)
%function [bRet,szAnswer] = GcsGetAnswer(c)
FunctionName = 'PI_GcsGetAnswer';
if(strmatch(FunctionName,c.dllfunctions))
	try
		FunctionName1 = 'PI_GcsGetAnswerSize';
		iAnswersize = 0;		piAnswersize = libpointer('int32Ptr',iAnswersize);		[bRet,iAnswersize] = calllib(c.libalias,FunctionName1,c.ID,piAnswersize);
		szAnswer = blanks(iAnswersize+1);
		[bRet,szAnswer] = calllib(c.libalias,FunctionName,c.ID,szAnswer,iAnswersize);
	catch
		rethrow(lasterror);
	end
else
	error(sprintf('%s not found',FunctionName));
end
