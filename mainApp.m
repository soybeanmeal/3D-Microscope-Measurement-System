% 2014/01/15
% main function for 3D_Microscope_System
addpath(genpath('C:\Users\Oliver\Documents\MATLAB\3D_Microscope_System'));

% Camera module
% format_USB = {'RGB8_752x480','RGB24_752x480'(default),'RGB555_752x480','RGB565_752x480','UYVY_752x480'}
% format_GigE = {'RGB8_1280x1024','RGB24_1280x1024'(default),'RGB555_1280x1024','RGB565_1280x1024','UYVY_1280x1024'}
% Ethernet Camera
format = 'RGB24_1280x1024';
win_info = imaqhwinfo('winvideo');
if ~isempty(win_info.DeviceIDs)
	DeviceNo = size(win_info.DeviceIDs,2);
	if ~any(strcmp(win_info.DeviceInfo(DeviceNo).SupportedFormats,format));
		DeviceNo = 0;
		disp('No such format.')
		disp('Open camera failed.');
	end
else
	DeviceNo = 0;
	disp('Open camera failed.');
end

vid = videoinput('winvideo',DeviceNo,format);
set(vid,'Tag','vid');


% Piezo Motor module
% PI_GCS_Controller controller class constructor
% DLLName = 'c:\program files\pi\gcstranslator\PI_GCS2_DLL.dll'
% hfile = 'PI_GCS2_DLL.h'
% libalias = 'PI';
% loadlibrary(DLLName,hfile,'alias',libalias);
% defined in PI_GCS_Controller()
if(~exist('Controller','var'))
	Controller = PI_GCS_Controller();
end

if(~isa(Controller,'PI_GCS_Controller'))
	Controller = PI_GCS_Controller();
end

% Stage Motor module
% DLLName = 'Wp2Comm.dll'
% hfile = 'Wp2Comm.h'
% [x1,...,xN] = calllib('Wp2Comm',funcname,arg1,...argN)
loadlibrary('Wp2Comm.dll','Wp2Comm.h');
% serial port number for Stage Motor
serialPort = 6;

hFig = micro_SystemGUI(DeviceNo,Controller,serialPort);