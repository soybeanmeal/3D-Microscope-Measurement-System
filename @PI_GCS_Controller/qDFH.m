function dValues = qDFH(c,szAxes)
% function dValues = qDFH(c,szAxes)
FunctionName = 'PI_qDFH';
if(strmatch(FunctionName,c.dllfunctions))
	if(nargin==1)
		szAxes = '';
	end
	len = length(szAxes);
	if(len == 0)
			len = c.NumberOfAxes;
	end
	if(len == 0)
		return;
	end
	dValues = zeros(len,1);
	pdValues = libpointer('doublePtr',dValues);
	try
		[ret,szAxes,dValues] = calllib(c.libalias,FunctionName,c.ID,szAxes,pdValues);
		if(ret==0)
			iError = GetError(c);
			szDesc = TranslateError(c,iError);
			error(szDesc);
		end
	catch
		rethrow(lasterror);
	end
else
	error(sprintf('%s not found',FunctionName));
end
