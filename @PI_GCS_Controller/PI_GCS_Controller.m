function c = PI_GCS_Controller()
%PI_GCS_Controller controller class constructor
if nargin==0

    c.ControllerName = [];
    c.DLLName = [];
    c.ID = -1;
    c.IDN = 'not queried yet';
    c.NumberOfAxes = 0;
    if(exist('c:\programme\pi\gcstranslator\','dir')==7)
        c.DLLName=('c:\programme\pi\gcstranslator\PI_GCS2_DLL.dll');
    elseif(exist('c:\program files\pi\gcstranslator\','dir')==7)
        c.DLLName=('c:\program files\pi\gcstranslator\PI_GCS2_DLL.dll');
    end
    c.hfile = 'PI_GCS2_DLL.h';
    c.libalias = 'PI';
    c.DataRecorder.ppdValues = libpointer('doublePtr');
    c.DataRecorder.ValuesSize = [0 0];
    c.DataRecorder.SampleTime = 0;
    % only load dll if it wasn't loaded before
    if(~libisloaded(c.libalias))
        [notfound,warnings] = loadlibrary (c.DLLName,c.hfile,'alias',c.libalias);
    end
    if(~libisloaded(c.libalias))
        error('DLL could not be loaded');
    else
        c.dllfunctions = libfunctions(c.libalias);
    end
    c = class(c,'PI_GCS_Controller');
end