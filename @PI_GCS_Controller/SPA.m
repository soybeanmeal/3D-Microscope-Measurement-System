function [bRet] = SPA(c,szAxes,uiInParamIDs,dInValues,szInString)
%function [bRet] = SPA(c,szAxes,uiInParamIDs,dInValues,szInString)
FunctionName = 'PI_SPA';
if(strmatch(FunctionName,c.dllfunctions))
	puiInParIDs = libpointer('uint32Ptr',uiInParamIDs);
	pdInValues = libpointer('doublePtr',dInValues);
	try
		[bRet,szAxes,uiInParamIDs,dInValues,szInString] = calllib(c.libalias,FunctionName,c.ID,szAxes,puiInParIDs,pdInValues,szInString);
	catch
		rethrow(lasterror);
	end
else
	error(sprintf('%s not found',FunctionName));
end
