function [iTriggerOptions] = qDRT(c,iChannels)
%function [iTriggerOptions] = qDRT(c,iChannels)
FunctionName = 'PI_qDRT';
if(strmatch(FunctionName,c.dllfunctions))
	piChannels = libpointer('int32Ptr',iChannels);
	iTriggerOptions = zeros(size(iChannels));
	piTriggerOptions = libpointer('int32Ptr',iTriggerOptions);
	nValues = length(iTriggerOptions);
	szBuffer = blanks(100);
	try
		[bRet,iChannels,iTriggerOptions,szBuffer] = calllib(c.libalias,FunctionName,c.ID,piChannels,piTriggerOptions,szBuffer,nValues,99);
	catch
		rethrow(lasterror);
	end
else
	error(sprintf('%s not found',FunctionName));
end
