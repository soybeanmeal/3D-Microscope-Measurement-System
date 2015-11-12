function [dOutValues1] = qDRR(c,iTables,iStart,iNumber,nowaiting)
%function [out] = qDRR(c)
FunctionName = 'PI_qDRR';
if(strmatch(FunctionName,c.dllfunctions))
	piTables = libpointer('int32Ptr',iTables);
	nTables = length(iTables);
	hlen = 1000;
	header = blanks(hlen+1);
%BOOL PI_FUNC_DECL PI_qDRR(long ID, const int* piRecTableIdsArray,  int iNumberOfRecChannels,  int iOffsetOfFirstPointInRecordTable,  int iNumberOfValues, double** pdValueArray, char* szGcsArrayHeader, int iGcsArrayHeaderMaxSize);

	ppdData = libpointer('doublePtr');
    c.DataRecorder.ValuesSize = [0 0];
	dOutValues1 = 0;
	try
		[bRet,iTables,ppdData,header] = calllib(c.libalias,FunctionName,c.ID,piTables,nTables,iStart,iNumber,ppdData,header,hlen);
	catch
		rethrow(lasterror);
    end
    wait = 1;
    if(nargin==5)
        if(nowaiting)
            wait = 0;
        end
    end
    start = strfind(header,'SAMPLE_TIME');
    h_1 = header(start:end);
    start = strfind(h_1,'=');
    ende = strfind(h_1,10);

    h_2 = h_1(start+1:ende(1));
    sampletime = str2double(h_2);
    i = 0;
    if(wait)
        while(i<(nTables*iNumber-1))
            pause(0.1);
            i =  GetAsyncBufferIndex(c);
        end
        setdatatype(ppdData,'doublePtr',nTables,iNumber);
        dOutValues1 = ppdData.Value';
        dOutValues1 = [([0:iNumber-1]*sampletime)',dOutValues1];
    else
        c.DataRecorder.ppdValues = ppdData;
        c.DataRecorder.ValuesSize = [nTables iNumber];% als member speichern!!
        c.DataRecorder.SampleTime = sampletime;
    end
%     keyboard;
   
else
	error('%s not found',FunctionName);
end
