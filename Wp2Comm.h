///////////////////////////////////////////////////////////////////////////// 
// Program: Wp2Comm dll 
// File: taurus.h : 
// Wang Bo (wangbo1214@outlook.com)
/////////////////////////////////////////////////////////////////////////////

#include <windows.h>

#ifdef __cplusplus
extern "C" {
#endif

// #ifdef WIN32
// 	#undef FUNC_DECL
// 	#ifdef Wp2Comm_DLL_EXPORTS
// 		#ifndef UNKNOWN_DLL
// 			#define FUNC_DLL __declspec(dllexport) WINAPI
// 		#else
// 			#define FUNC_DECL WINAPI
// 		#endif
// 	#else
// 		#define FUNC_DECL __declspec(dllimport) WINAPI
// 	#endif
// #else
// 	#define FUNC_DECL
// #endif
#ifdef WIN32
	#define FUNC_DECL __declspec(dllexport) WINAPI
#else
	#define FUNC_DECL
#endif


typedef unsigned long DWORD;
typedef unsigned int UINT;
typedef unsigned char BYTE;
typedef char *LPSTR;
typedef unsigned long *LPDWORD;

// DLL functions
DWORD 	FUNC_DECL 	InitController(DWORD ControllerMode, DWORD Axes, DWORD ComPort, DWORD Baudrate, DWORD UserWin, UINT AsyncMsg, DWORD Mode);
DWORD 	FUNC_DECL 	OpenController(void);
DWORD 	FUNC_DECL 	CloseController(void);
DWORD 	FUNC_DECL 	ResetComm(void);
DWORD 	FUNC_DECL 	SetDecimalSeparator(BYTE DecimalSep);
DWORD 	FUNC_DECL 	PreprocessReply(BYTE Active);
DWORD 	FUNC_DECL 	SetSleepWhileWaitingWithoutTimeout(DWORD milliseconds);
DWORD 	FUNC_DECL 	ExecuteCommand(LPSTR Command, DWORD LinesExpected, LPSTR Reply);
DWORD 	FUNC_DECL 	GetReply(LPSTR Reply);
DWORD 	FUNC_DECL 	AbortCommand(void);
DWORD 	FUNC_DECL 	Calibrate(void);
DWORD 	FUNC_DECL 	CalibrateA(DWORD Axis);
DWORD 	FUNC_DECL 	ClearParameterStack(void);
DWORD 	FUNC_DECL 	ClearParameterStackA(DWORD Axis);
DWORD 	FUNC_DECL 	GetAcceleration(LPSTR Accel);
DWORD 	FUNC_DECL 	GetAccelerationA(LPSTR Accel, DWORD Axis);
DWORD 	FUNC_DECL 	GetAxisMode(LPDWORD Axis1Mode, LPDWORD Axis2Mode, LPDWORD Axis3Mode, LPDWORD Axis4Mode);
DWORD 	FUNC_DECL 	GetAxisModeA(LPDWORD Mode, DWORD Axis);
DWORD 	FUNC_DECL 	GetError(LPDWORD Error);
DWORD 	FUNC_DECL 	GetErrorA(LPDWORD Error, DWORD Axis);
DWORD 	FUNC_DECL 	GetJoystickVelocity(LPSTR JoyVel);
DWORD 	FUNC_DECL 	GetJoystickVelocityA(LPSTR JoyVel, DWORD Axis);
DWORD 	FUNC_DECL 	GetLimits(LPSTR A1Min, LPSTR A1Max, LPSTR A2Min, LPSTR A2Max, LPSTR A3Min, LPSTR A3Max, LPSTR A4Min, LPSTR A4Max);
DWORD 	FUNC_DECL 	GetLimitsA(LPSTR Min, LPSTR Max, DWORD Axis);
DWORD 	FUNC_DECL 	GetParamsOnStack(LPDWORD Value);
DWORD 	FUNC_DECL 	GetParamsOnStackA(LPDWORD Value, DWORD Axis);
DWORD 	FUNC_DECL 	GetPos(LPSTR Axis1Pos, LPSTR Axis2Pos, LPSTR Axis3Pos, LPSTR Axis4Pos);
DWORD 	FUNC_DECL 	GetPosA(LPSTR Pos, DWORD Axis);
DWORD 	FUNC_DECL 	GetStatus(LPDWORD Status);
DWORD 	FUNC_DECL 	GetStatusA(LPDWORD Status, DWORD Axis);
DWORD 	FUNC_DECL 	GetVelocity(LPSTR Vel);
DWORD 	FUNC_DECL 	GetVelocityA(LPSTR Vel, DWORD Axis);
DWORD 	FUNC_DECL 	Identify(LPSTR ld);
DWORD 	FUNC_DECL 	IdentifyA(LPSTR ld, DWORD Axis);
DWORD 	FUNC_DECL 	JoystickDisable(void);
DWORD 	FUNC_DECL 	JoystickDisableA(DWORD Axis);
DWORD 	FUNC_DECL 	JoystickEnable(void);
DWORD 	FUNC_DECL 	JoystickEnableA(DWORD Axis);
DWORD 	FUNC_DECL 	MoveAbsolute(LPSTR Axis1Pos, LPSTR Axis2Pos, LPSTR Axis3Pos, LPSTR Axis4Pos);
DWORD 	FUNC_DECL 	MoveAbsoluteA(LPSTR Pos, DWORD Axis);
DWORD 	FUNC_DECL 	MoveAbsoluteAutoReply(LPSTR Axis1Pos, LPSTR Axis2Pos, LPSTR Axis3Pos, LPSTR Axis4Pos);
DWORD 	FUNC_DECL 	MoveAbsoluteAutoReplyA(LPSTR Pos, DWORD Axis);
DWORD 	FUNC_DECL 	MoveRelative(LPSTR Axis1Pos, LPSTR Axis2Pos, LPSTR Axis3Pos, LPSTR Axis4Pos);
DWORD 	FUNC_DECL 	MoveRelativeA(LPSTR Pos, DWORD Axis);
DWORD 	FUNC_DECL 	MoveRelativeAutoReply(LPSTR Axis1Pos, LPSTR Axis2Pos, LPSTR Axis3Pos, LPSTR Axis4Pos);
DWORD 	FUNC_DECL 	MoveRelativeAutoReplyA(LPSTR Pos, DWORD Axis);
DWORD 	FUNC_DECL 	RangeMeasure(void);
DWORD 	FUNC_DECL 	RangeMeasureA(DWORD Axis);
DWORD 	FUNC_DECL 	SetAcceleration(LPSTR Accel);
DWORD 	FUNC_DECL 	SetAccelerationA(LPSTR Accel, DWORD Axis);
DWORD 	FUNC_DECL 	SetAxisMode(LPSTR Axis1Mode, LPSTR Axis2Mode, LPSTR Axis3Mode, LPSTR Axis4Mode);
DWORD 	FUNC_DECL 	SetAxisModeA(LPSTR Mode, DWORD Axis);
DWORD 	FUNC_DECL 	SetJoystickVelocity(LPSTR JoyVel);
DWORD 	FUNC_DECL 	SetJoystickVelocityA(LPSTR JoyVel, DWORD Axis);
DWORD 	FUNC_DECL 	SetOrigin(void);
DWORD 	FUNC_DECL 	SetOriginA(DWORD Axis);
DWORD 	FUNC_DECL 	SetVelocity(LPSTR Vel);
DWORD 	FUNC_DECL 	SetVelocityA(LPSTR Vel, DWORD Axis);

#ifdef __cplusplus
}
#endif
