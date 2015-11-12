function [bRet,dOutValues1] = qGWD(c,iTables,iStart,iNumber)
%function [out] = qGWD(c)
FunctionName = 'PI_qGWD';
if(strmatch(FunctionName,c.dllfunctions))
	piTables = libpointer('int32Ptr',iTables);
	nTables = length(iTables);
	hlen = 1000;
	header = blanks(hlen+1);
	piInValues2 = libpointer('int32Ptr',iInValues2);
	ppdData = libpointer('doublePtrPtr',0);
	nValues = length(iValues1);
	dOutValues1 = 0;
	try
		[bRet,iTables,dOutValues1,header] = calllib(c.libalias,FunctionName,c.ID,piTables,nTables,iStart,iNumber,ppdData,header,hlen);
	catch
		rethrow(lasterror);
	end
else
	error(sprintf('%s not found',FunctionName));
end
