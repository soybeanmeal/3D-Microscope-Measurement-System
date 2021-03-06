function c = InterfaceSetupDlg(c)
% function InterfaceSetupDlg()
FunctionName = [c.libalias,'_InterfaceSetupDlg']; 
% foundit = cellfun(@(x) (strcmp(x,FunctionName)),c.dllfunctions,'UniformOutput',true);
if(strmatch(FunctionName,c.dllfunctions))
    c.ID = calllib(c.libalias,FunctionName,'');
    if(c.ID<0)
        error('Not connected');
    end
   
else
    error(sprintf('%s not found',FunctionName));
end