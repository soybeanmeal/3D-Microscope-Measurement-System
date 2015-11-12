function [dValues] = qWAV(c,iValues1,iValues2)
%function [dValues] = qWAV(c,iValues1,iValues2)
FunctionName = 'PI_qWAV';
if(strmatch(FunctionName,c.dllfunctions))
	piValues = libpointer('int32Ptr',iValues1);
	piValues1 = libpointer('int32Ptr',iValues2);
	nValues = length(iValues1);
	dValues = zeros(size(iValues1));
	pdValues = libpointer('doublePtr',dValues);
	try
		[bRet,iValues,iValues2,dValues] = calllib(c.libalias,FunctionName,c.ID,piValues,piValues1,pdValues,nValues);
		if(bRet==0)
			error('function failed');
		end
	catch
		rethrow(lasterror);
	end
else
	error(sprintf('%s not found',FunctionName));
end
