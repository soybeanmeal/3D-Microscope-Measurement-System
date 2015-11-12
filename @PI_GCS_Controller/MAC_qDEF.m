function [bRet] = MAC_qDEF(c,szMacroName,nTimes)
%function [bRet] = MAC_qDEF(c,szMacroName,nTimes)
FunctionName = 'PI_MAC_qDEF';
if(strmatch(FunctionName,c.dllfunctions))
	try
		[bRet,szMacroName] = calllib(c.libalias,FunctionName,c.ID,szMacroName,nTimes);
	catch
		rethrow(lasterror);
	end
else
	error(sprintf('%s not found',FunctionName));
end
