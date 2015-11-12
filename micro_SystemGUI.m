classdef micro_SystemGUI < handle
	% class name: micro_SystemGUI
	% GUI for the 3D microscope system
	% wang bo (wangbo1214@outlook.com)
	% created time: 2014/01/14
	% revised time: 2014/01/21
	%				delete algorithm_panel
	% revised time: 2014/02/03
	%				add pushbutton to set start & end pos.
	% revised time: 2014/02/04
	% 				add function calllib('Wp2Comm','SetDecimalSeparator',255);
	% 				for different operating system, data decimal separator may be different
	% revised time: 2014/02/05
	% 				change the trigger type of camera
	% 				from 'manual' to 'immediate'

	properties

		figure

		axes % camera

		hImage % video input object
		hImage_width
		hImage_height
		hImage_nBands

		system_panel % 'System Control'
		system_open % 'Open System'
		system_init % 'Init System'
		system_close % 'Close System'

		camera_panel % 'Camera'
		camera_frame_text % 'Frames per trigger'
		camera_frame_edit % edit
		camera_expomode_text % 'Exposure Mode'
		camera_expomode % pop-up {'auto','manual'}
		camera_expo_text % 'Exposure'
		camera_expo_edit % edit
		camera_expo_slider
		camera_expo_slimin % '-16'
		camera_expo_slimax % '-1'
		camera_bright_text % 'Brightness'
		camera_bright_edit % edit
		camera_bright_slider
		camera_bright_slimin % '0'
		camera_bright_slimax % '255'
		camera_ROI_panel % 'ROI'
		camera_select_ROI % 'Select ROI'
		camera_reset_ROI % 'Reset ROI'
		camera_ROI_zoom % 'Zoom In & Out'
		camera_ROI_x_text % 'X-Offset'
		camera_ROI_x_edit % edit
		camera_ROI_y_text % 'Y-Offset'
		camera_ROI_y_edit % edit
		camera_ROI_wid_text % 'Width'
		camera_ROI_wid_edit % edit
		camera_ROI_hei_text % 'Height'
		camera_ROI_hei_edit % edit
		
		piezo_panel % 'Piezo Motor (x/y direction)'
		piezo_grateperiod_text % 'Grating period/um'
		piezo_grateperiod_edit % edit
		piezo_grateratio_text % 'Steps per period'
		piezo_grateratio_edit % edit
		piezo_stepsize_text % 'Step size/um'
		piezo_stepsize_edit % edit
		piezo_origin_text % 'Original pos./mm'
		piezo_origin_edit % edit
		piezo_range_text % 'Range/mm'
		piezo_range_edit % edit

		stage_panel % 'Stage Motor (z direction)'
		stage_start % 'Start position/mm' pushbutton
		stage_start_edit % edit
		stage_end % 'End position/mm' pushbutton
		stage_end_edit % edit
		stage_stepsize_text % 'Step size/nm'
		stage_stepsize_edit % edit
		stage_steps_text % 'Steps No.'
		stage_steps_edit % edit
		stage_target_text % 'Target step pos./mm'
		stage_target_edit % edit
		stage_range_text % 'Range/mm'
		stage_range_edit % edit

		reserved

		experiment_panel % 'Experiment'

		operation_panel % 'Operation mode'
		operation_auto % checkbox 'automatic'
		operation_semi % checkbox 'semi-automatic'
		operation_manual % checkbox 'manual'
		operation_flag % flag to distinguish three different operation modes

		feedback_panel
		x_actual_text % 'x/y actual position'
		x_actual_edit % edit
		x_actual_unit % 'mm'
		z_actual_text % 'z actual position'
		z_actual_edit % edit
		z_actual_unit % 'um'
		z_current_text % 'z current step No.'
		z_current_edit % edit

		exper_start % start experiment
		exper_stop % stop experiment
		exper_plot % plot x/z target position and actual position
		upward % upward pushbutton
		downward % downward pushbutton
		leftward % leftward pushbutton
		rightward % rightward pushbutton
		steer_text % 'steer'

		message % listbox
		message_str = {'System Information:'}

		% define the mat file to save the target and actual position
		% of piezo motor & stage motor
		% {'x target/mm','x actual/mm','x error/um','z target/mm','z actual/mm','z error/nm'}
		pos_mat

		% define the save directory
		folder_name

		% define the number of loop in semi-automatic mode
		% until the stop pushbutton pressed
		loop

		% Camera module
		DeviceNo % Camera object

		% Piezo Motor module
		Controller % Piezo Motor object
		stagename = 'M-663.465';
		availableaxes % list of current axis identifiers
		axisname

		% Stage Motor module
		serialPort % Stage Motor object
	end

	methods

		function this = micro_SystemGUI(DeviceNo,Controller,serialPort)
			% width, height of the micro_SystemGUI
			width_fig = 1060;
			height_fig = 800;
			
			this.DeviceNo = DeviceNo;
			this.Controller = Controller;
			this.serialPort = serialPort;

			font = 'Times New Roman';
			this.figure = figure(1);
			set(this.figure,'Units','pixels','Position',[1 1 width_fig height_fig],...
				'Resize','off','Name','3D microscope system v1.0',...
				'NumberTitle','off','Menubar','none','Toolbar','none',...
				'Visible','off','Color',[0.94,0.94,0.94]);
			movegui(this.figure,'center');

			this.axes = axes('Units','pixels','Position',[12 295 640 480]);
			this.hImage = image(zeros(480,640,3));
			axis off

			% System Control
			this.system_panel = uipanel('Title','System Control','TitlePosition','lefttop',...
				'FontSize',12,'FontAngle','italic','FontName',font,...
				'Units','pixels','Position',[670 75 380 710]);
				this.system_open = uicontrol('Style','pushbutton','Parent',this.system_panel,...
					'String','Open System','FontSize',10,'FontName',font,...
					'Units','pixels','Position',[12 645 90 30],...
					'Callback',{@this.open_system});
				this.system_init = uicontrol('Style','pushbutton','Parent',this.system_panel,...
					'String','Init System','FontSize',10,'FontName',font,...
					'Units','pixels','Position',[144 645 90 30],...
					'Callback',{@this.init_system});
				this.system_close = uicontrol('Style','pushbutton','Parent',this.system_panel,...
					'String','Close System','FontSize',10,'FontName',font,...
					'Units','pixels','Position',[276 645 90 30],...
					'Callback',{@this.close_system});

			% Camera
			this.camera_panel = uipanel('Title','Camera','TitlePosition','lefttop',...
				'FontSize',12,'FontAngle','italic','FontName',font,...
				'Units','pixels','Position',[12 330 355 310],...
				'Parent',this.system_panel);
				this.camera_frame_text = uicontrol('Style','text','Parent',this.camera_panel,...
					'String','Frames per trigger','FontSize',10,'FontName',font,...
					'Units','pixels','Position',[10 260 108 20],'HorizontalAlignment','left');
				this.camera_frame_edit = uicontrol('Style','edit','Parent',this.camera_panel,...
					'String','1','FontSize',10,'FontName',font,'BackgroundColor','white',...
					'Units','pixels','Position',[122 260 70 25],...
					'Callback',{@this.set_frame});
				this.camera_expomode_text = uicontrol('Style','text','Parent',this.camera_panel,...
					'String','Exposure Mode','FontSize',10,'FontName',font,...
					'Units','pixels','Position',[10 220 108 20],'HorizontalAlignment','left');
				this.camera_expomode = uicontrol('Style','popupmenu','Parent',this.camera_panel,...
					'String',{'auto','manual'},'FontSize',10,'FontName',font,'BackgroundColor','white',...
					'Units','pixels','Position',[122 220 70 25],...
					'Callback',{@this.set_expomode});
				this.camera_expo_text = uicontrol('Style','text','Parent',this.camera_panel,...
					'String','Exposure','FontSize',10,'FontName',font,...
					'Units','pixels','Position',[210 220 70 20],'HorizontalAlignment','left');
				this.camera_expo_edit = uicontrol('Style','edit','Parent',this.camera_panel,...
					'String','0','FontSize',10,'FontName',font,'BackgroundColor','white',...
					'Units','pixels','Position',[282 220 60 25],...
					'Callback',{@this.set_exposure});
				this.camera_expo_slimin = uicontrol('Style','text','Parent',this.camera_panel,...
					'String','-16','FontSize',10,'FontName',font,...
					'Units','pixels','Position',[96 190 20 16]);
				this.camera_expo_slider = uicontrol('Style','slider','Parent',this.camera_panel,...
					'Min',-16,'Max',-1,'Value',-16,'SliderStep',[0.1 0.2],'BackgroundColor','white',...
					'Units','pixels','Position',[120 190 200 20],...
					'Callback',{@this.set_expo_slider});
				this.camera_expo_slimax = uicontrol('Style','text','Parent',this.camera_panel,...
					'String','-1','FontSize',10,'FontName',font,...
					'Units','pixels','Position',[322 190 20 16]);
				this.camera_bright_text = uicontrol('Style','text','Parent',this.camera_panel,...
					'String','Brightness','FontSize',10,'FontName',font,...
					'Units','pixels','Position',[10 150 108 20],'HorizontalAlignment','left');
				this.camera_bright_edit = uicontrol('Style','edit','Parent',this.camera_panel,...
					'String','0','FontSize',10,'FontName',font,'BackgroundColor','white',...
					'Units','pixels','Position',[122 150 70 25],...
					'Callback',{@this.set_bright});
				this.camera_bright_slimin = uicontrol('Style','text','Parent',this.camera_panel,...
					'String','0','FontSize',10,'FontName',font,...
					'Units','pixels','Position',[96 120 20 16]);
				this.camera_bright_slider = uicontrol('Style','slider','Parent',this.camera_panel,...
					'Min',0,'Max',255,'Value',0,'SliderStep',[0.01 0.1],'BackgroundColor','white',...
					'Units','pixels','Position',[120 120 200 20],...
					'Callback',{@this.set_bright_slider});
				this.camera_bright_slimax = uicontrol('Style','text','Parent',this.camera_panel,...
					'String','255','FontSize',10,'FontName',font,...
					'Units','pixels','Position',[322 120 20 16]);
				this.camera_ROI_panel = uipanel('Title','ROI','TitlePosition','lefttop',...
					'FontSize',10,'FontAngle','italic','FontName',font,...
					'Units','pixels','Position',[10 10 332 100],...
					'Parent',this.camera_panel);
					this.camera_select_ROI = uicontrol('Style','pushbutton','Parent',this.camera_ROI_panel,...
						'String','','FontSize',10,'FontName',font,'CData',imread('select.bmp'),...
						'Units','pixels','Position',[10 50 32 32],'TooltipString','select ROI',...
						'BackgroundColor','white',...
						'Callback',{@this.set_select_ROI});
					this.camera_reset_ROI = uicontrol('Style','pushbutton','Parent',this.camera_ROI_panel,...
						'String','','FontSize',10,'FontName',font,'CData',imread('reset.bmp'),...
						'Units','pixels','Position',[55 50 32 32],'TooltipString','reset ROI',...
						'BackgroundColor','white',...
						'Callback',{@this.set_reset_ROI});
					this.camera_ROI_zoom = uicontrol('Style','pushbutton','Parent',this.camera_ROI_panel,...
						'String','','FontSize',10,'FontName',font,'CData',imread('zoom.bmp'),...
						'Units','pixels','Position',[30 10 32 32],'TooltipString','zoom',...
						'BackgroundColor','white',...
						'Callback','zoom on');
					this.camera_ROI_x_text = uicontrol('Style','text','Parent',this.camera_ROI_panel,...
						'String','X-Offset','FontSize',10,'FontName',font,...
						'Units','pixels','Position',[100 53 50 20],'HorizontalAlignment','left');
					this.camera_ROI_x_edit = uicontrol('Style','edit','Parent',this.camera_ROI_panel,...
						'String','0','FontSize',10,'FontName',font,'BackgroundColor','white',...
						'Units','pixels','Position',[155 53 50 25],'Enable','off');
					this.camera_ROI_y_text = uicontrol('Style','text','Parent',this.camera_ROI_panel,...
						'String','Y-Offset','FontSize',10,'FontName',font,...
						'Units','pixels','Position',[100 13 50 20],'HorizontalAlignment','left');
					this.camera_ROI_y_edit = uicontrol('Style','edit','Parent',this.camera_ROI_panel,...
						'String','0','FontSize',10,'FontName',font,'BackgroundColor','white',...
						'Units','pixels','Position',[155 13 50 25],'Enable','off');
					this.camera_ROI_wid_text = uicontrol('Style','text','Parent',this.camera_ROI_panel,...
						'String','Width','FontSize',10,'FontName',font,...
						'Units','pixels','Position',[215 53 50 20],'HorizontalAlignment','left');
					this.camera_ROI_wid_edit = uicontrol('Style','edit','Parent',this.camera_ROI_panel,...
						'String','0','FontSize',10,'FontName',font,'BackgroundColor','white',...
						'Units','pixels','Position',[270 53 50 25],'Enable','off');
					this.camera_ROI_hei_text = uicontrol('Style','text','Parent',this.camera_ROI_panel,...
						'String','Height','FontSize',10,'FontName',font,...
						'Units','pixels','Position',[215 13 50 20],'HorizontalAlignment','left');
					this.camera_ROI_hei_edit = uicontrol('Style','edit','Parent',this.camera_ROI_panel,...
						'String','0','FontSize',10,'FontName',font,'BackgroundColor','white',...
						'Units','pixels','Position',[270 13 50 25],'Enable','off');

			% Piezo Motor
			this.piezo_panel = uipanel('Title','Piezo Motor (x/y direction)','TitlePosition','lefttop',...
				'FontSize',12,'FontAngle','italic','FontName',font,...
				'Units','pixels','Position',[12 170 355 145],...
				'Parent',this.system_panel);
				this.piezo_grateperiod_text = uicontrol('Style','text','Parent',this.piezo_panel,...
					'String','Grating period/um','FontSize',10,'FontName',font,...
					'Units','pixels','Position',[10 90 100 20],'HorizontalAlignment','left');
				this.piezo_grateperiod_edit = uicontrol('Style','edit','Parent',this.piezo_panel,...
					'String','0','FontSize',10,'FontName',font,'BackgroundColor','white',...
					'Units','pixels','Position',[122 90 60 25],...
					'Callback',{@this.set_grateperiod});
				this.piezo_grateratio_text = uicontrol('Style','text','Parent',this.piezo_panel,...
					'String','Steps per period','FontSize',10,'FontName',font,...
					'Units','pixels','Position',[190 90 90 20],'HorizontalAlignment','left');
				this.piezo_grateratio_edit = uicontrol('Style','edit','Parent',this.piezo_panel,...
					'String','4','FontSize',10,'FontName',font,'BackgroundColor','white',...
					'Units','pixels','Position',[282 90 60 25],...
					'Callback',{@this.set_grateratio});
				this.piezo_stepsize_text = uicontrol('Style','text','Parent',this.piezo_panel,...
					'String','Step size/um','FontSize',10,'FontName',font,...
					'Units','pixels','Position',[10 50 100 20],'HorizontalAlignment','left');
				this.piezo_stepsize_edit = uicontrol('Style','edit','Parent',this.piezo_panel,...
					'String','0','FontSize',10,'FontName',font,'BackgroundColor','white',...
					'Units','pixels','Position',[122 50 60 25],...
					'Callback',{@this.set_x_stepsize});
				this.piezo_range_text = uicontrol('Style','text','Parent',this.piezo_panel,...
					'String','Range/mm','FontSize',10,'FontName',font,...
					'Units','pixels','Position',[200 50 80 20],'HorizontalAlignment','left');
				this.piezo_range_edit = uicontrol('Style','edit','Parent',this.piezo_panel,...
					'String','0.0 - 19.0','FontSize',10,'FontName',font,'BackgroundColor','white',...
					'Units','pixels','Position',[282 50 60 25],'Enable','off');
				this.piezo_origin_text = uicontrol('Style','text','Parent',this.piezo_panel,...
					'String','Original pos./mm','FontSize',10,'FontName',font,...
					'Units','pixels','Position',[10 10 100 20],'HorizontalAlignment','left');
				this.piezo_origin_edit = uicontrol('Style','edit','Parent',this.piezo_panel,...
					'String',{num2str(0,'%0.4f')},'FontSize',10,'FontName',font,'BackgroundColor','white',...
					'Units','pixels','Position',[122 10 60 25],...
					'Callback',{@this.set_x_origin});

			% Stage Motor
			this.stage_panel = uipanel('Title','Stage Motor (z direction)','TitlePosition','lefttop',...
				'FontSize',12,'FontAngle','italic','FontName',font,...
				'Units','pixels','Position',[12 20 355 145],...
				'Parent',this.system_panel);
				this.stage_start = uicontrol('Style','pushbutton','Parent',this.stage_panel,...
					'String','Start position/mm','FontSize',10,'FontName',font,...
					'Units','pixels','Position',[10 90 110 25],'HorizontalAlignment','center',...
					'Callback',{@this.set_z_start});
				this.stage_start_edit = uicontrol('Style','edit','Parent',this.stage_panel,...
					'String',{num2str(0,'%0.6f')},'FontSize',10,'FontName',font,'BackgroundColor','white',...
					'Units','pixels','Position',[122 90 60 25],...
					'Callback','');
				this.stage_end = uicontrol('Style','pushbutton','Parent',this.stage_panel,...
					'String','End position/mm','FontSize',10,'FontName',font,...
					'Units','pixels','Position',[10 50 110 25],'HorizontalAlignment','center',...
					'Callback',{@this.set_z_end});
				this.stage_end_edit = uicontrol('Style','edit','Parent',this.stage_panel,...
					'String',{num2str(0,'%0.6f')},'FontSize',10,'FontName',font,'BackgroundColor','white',...
					'Units','pixels','Position',[122 50 60 25],...
					'Callback','');
				this.stage_stepsize_text = uicontrol('Style','text','Parent',this.stage_panel,...
					'String','Step size/nm','FontSize',10,'FontName',font,...
					'Units','pixels','Position',[200 90 70 20],'HorizontalAlignment','left');
				this.stage_stepsize_edit = uicontrol('Style','edit','Parent',this.stage_panel,...
					'String','10','FontSize',10,'FontName',font,'BackgroundColor','white',...
					'Units','pixels','Position',[282 90 60 25],...
					'Callback',{@this.set_z_stepsize});
				this.stage_steps_text = uicontrol('Style','text','Parent',this.stage_panel,...
					'String','Steps No.','FontSize',10,'FontName',font,...
					'Units','pixels','Position',[200 50 70 20],'HorizontalAlignment','left');
				this.stage_steps_edit = uicontrol('Style','edit','Parent',this.stage_panel,...
					'String','0','FontSize',10,'FontName',font,'BackgroundColor','white',...
					'Units','pixels','Position',[280 50 60 25],'Enable','off');
				this.stage_target_text = uicontrol('Style','text','Parent',this.stage_panel,...
					'String','Target step pos./mm','FontSize',10,'FontName',font,...
					'Units','pixels','Position',[10 10 110 20],'HorizontalAlignment','left');
				this.stage_target_edit = uicontrol('Style','edit','Parent',this.stage_panel,...
					'String',{num2str(0,'%0.6f')},'FontSize',10,'FontName',font,'BackgroundColor','white',...
					'Units','pixels','Position',[122 10 60 25],...
					'Callback',{@this.set_z_target});
				this.stage_range_text = uicontrol('Style','text','Parent',this.stage_panel,...
					'String','Range/mm','FontSize',10,'FontName',font,...
					'Units','pixels','Position',[200 10 70 20],'HorizontalAlignment','left');
				this.stage_range_edit = uicontrol('Style','edit','Parent',this.stage_panel,...
					'String','0.0 - 26.0','FontSize',10,'FontName',font,'BackgroundColor','white',...
					'Units','pixels','Position',[280 10 60 25],'Enable','off');

			this.reserved = uicontrol('Style','pushbutton',...
					'String','','FontSize',10,'FontName',font,'CData',imread('hhn.bmp'),...
					'Units','pixels','Position',[670 10 380 60],...
					'Callback','');

			% Experiment
			this.experiment_panel = uipanel('Title','Experiment','TitlePosition','lefttop',...
				'FontSize',12,'FontAngle','italic','FontName',font,...
				'Units','pixels','Position',[12 135 640 150]);
			
				% Operation mode
				this.operation_panel = uibuttongroup('Title','Operation Mode','TitlePosition','lefttop',...
					'FontSize',10,'FontAngle','italic','FontName',font,...
					'Units','pixels','Position',[10 10 130 115],...
					'Parent',this.experiment_panel,...
					'SelectionChangeFcn',{@this.set_operation});
					this.operation_auto = uicontrol('Style','radiobutton','Parent',this.operation_panel,...
						'String','automatic','FontSize',10,'FontName',font,...
						'Units','pixels','Position',[10 70 110 20],...
						'Tag','automatic');
					this.operation_semi = uicontrol('Style','radiobutton','Parent',this.operation_panel,...
						'String','semi-automatic','FontSize',10,'FontName',font,...
						'Units','pixels','Position',[10 40 110 20],...
						'Tag','semi-automatic');
					this.operation_manual = uicontrol('Style','radiobutton','Parent',this.operation_panel,...
						'String','manual','FontSize',10,'FontName',font,...
						'Units','pixels','Position',[10 10 110 20],...
						'Tag','manual');
				
				% Feedback	
				this.feedback_panel= uipanel('Title','Feedback','TitlePosition','lefttop',...
					'FontSize',10,'FontAngle','italic','FontName',font,...
					'Units','pixels','Position',[145 10 210 115],...
					'Parent',this.experiment_panel);
					this.x_actual_text =  uicontrol('Style','text','Parent',this.feedback_panel,...
						'String','x/y actual position/mm','FontSize',10,'FontName',font,...
						'Units','pixels','Position',[10 70 120 20],'HorizontalAlignment','left');
					this.x_actual_edit = uicontrol('Style','edit','Parent',this.feedback_panel,...
						'String',{num2str(0,'%0.4f')},'FontSize',10,'FontName',font,'BackgroundColor','white',...
						'Units','pixels','Position',[135 70 60 25],'Enable','off');
					this.z_actual_text = uicontrol('Style','text','Parent',this.feedback_panel,...
						'String','z actual position/mm','FontSize',10,'FontName',font,...
						'Units','pixels','Position',[10 40 120 20],'HorizontalAlignment','left');
					this.z_actual_edit = uicontrol('Style','edit','Parent',this.feedback_panel,...
						'String',{num2str(0,'%0.6f')},'FontSize',10,'FontName',font,'BackgroundColor','white',...
						'Units','pixels','Position',[135 40 60 25],'Enable','off');
					this.z_current_text = uicontrol('Style','text','Parent',this.feedback_panel,...
						'String','z current step No.','FontSize',10,'FontName',font,...
						'Units','pixels','Position',[10 10 120 20],'HorizontalAlignment','left');
					this.z_current_edit = uicontrol('Style','edit','Parent',this.feedback_panel,...
						'String',{num2str(0)},'FontSize',10,'FontName',font,'BackgroundColor','white',...
						'Units','pixels','Position',[135 10 60 25],'Enable','off');

				% start,stop,up,down,left,right icons
				this.exper_start = uicontrol('Style','pushbutton','Parent',this.experiment_panel,...
					'String','','FontSize',10,'FontName',font,'CData',imread('start.bmp'),...
					'Units','pixels','Position',[365 54 32 32],'TooltipString','start',...
					'BackgroundColor','white',...
					'Callback',{@this.set_start});
				this.exper_plot = uicontrol('Style','pushbutton','Parent',this.experiment_panel,...
					'String','','FontSize',10,'FontName',font,'CData',imread('plot.bmp'),...
					'Units','pixels','Position',[415 54 32 32],'TooltipString','plot',...
					'BackgroundColor','white',...
					'Callback',{@this.set_plot});
				this.exper_stop = uicontrol('Style','pushbutton','Parent',this.experiment_panel,...
					'String','','FontSize',10,'FontName',font,'CData',imread('stop.bmp'),...
					'Units','pixels','Position',[465 54 32 32],'TooltipString','stop',...
					'BackgroundColor','white','Enable','off',...
					'Callback',{@this.set_stop});
				this.upward = uicontrol('Style','pushbutton','Parent',this.experiment_panel,...
					'String','','FontSize',10,'FontName',font,'CData',imread('up.bmp'),...
					'Units','pixels','Position',[550 90 32 32],'TooltipString','up',...
					'BackgroundColor','white','Enable','off',...
					'Callback',{@this.set_upward});
				this.downward = uicontrol('Style','pushbutton','Parent',this.experiment_panel,...
					'String','','FontSize',10,'FontName',font,'CData',imread('down.bmp'),...
					'Units','pixels','Position',[550 20 32 32],'TooltipString','down',...
					'BackgroundColor','white','Enable','off',...
					'Callback',{@this.set_downward});
				this.leftward = uicontrol('Style','pushbutton','Parent',this.experiment_panel,...
					'String','','FontSize',10,'FontName',font,'CData',imread('left.bmp'),...
					'Units','pixels','Position',[510 54 32 32],'TooltipString','left',...
					'BackgroundColor','white','Enable','off',...
					'Callback',{@this.set_leftward});
				this.rightward = uicontrol('Style','pushbutton','Parent',this.experiment_panel,...
					'String','','FontSize',10,'FontName',font,'CData',imread('right.bmp'),...
					'Units','pixels','Position',[590 54 32 32],'TooltipString','right',...
					'BackgroundColor','white','Enable','off',...
					'Callback',{@this.set_rightward});
				this.steer_text = uicontrol('Style','text','Parent',this.experiment_panel,...
					'String','steer','FontSize',10,'FontAngle','italic','FontName',font,...
					'Units','pixels','Position',[585 25 40 20]);

				this.message = uicontrol('Style','listbox',...
					'String',this.message_str,'FontSize',10,'FontName',font,...
					'Units','pixels','Position',[12 10 640 120]);

			set(this.figure,'Visible','on');
		end


		function this = open_system(this,src,event)
			% this: micro_SystemGUI
			% src: this.system_open
			
			% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
			% Camera module
			% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
			% get the camera model
			win_info = imaqhwinfo('winvideo');
			this.message_str{end+1} = ['Camera Model: ' win_info.DeviceInfo(this.DeviceNo).DeviceName];

			% get the resolution, adaptor name
			vid = imaqfind('Tag','vid');
			this.message_str{end+1} = ['Video Name: ',get(vid{end},'Name')];

			% retrive the video resolution
			vidRes = get(vid{end},'VideoResolution');
			this.hImage_width = vidRes(1);
			this.hImage_height = vidRes(2);
			this.hImage_nBands = get(vid{end},'NumberOfBands');
			this.hImage = image(zeros(this.hImage_height,this.hImage_width,this.hImage_nBands));
			axis off

			% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
			% Piezo Motor module
			% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
			if(~this.Controller.IsConnected())
				% connect using the serial port
				% int PI_ConnectRS232(int iPortNumber,int iBaudRate)
				% iportNumber: COM port to use (e.g.4 for "COM4")
				% iBaudRate to use (8 data,1 stop,no parity)
				% COM5,38400(factory setting)
				this.Controller = this.Controller.ConnectRS232(5,38400);
			end

			% query axes
			this.availableaxes = this.Controller.qSAI_ALL();
			% query controller identification
			this.message_str{end+1} = ['Piezo Motor model: ' this.Controller.qIDN()];

			% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
			% Stage Motor module
			% % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
			% ControllerMode: Taurus = 8
			% Axes: 1
			% ComPort: serialPort
			% Baudrate: 19200
			% UserWin: 0 default
			% AsyncMsg: 0
			% Mode: synchronous(1050884 or 2308)
			% 		asynchronous(1051140 or 2564)
			calllib('Wp2Comm','InitController',8,1,this.serialPort,19200,0,0,2308);
			% open the COM-port and connects to the controller
			% make sure to have called InitController() before executing OpenController()
			calllib('Wp2Comm','OpenController');
			% get the identify string of an axis
			identify = blanks(50);
			[ret,identify] = calllib('Wp2Comm','IdentifyA',identify,1);
			this.message_str{end+1} = ['Stage Motor model: ' identify];

			set(this.message,'String',this.message_str);
		end

		function this = init_system(this,src,event)
			% this: micro_SystemGUI
			% src: this.system_init
			
			% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
			% Camera module
			% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
			vid = imaqfind('Tag','vid');
			vid_src = getselectedsource(vid{end});
			
			set(vid{end},'ReturnedColorSpace','grayscale');
			set(vid{end},'FramesPerTrigger',1);

			% triggerconfig(vid{end},'manual'); % use trigger(vid{end}) to start acquisition
			triggerconfig(vid{end},'immediate'); % use start(vid{end}) to start acquisition
			
			set(vid_src,'ExposureMode','auto');

			set(vid_src,'ContrastMode','manual');
			set(vid_src,'Contrast',1);
			
			set(vid_src,'GainMode','manual');
			set(vid_src,'Gain',0);

			% display current frame per trigger
			set(this.camera_frame_edit,'String',num2str(1));

			% display current exposure mode and exposure value
			set(this.camera_expomode,'Value',1); % 'auto'
			set(this.camera_expo_edit,'Enable','off');
			set(this.camera_expo_slider,'Enable','off');

			% display current brightness value
			set(this.camera_bright_edit,'String',num2str(get(vid_src,'Brightness')));
			set(this.camera_bright_slider,'Value',get(vid_src,'Brightness'));

			% ROI
			set(this.camera_ROI_x_edit,'String','0');
			set(this.camera_ROI_y_edit,'String','0');
			set(this.camera_ROI_wid_edit,'String',num2str(this.hImage_width));
			set(this.camera_ROI_hei_edit,'String',num2str(this.hImage_height));

			preview(vid{end},this.hImage);

			% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
			% Piezo Motor module
			% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
			this.axisname = this.availableaxes(1);
			% connect a stage
			this.Controller.CST(this.axisname,this.stagename);
			this.message_str{end+1} = ['Stagename: ' this.Controller.qCST(this.axisname)];
			set(this.message,'String',this.message_str);
			% switch on servo and search reference
			% switch to reference stage
			this.Controller.SVO(this.axisname,1);
			
			% move the given axis to its physical reference point
			% set the current position to the reference position
			this.Controller.FRF(this.axisname);
			bReferencing = 1;
			while(bReferencing)
				pause(0.01); % 0.01s
				bReferencing = (this.Controller.qFRF(this.axisname) == 0);
			end

			% load parameters for piezo motor
			load('parameter.mat');
			grate_period = cell2mat(parameter(2,1));
			grate_ratio = cell2mat(parameter(2,2));
			x_origin = cell2mat(parameter(2,3));
			x_stepsize = grate_period/grate_ratio;

			% move current axis to original position
			this.Controller.MOV(this.axisname,x_origin);
			while(this.Controller.IsMoving(this.axisname))
				pause(0.01);
			end

			% display Grating period and Grating ratio
			set(this.piezo_grateperiod_edit,'String',{num2str(grate_period,'%0.1f')});
			set(this.piezo_grateratio_edit,'String',{num2str(grate_ratio)});

			% display step size
			set(this.piezo_stepsize_edit,'String',{num2str(x_stepsize,'%0.1f')});
			
			% display original position and actual position
			set(this.piezo_origin_edit,'String',{num2str(this.Controller.qMOV(this.axisname),'%0.4f')});
			set(this.x_actual_edit,'String',{num2str(this.Controller.qPOS(this.axisname),'%0.4f')});

			% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
			% Stage Motor module
			% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
			% calibrates the axis
			calllib('Wp2Comm','CalibrateA',1);
			pause(0.1);

			% by default Wp2Comm.dll preprocesses data returned by the controller and
			% replaces the '.' by the decimalseparator as set in Windows
			% 0xFF leave decimal separator unchanged '.'
			calllib('Wp2Comm','SetDecimalSeparator',255);

			z_target = blanks(10);
			[ret,z_target] = calllib('Wp2Comm','MoveAbsoluteA',z_target,1);
			pause(0.5);

			z_actual = blanks(10);
			[ret,z_actual] = calllib('Wp2Comm','GetPosA',z_actual,1);

			% mm
			set(this.stage_target_edit,'String',num2str(0,'%0.6f'));
			set(this.z_actual_edit,'String',z_actual);
		end

		function this = set_frame(this,src,event)
			% this: micro_SystemGUI
			% src: this.camera_frame_edit
			% frame per trigger: integer
			vid = imaqfind('Tag','vid');
			value = str2double(get(src,'String'));

			if isnumeric(value) & value > 0
				set(vid{end},'FramesPerTrigger',round(value));
			end
		end

		function this = set_expomode(this,src,event)
			% this: micro_SystemGUI
			% src: this.camera_expomode
			vid = imaqfind('Tag','vid');
			vid_src = getselectedsource(vid{end});
			stoppreview(vid{end});

			value = get(src,'Value');
			string_list = get(src,'String');
			switch string_list{value}
				case 'auto'
					set(vid_src,'ExposureMode','auto');
					set(this.camera_expo_edit,'Enable','off');
					set(this.camera_expo_slider,'Enable','off');
				case 'manual'
					set(vid_src,'ExposureMode','manual')
					set(this.camera_expo_edit,'Enable','on')
					set(this.camera_expo_slider,'Enable','on');
					set(vid_src,'Exposure',-7);	
			end
			set(this.camera_expo_edit,'String',num2str(get(vid_src,'Exposure')));
			set(this.camera_expo_slider,'Value',get(vid_src,'Exposure'));

			preview(vid{end});
		end

		function this = set_exposure(this,src,event)
			% this: micro_SystemGUI
			% src: this.camera_expo_edit
			vid = imaqfind('Tag','vid');
			vid_src = getselectedsource(vid{end});
			stoppreview(vid{end});

			value = str2double(get(src,'String'));

			if isnumeric(value) & ...
				value >= get(this.camera_expo_slider,'Min') & ...
				value <= get(this.camera_expo_slider,'Max')
				exposure = round(value);
				set(this.camera_expo_slider,'Value',exposure);
				set(vid_src,'Exposure',exposure);
			end

			preview(vid{end});
		end

		function this = set_expo_slider(this,src,event)
			% this: micro_SystemGUI
			% src: this.camera_expo_slider
			vid = imaqfind('Tag','vid');
			vid_src = getselectedsource(vid{end});
			stoppreview(vid{end});

			exposure = round(get(src,'Value'));
			set(this.camera_expo_edit,'String',num2str(exposure));
			set(vid_src,'Exposure',exposure);

			preview(vid{end});
		end

		function this = set_bright(this,src,event)
			% this: micro_SystemGUI
			% src: this.camera_bright_edit
			vid = imaqfind('Tag','vid');
			vid_src = getselectedsource(vid{end});
			stoppreview(vid{end});

			value = str2double(get(src,'String'));

			if isnumeric(value) & ...
				value >= get(this.camera_bright_slider,'Min') & ...
				value <= get(this.camera_bright_slider,'Max')
				bright = round(value);
				set(this.camera_bright_slider,'Value',bright);
				set(vid_src,'Brightness',bright);
			end

			preview(vid{end});
		end

		function this = set_bright_slider(this,src,event)
			% this: micro_SystemGUI
			% src: this.camera_bright_slider
			vid = imaqfind('Tag','vid');
			vid_src = getselectedsource(vid{end});
			stoppreview(vid{end});

			bright = round(get(src,'Value'));
			set(this.camera_bright_edit,'String',num2str(bright));
			set(vid_src,'Brightness',bright);

			preview(vid{end});
		end

		function this = set_select_ROI(this,src,event)
			% this: micro_SystemGUI
			% src: this.camera_select_ROI
			vid = imaqfind('Tag','vid');
			h1 = imrect(this.axes);
			point = wait(h1);
			stoppreview(vid{end});
			set(vid{end},'ROIPosition',[fix(point(1)) fix(point(2)) fix(point(3)) fix(point(4))]);
			set(this.camera_ROI_x_edit,'String',num2str(fix(point(1))));
			set(this.camera_ROI_y_edit,'String',num2str(fix(point(2))));
			set(this.camera_ROI_wid_edit,'String',num2str(fix(point(3))));
			set(this.camera_ROI_hei_edit,'String',num2str(fix(point(4))));
			
			% delete the rectangle
			delete(h1);

			preview(vid{end});
		end

		function this = set_reset_ROI(this,src,event)
			% this: micro_SystemGUI
			% src: this.camera_reset_ROI
			vid = imaqfind('Tag','vid');
			stoppreview(vid{end});
			set(vid{end},'ROIPosition',[0 0 this.hImage_width this.hImage_height]);
			set(this.camera_ROI_x_edit,'String','0');
			set(this.camera_ROI_y_edit,'String','0');
			set(this.camera_ROI_wid_edit,'String',num2str(this.hImage_width));
			set(this.camera_ROI_hei_edit,'String',num2str(this.hImage_height));
			
			preview(vid{end});
		end

		function this = set_grateperiod(this,src,event)
			% this: micro_SystemGUI
			% src: this.piezo_grateperiod_edit
			grate_period = str2double(get(src,'String'));
			set(this.piezo_grateperiod_edit,'String',num2str(grate_period,'%0.1f'));
			grate_ratio = str2double(get(this.piezo_grateratio_edit,'String'));
			x_stepsize = grate_period/grate_ratio;
			set(this.piezo_stepsize_edit,'String',num2str(x_stepsize,'%0.1f'));
		end

		function this = set_grateratio(this,src,event)
			% this: micro_SystemGUI
			% src: this.piezo_grateratio_edit
			grate_ratio = str2double(get(src,'String'));
			set(this.piezo_grateratio_edit,'String',num2str(grate_ratio));
			grate_period = str2double(get(this.piezo_grateperiod_edit,'String'));
			x_stepsize = grate_period/grate_ratio;
			set(this.piezo_stepsize_edit,'String',num2str(x_stepsize,'%0.1f'));
		end

		function this = set_x_stepsize(this,src,event)
			% this: micro_SystemGUI
			% src: this.piezo_stepsize_edit
			x_stepsize = str2double(get(src,'String'));
			set(this.piezo_stepsize_edit,'String',num2str(x_stepsize,'%0.1f'));
		end

		function this = set_x_origin(this,src,event)
			% this: micro_SystemGUI
			% src: this.piezo_origin_edit
			x_origin = str2double(get(src,'String'));
			set(this.piezo_origin_edit,'String',num2str(x_origin,'%0.4f'));
			
			% move current axis to original position
			this.Controller.MOV(this.axisname,x_origin);
			while(this.Controller.IsMoving(this.axisname))
				pause(0.01);
			end

			% display actual position
			set(this.x_actual_edit,'String',{num2str(this.Controller.qPOS(this.axisname),'%0.4f')});
		end

		function this = set_z_start(this,src,event)
			% this: micro_SystemGUI
			% src: this.stage_start
			z_start = str2double(get(this.stage_target_edit,'String'));
			set(this.stage_start_edit,'String',num2str(z_start,'%0.6f'));
			z_end = str2double(get(this.stage_end_edit,'String'));
			z_stepsize = str2double(get(this.stage_stepsize_edit,'String'));
			% to the nearest integer greater than or equal to
			z_step = ceil(abs(z_start - z_end)/z_stepsize * 10^6);
			set(this.stage_steps_edit,'String',num2str(z_step));
		end
		
		function this = set_z_end(this,src,event)
			% this: micro_SystemGUI
			% src: this.stage_end
			z_end = str2double(get(this.stage_target_edit,'String'));
			set(this.stage_end_edit,'String',num2str(z_end,'%0.6f'));
			z_start = str2double(get(this.stage_start_edit,'String'));
			z_stepsize = str2double(get(this.stage_stepsize_edit,'String'));
			% to the nearest integer greater than or equal to
			z_step = ceil(abs(z_start - z_end)/z_stepsize * 10^6);
			set(this.stage_steps_edit,'String',num2str(z_step));
		end

		function this = set_z_stepsize(this,src,event)
			% this: micro_SystemGUI
			% src: this.stage_stepsize_edit
			z_stepsize = str2double(get(src,'String'));
			set(this.stage_stepsize_edit,'String',num2str(z_stepsize));
			z_start = str2double(get(this.stage_start_edit,'String'));
			z_end = str2double(get(this.stage_end_edit,'String'));
			% to the nearest integer greater than or equal to
			z_step = ceil(abs(z_start - z_end)/z_stepsize * 10^6);
			set(this.stage_steps_edit,'String',num2str(z_step));
		end

		function this = set_z_target(this,src,event)
			% this: micro_SystemGUI
			% src: this.stage_target_edit
			z_target_value = str2double(get(src,'String'));
			set(this.stage_target_edit,'String',num2str(z_target_value,'%0.6f'));

			z_target = num2str(z_target_value,'%0.6f');
			[ret,z_target] = calllib('Wp2Comm','MoveAbsoluteAutoReplyA',z_target,1);
			pause(0.5);

			z_actual = blanks(10);
			[ret,z_actual] = calllib('Wp2Comm','GetPosA',z_actual,1);

			% display the actual position
			set(this.z_actual_edit,'String',z_actual);
		end

		function this = set_leftward(this,src,event)
			% this: micro_SystemGUI
			% src: this.leftward
			x_stepsize = str2double(get(this.piezo_stepsize_edit,'String')); % um
			this.Controller.MVR(this.axisname,-x_stepsize*0.001); % mm
			while(this.Controller.IsMoving(this.axisname))
				pause(0.01);
			end

			% display the actual positon
			set(this.x_actual_edit,'String',{num2str(this.Controller.qPOS(this.axisname),'%0.4f')});
		end

		function this = set_rightward(this,src,event)
			% this: micro_SystemGUI
			% src: this.rightward
			x_stepsize = str2double(get(this.piezo_stepsize_edit,'String')); % um
			this.Controller.MVR(this.axisname,x_stepsize*0.001); % mm
			while(this.Controller.IsMoving(this.axisname))
				pause(0.01);
			end

			% display the actual positon
			set(this.x_actual_edit,'String',{num2str(this.Controller.qPOS(this.axisname),'%0.4f')});
		end

		function this = set_upward(this,src,event)
			% this: micro_SystemGUI
			% src: this.upward
			if this.operation_flag == 2 % semi-automatic mode
				this.loop = this.loop + 1;

				vid = imaqfind('Tag','vid');

				cd(this.folder_name);
				mkdir(['z_position_',num2str(this.loop)]);
				cd(['z_position_',num2str(this.loop)]);

				% display current z step in z_current_edit
				set(this.z_current_edit,'String',{num2str(this.loop)}); 
				% move stage motor
				% The AutoReply-functions return only, when a desired target is reached
				% for a long distance, should use MoveRelativeAutoReplyA
				% for a short distance, can use MoveRelativeA instead

				% when using MoveRelative, the accumulated error will become more and more bigger
				% use MoveAbsolute instead
				% nm to mm
				z_stepsize = str2double(get(this.stage_stepsize_edit,'String')) * 10^-6;
				z_target_value = str2double(get(this.stage_target_edit,'String')) + z_stepsize;
				z_target = num2str(z_target_value,'%0.6f');
				[ret,z_target] = calllib('Wp2Comm','MoveAbsoluteAutoReplyA',z_target,1);
				pause(0.1);

				z_actual = blanks(10);
				[ret,z_actual] = calllib('Wp2Comm','GetPosA',z_actual,1);

				% display the target and actual position
				set(this.stage_target_edit,'String',z_target);
				set(this.z_actual_edit,'String',z_actual);
				
				% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
				% initial position of stage motor (first time to move stage motor)
				% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
				% target position of stage motor
				this.pos_mat{this.loop+1,4} = str2double(get(this.stage_target_edit,'String'));
				% actual position of stage motor
				this.pos_mat{this.loop+1,5} = str2double(get(this.z_actual_edit,'String'));
				% position error of stage motor
				this.pos_mat{this.loop+1,6} = abs(this.pos_mat{this.loop+1,4} - this.pos_mat{this.loop+1,5}) * 10^6; % nm

				grate_ratio = round(str2double(get(this.piezo_grateratio_edit,'String')));

				for j = 1:1:grate_ratio
					% start the image acquisition object
					start(vid{end});
					% get n- frames, n defined by Frames per trigger
					[disImage,time,metadata] = getdata(vid{end});
			
					% save disImage(:,:,:,FramesAcquired) to current folder			
					save(['disImage_',num2str(j),'.mat'],'disImage');

					for k = 1:1:metadata(end).FrameNumber
						% k: frames per trigger
						imwrite(disImage(:,:,:,k),['image_',num2str(j),'_',num2str(k),'.bmp']);
					end
					
					% target position of piezo motor
					this.pos_mat{(this.loop-1)*grate_ratio+j+1,1} = this.Controller.qMOV(this.axisname);
					% actual position of piezo motor
					this.pos_mat{(this.loop-1)*grate_ratio+j+1,2} = this.Controller.qPOS(this.axisname);
					% position error of piezo motor
					this.pos_mat{(this.loop-1)*grate_ratio+j+1,3} = abs(this.pos_mat{(this.loop-1)*grate_ratio+j+1,1} - this.pos_mat{(this.loop-1)*grate_ratio+j+1,2}) * 10^3; % um
					
					% move grate_ratio times
					% move to the original position
					% calculate the contrast
					if mod(j,grate_ratio) == 0
						x_origin = str2double(get(this.piezo_origin_edit,'String'));
						% move current axis to original position
						this.Controller.MOV(this.axisname,x_origin);
						while(this.Controller.IsMoving(this.axisname))
							pause(0.01);
						end

						if grate_ratio == 4
							I1 = double(imread('image_1_1.bmp'));
							I2 = double(imread('image_2_1.bmp'));
							I3 = double(imread('image_3_1.bmp'));
							I4 = double(imread('image_4_1.bmp'));
							contrast = 2.*sqrt((I1-I3).^2+(I2-I4).^2)./(I1+I2+I3+I4);
							save(['contrast_',num2str(this.loop),'.mat'],'contrast'); % save contrast.mat
						elseif grate_ratio == 3
							I1 = double(imread('image_1_1.bmp'));
							I2 = double(imread('image_2_1.bmp'));
							I3 = double(imread('image_3_1.bmp'));
							contrast = 3.*sqrt((I1-I2).^2+(I1-I3).^2+(I2-I3).^2)./(I1+I2+I3);
							save(['contrast_',num2str(this.loop),'.mat'],'contrast'); % save contrast.mat
						else
							disp('grate ratio 4 or 3 ?');
						end
					else
						x_stepsize = str2double(get(this.piezo_stepsize_edit,'String')); % um
						this.Controller.MVR(this.axisname,x_stepsize*0.001); % mm
						while(this.Controller.IsMoving(this.axisname))
							pause(0.01);
						end	
					end
					% display actual positon
					set(this.x_actual_edit,'String',{num2str(this.Controller.qPOS(this.axisname),'%0.4f')});
				end
			elseif this.operation_flag == 3 % manual mode
				% nm to mm
				z_stepsize = str2double(get(this.stage_stepsize_edit,'String')) * 10^-6;

				% The AutoReply-functions return only, when a desired target is reached
				% for a long distance, should use MoveRelativeAutoReplyA
				% for a short distance, can use MoveRelativeA instead

				% when using MoveRelative, the accumulated error will become more and more bigger
				% use MoveAbsolute instead
				z_target_value = str2double(get(this.stage_target_edit,'String')) + z_stepsize;
				z_target = num2str(z_target_value,'%0.6f');
				[ret,z_target] = calllib('Wp2Comm','MoveAbsoluteAutoReplyA',z_target,1);
				pause(0.1);

				z_actual = blanks(10);
				[ret,z_actual] = calllib('Wp2Comm','GetPosA',z_actual,1);

				% display the target and actual position
				set(this.stage_target_edit,'String',z_target);
				set(this.z_actual_edit,'String',z_actual);
			end
		end

		function this = set_downward(this,src,event)
			% this: micro_SystemGUI
			% src: this.downward
			if this.operation_flag == 2 % semi-automatic mode
				this.loop = this.loop + 1;

				vid = imaqfind('Tag','vid');

				cd(this.folder_name);
				mkdir(['z_position_',num2str(this.loop)]);
				cd(['z_position_',num2str(this.loop)]);

				% display current z step in z_current_edit
				set(this.z_current_edit,'String',{num2str(this.loop)}); 
				% move stage motor
				% The AutoReply-functions return only, when a desired target is reached
				% for a long distance, should use MoveRelativeAutoReplyA
				% for a short distance, can use MoveRelativeA instead

				% when using MoveRelative, the accumulated error will become more and more bigger
				% use MoveAbsolute instead
				% nm to mm
				z_stepsize = - str2double(get(this.stage_stepsize_edit,'String')) * 10^-6;
				z_target_value = str2double(get(this.stage_target_edit,'String')) + z_stepsize;
				z_target = num2str(z_target_value,'%0.6f');
				[ret,z_target] = calllib('Wp2Comm','MoveAbsoluteAutoReplyA',z_target,1);
				pause(0.1);

				z_actual = blanks(10);
				[ret,z_actual] = calllib('Wp2Comm','GetPosA',z_actual,1);

				% display the target and actual position
				set(this.stage_target_edit,'String',z_target);
				set(this.z_actual_edit,'String',z_actual);
				% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
				% initial position of stage motor
				% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
				% target position of stage motor
				this.pos_mat{this.loop+1,4} = str2double(get(this.stage_target_edit,'String'));
				% actual position of stage motor
				this.pos_mat{this.loop+1,5} = str2double(get(this.z_actual_edit,'String'));
				% position error of stage motor
				this.pos_mat{this.loop+1,6} = abs(this.pos_mat{this.loop+1,4} - this.pos_mat{this.loop+1,5}) * 10^6; % nm

				grate_ratio = round(str2double(get(this.piezo_grateratio_edit,'String')));

				for j = 1:1:grate_ratio
					% start the image acquisition object
					start(vid{end});
					% get n- frames, n defined by Frames per trigger
					[disImage,time,metadata] = getdata(vid{end});
			
					% save disImage(:,:,:,FramesAcquired) to current folder			
					save(['disImage_',num2str(j),'.mat'],'disImage');

					for k = 1:1:metadata(end).FrameNumber
						% k: frames per trigger
						imwrite(disImage(:,:,:,k),['image_',num2str(j),'_',num2str(k),'.bmp']);
					end
					
					% target position of piezo motor
					this.pos_mat{(this.loop-1)*grate_ratio+j+1,1} = this.Controller.qMOV(this.axisname);
					% actual position of piezo motor
					this.pos_mat{(this.loop-1)*grate_ratio+j+1,2} = this.Controller.qPOS(this.axisname);
					% position error of piezo motor
					this.pos_mat{(this.loop-1)*grate_ratio+j+1,3} = abs(this.pos_mat{(this.loop-1)*grate_ratio+j+1,1} - this.pos_mat{(this.loop-1)*grate_ratio+j+1,2}) * 10^3; % um
					
					% move grate_ratio times
					% move to the original position
					% calculate the contrast
					if mod(j,grate_ratio) == 0
						x_origin = str2double(get(this.piezo_origin_edit,'String'));
						% move current axis to original position
						this.Controller.MOV(this.axisname,x_origin);
						while(this.Controller.IsMoving(this.axisname))
							pause(0.01);
						end

						if grate_ratio == 4
							I1 = double(imread('image_1_1.bmp'));
							I2 = double(imread('image_2_1.bmp'));
							I3 = double(imread('image_3_1.bmp'));
							I4 = double(imread('image_4_1.bmp'));
							contrast = 2.*sqrt((I1-I3).^2+(I2-I4).^2)./(I1+I2+I3+I4);
							save(['contrast_',num2str(this.loop),'.mat'],'contrast'); % save contrast.mat
						elseif grate_ratio == 3
							I1 = double(imread('image_1_1.bmp'));
							I2 = double(imread('image_2_1.bmp'));
							I3 = double(imread('image_3_1.bmp'));
							contrast = 3.*sqrt((I1-I2).^2+(I1-I3).^2+(I2-I3).^2)./(I1+I2+I3);
							save(['contrast_',num2str(this.loop),'.mat'],'contrast'); % save contrast.mat
						else
							disp('grate ratio 4 or 3 ?');
						end
					else
						x_stepsize = str2double(get(this.piezo_stepsize_edit,'String')); % um
						this.Controller.MVR(this.axisname,x_stepsize*0.001); % mm
						while(this.Controller.IsMoving(this.axisname))
							pause(0.01);
						end	
					end
					% display the actual positon
					set(this.x_actual_edit,'String',{num2str(this.Controller.qPOS(this.axisname),'%0.4f')});
					pause(0.1);
				end
			elseif this.operation_flag == 3 % manual mode
				% nm to mm
				z_stepsize = - str2double(get(this.stage_stepsize_edit,'String')) * 10^-6;

				% The AutoReply-functions return only, when a desired target is reached
				% for a long distance, should use MoveRelativeAutoReplyA
				% for a short distance, can use MoveRelativeA instead

				% when using MoveRelative, the accumulated error will become more and more bigger
				% use MoveAbsolute instead
				z_target_value = str2double(get(this.stage_target_edit,'String')) + z_stepsize;
				z_target = num2str(z_target_value,'%0.6f');
				[ret,z_target] = calllib('Wp2Comm','MoveAbsoluteAutoReplyA',z_target,1);
				pause(0.1);

				z_actual = blanks(10);
				[ret,z_actual] = calllib('Wp2Comm','GetPosA',z_actual,1);

				% display the target and actual position
				set(this.stage_target_edit,'String',z_target);
				set(this.z_actual_edit,'String',z_actual);
			end	
		end

		function this = set_operation(this,src,event)
			% this: micro_SystemGUI
			% src: this.operation_panel
			% event: struct{'EventName','OldValue','NewValue'}
			switch get(event.NewValue,'Tag')
				case 'automatic'
					set(this.upward,'Enable','off');
					set(this.downward,'Enable','off');
					set(this.leftward,'Enable','off');
					set(this.rightward,'Enable','off');
					set(this.exper_start,'Enable','on');
					set(this.exper_stop,'Enable','off');
					set(this.exper_plot,'Enable','on');
					this.operation_flag = 1;
				case 'semi-automatic'
					set(this.stage_steps_edit,'String','0');
					set(this.z_current_edit,'String','0');
					set(this.upward,'Enable','on');
					set(this.downward,'Enable','on');
					set(this.leftward,'Enable','off');
					set(this.rightward,'Enable','off');
					set(this.exper_start,'Enable','on');
					set(this.exper_stop,'Enable','on');
					set(this.exper_plot,'Enable','on');
					this.operation_flag = 2;
				case 'manual'
					set(this.stage_steps_edit,'String','0');
					set(this.z_current_edit,'String','0');
					set(this.upward,'Enable','on');
					set(this.downward,'Enable','on');
					set(this.leftward,'Enable','on');
					set(this.rightward,'Enable','on');
					set(this.exper_start,'Enable','off');
					set(this.exper_stop,'Enable','off');
					set(this.exper_plot,'Enable','off');
					this.operation_flag = 3;
			end
		end

		function this = set_start(this,src,event)
			% this: micro_SystemGUI
			% src: this.exper_start
			% define the mat file to save the target and actual position
			this.pos_mat = {'x target/mm','x actual/mm','x error/um','z target/mm','z actual/mm','z error/nm'};
			
			this.message_str{end+1} = 'Acquisition started ...';
			set(this.message,'String',this.message_str);
			
			this.folder_name = uigetdir;
			if this.folder_name == 0
				return;
			end

			if this.operation_flag == 1 % automatic mode
				this.func_auto();
			elseif this.operation_flag == 2 % semi-automatic mode
				this.loop = 1;
				this.func_semi();
			end	
		end

		function this = func_auto(this)
			% function for automatic mode
			vid = imaqfind('Tag','vid');

			% define the move direction of stage motor
			z_start_value = str2double(get(this.stage_start_edit,'String'));
			z_end_value = str2double(get(this.stage_end_edit,'String'));
			if z_start_value > z_end_value
				% move downward
				z_stepsize = - str2double(get(this.stage_stepsize_edit,'String')) * 10^-6;
			else
				% move upward
				z_stepsize = str2double(get(this.stage_stepsize_edit,'String')) * 10^-6;
			end

			z_step = round(str2double(get(this.stage_steps_edit,'String')));
			grate_ratio = round(str2double(get(this.piezo_grateratio_edit,'String')));

			% move stage motor to start position
			z_target = num2str(z_start_value,'%0.6f');
			[ret,z_target] = calllib('Wp2Comm','MoveAbsoluteAutoReplyA',z_target,1);
			pause(0.1);

			z_actual = blanks(10);
			[ret,z_actual] = calllib('Wp2Comm','GetPosA',z_actual,1);

			% display the target and actual position
			set(this.stage_target_edit,'String',z_target);
			set(this.z_actual_edit,'String',z_actual);

			for i =1:1:z_step
				cd(this.folder_name);
				mkdir(['z_position_',num2str(i)]);
				cd(['z_position_',num2str(i)]);
				
				% display current z step in z_current_edit
				set(this.z_current_edit,'String',{num2str(i)});
				% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
				% initial position of stage motor
				% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
				% target position of stage motor
				this.pos_mat{i+1,4} = str2double(get(this.stage_target_edit,'String'));
				% actual position of stage motor
				this.pos_mat{i+1,5} = str2double(get(this.z_actual_edit,'String'));
				% position error of stage motor
				this.pos_mat{i+1,6} = abs(this.pos_mat{i+1,4} - this.pos_mat{i+1,5}) * 10^6; % nm

				for j = 1:1:grate_ratio
					% start the image acquisition object
					start(vid{end});
					% get n- frames, n defined by Frames per trigger
					[disImage,time,metadata] = getdata(vid{end});

					% save disImage(:,:,:,FramesAcquired) to current folder			
					save(['disImage_',num2str(j),'.mat'],'disImage');

					for k = 1:1:metadata(end).FrameNumber
						% k: frames per trigger
						imwrite(disImage(:,:,:,k),['image_',num2str(j),'_',num2str(k),'.bmp']);
					end
					
					% target position of piezo motor
					this.pos_mat{(i-1)*grate_ratio+j+1,1} = this.Controller.qMOV(this.axisname);
					% actual position of piezo motor
					this.pos_mat{(i-1)*grate_ratio+j+1,2} = this.Controller.qPOS(this.axisname);
					% position error of piezo motor
					this.pos_mat{(i-1)*grate_ratio+j+1,3} = abs(this.pos_mat{(i-1)*grate_ratio+j+1,1} - this.pos_mat{(i-1)*grate_ratio+j+1,2}) * 10^3; % um
					
					% move grate_ratio times
					% move to the original position
					% calculate the contrast
					if mod(j,grate_ratio) == 0
						x_origin = str2double(get(this.piezo_origin_edit,'String'));
						% move current axis to original position
						this.Controller.MOV(this.axisname,x_origin);
						while(this.Controller.IsMoving(this.axisname))
							pause(0.01);
						end

						if grate_ratio == 4
							I1 = double(imread('image_1_1.bmp'));
							I2 = double(imread('image_2_1.bmp'));
							I3 = double(imread('image_3_1.bmp'));
							I4 = double(imread('image_4_1.bmp'));
							contrast = 2.*sqrt((I1-I3).^2+(I2-I4).^2)./(I1+I2+I3+I4);
							save(['contrast_',num2str(i),'.mat'],'contrast'); % save contrast.mat
						elseif grate_ratio == 3
							I1 = double(imread('image_1_1.bmp'));
							I2 = double(imread('image_2_1.bmp'));
							I3 = double(imread('image_3_1.bmp'));
							contrast = 3.*sqrt((I1-I2).^2+(I1-I3).^2+(I2-I3).^2)./(I1+I2+I3);
							save(['contrast_',num2str(i),'.mat'],'contrast'); % save contrast.mat
						else
							disp('grate ratio 4 or 3 ?');
						end
					else
						x_stepsize = str2double(get(this.piezo_stepsize_edit,'String')); % um
						this.Controller.MVR(this.axisname,x_stepsize*0.001); % mm
						while(this.Controller.IsMoving(this.axisname))
							pause(0.01);
						end	
					end
					% display actual positon
					set(this.x_actual_edit,'String',{num2str(this.Controller.qPOS(this.axisname),'%0.4f')});
				end

				% move stage motor
				z_target_value = str2double(get(this.stage_target_edit,'String')) + z_stepsize;
				z_target = num2str(z_target_value,'%0.6f');
				[ret,z_target] = calllib('Wp2Comm','MoveAbsoluteAutoReplyA',z_target,1);
				pause(0.1);

				z_actual = blanks(10);
				[ret,z_actual] = calllib('Wp2Comm','GetPosA',z_actual,1);

				% display the target and actual position
				set(this.stage_target_edit,'String',z_target);
				set(this.z_actual_edit,'String',z_actual);
			end
			
			addpath(genpath(this.folder_name));
			cd(this.folder_name);

			pos_mat = this.pos_mat;
			save('pos_mat.mat','pos_mat');
			
			this.folder_name = 0;
			this.message_str{end+1} = 'Acquisition finished ...';
			set(this.message,'String',this.message_str);
		end

		function this = func_semi(this)
			% function for semi-automatic
			if this.folder_name == 0
				return;
			end
			
			vid = imaqfind('Tag','vid');
			
			cd(this.folder_name);
			mkdir(['z_position_',num2str(this.loop)]);
			cd(['z_position_',num2str(this.loop)]);
			
			% display current z step in z_current_edit
			set(this.z_current_edit,'String',{num2str(this.loop)});
			% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
			% initial position of stage motor
			% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
			% target position of stage motor
			this.pos_mat{this.loop+1,4} = str2double(get(this.stage_target_edit,'String'));
			% actual position of stage motor
			this.pos_mat{this.loop+1,5} = str2double(get(this.z_actual_edit,'String'));
			% position error of stage motor
			this.pos_mat{this.loop+1,6} = abs(this.pos_mat{this.loop+1,4} - this.pos_mat{this.loop+1,5}) * 10^6; % nm

			grate_ratio = round(str2double(get(this.piezo_grateratio_edit,'String')));

			for j = 1:1:grate_ratio
				% start the image acquisition object
				start(vid{end});
				% get n- frames, n defined by Frames per trigger
				[disImage,time,metadata] = getdata(vid{end});

				% save disImage(:,:,:,FramesAcquired) to current folder			
				save(['disImage_',num2str(j),'.mat'],'disImage');

				for k = 1:1:metadata(end).FrameNumber
					% k: frames per trigger
					imwrite(disImage(:,:,:,k),['image_',num2str(j),'_',num2str(k),'.bmp']);
				end
					
				% target position of piezo motor
				this.pos_mat{(this.loop-1)*grate_ratio+j+1,1} = this.Controller.qMOV(this.axisname);
				% actual position of piezo motor
				this.pos_mat{(this.loop-1)*grate_ratio+j+1,2} = this.Controller.qPOS(this.axisname);
				% position error of piezo motor
				this.pos_mat{(this.loop-1)*grate_ratio+j+1,3} = abs(this.pos_mat{(this.loop-1)*grate_ratio+j+1,1} - this.pos_mat{(this.loop-1)*grate_ratio+j+1,2}) * 10^3; % um
					
				% move grate_ratio times
				% move to the original position
				% calculate the contrast
				if mod(j,grate_ratio) == 0
					x_origin = str2double(get(this.piezo_origin_edit,'String'));
					% move current axis to target position
					this.Controller.MOV(this.axisname,x_origin);
					while(this.Controller.IsMoving(this.axisname))
						pause(0.01);
					end

					if grate_ratio == 4
						I1 = double(imread('image_1_1.bmp'));
						I2 = double(imread('image_2_1.bmp'));
						I3 = double(imread('image_3_1.bmp'));
						I4 = double(imread('image_4_1.bmp'));
						contrast = 2.*sqrt((I1-I3).^2+(I2-I4).^2)./(I1+I2+I3+I4);
						save(['contrast_',num2str(this.loop),'.mat'],'contrast'); % save contrast.mat
					elseif grate_ratio == 3
						I1 = double(imread('image_1_1.bmp'));
						I2 = double(imread('image_2_1.bmp'));
						I3 = double(imread('image_3_1.bmp'));
						contrast = 3.*sqrt((I1-I2).^2+(I1-I3).^2+(I2-I3).^2)./(I1+I2+I3);
						save(['contrast_',num2str(this.loop),'.mat'],'contrast'); % save contrast.mat
					else
						disp('grate ratio 4 or 3 ?');
					end
				else
					x_stepsize = str2double(get(this.piezo_stepsize_edit,'String')); % um
					this.Controller.MVR(this.axisname,x_stepsize*0.001); % mm
					while(this.Controller.IsMoving(this.axisname))
						pause(0.01);
					end	
				end
				% display the actual positon
				set(this.x_actual_edit,'String',{num2str(this.Controller.qPOS(this.axisname),'%0.4f')});
			end
		end

		function this = set_plot(this,src,event)
			% this: micro_SystemGUI
			% src: this.exper_plot
			h2 = figure(2);
			set(h2,'Name','position error of piezo motor','NumberTitle','off');
			plot(cell2mat(this.pos_mat(2:end,3)),'b:+');
			title('position error of piezo motor (unit: um)');
			
			h3 = figure(3);
			set(h3,'Name','position error of stage motor','NumberTitle','off');
			plot(cell2mat(this.pos_mat(2:end,6)),'r:x');
			title('position error of stage motor (unit: nm)');
		end

		function this = set_stop(this,src,event)
			% this: micro_SystemGUI
			% src: this.exper_stop
			cd(this.folder_name);
			addpath(genpath(this.folder_name));

			pos_mat = this.pos_mat;
			save('pos_mat.mat','pos_mat');

			this.folder_name = 0;
			this.loop = 0;
			this.message_str{end+1} = 'Acquisition finished ...';
			set(this.message,'String',this.message_str);
		end

		function this = close_system(this,src,event)
			% this: micro_SystemGUI
			% src: this.system_close
			selection = questdlg(['Close ' get(this.figure,'Name') ' ?'],...
				'Close',...
				'Yes','No','Yes');
			if strcmp(selection,'No')
				return;
			end
			% close camera
			vid = imaqfind('Tag','vid');
			closepreview(vid{end});
			delete(vid{end});

			% close piezo motor
			this.Controller.CloseConnection();
			clear this.Controller;

			% close stage motor
			calllib('Wp2Comm','CloseController');
			
			close(this.figure);
		end
	end
end