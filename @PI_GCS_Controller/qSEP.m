function [dOutValues1,szAnswer] = qSEP(c,szAxes,uiInParamIDs)
%function [dOutValues1,szAnswer] = qSEP(c,szAxes,uiInParamIDs)
FunctionName = 'PI_qSEP';
if(strmatch(FunctionName,c.dllfunctions))
	puiInPars = libpointer('uint32Ptr',uiInParamIDs);
	dOutValues1 = zeros(size(uiInParamIDs));
	pdOutValues1 = libpointer('doublePtr',dOutValues1);
	szAnswer = blanks(1001);
	try
		[bRet,szAxes,uiInParamIDs,dOutValues1,szAnswer] = calllib(c.libalias,FunctionName,c.ID,szAxes,puiInPars,pdOutValues1,szAnswer,1000);
		if(bRet==0)
			error('function failed');
		end
	catch
		rethrow(lasterror);
	end
else
	error(sprintf('%s not found',FunctionName));
end
