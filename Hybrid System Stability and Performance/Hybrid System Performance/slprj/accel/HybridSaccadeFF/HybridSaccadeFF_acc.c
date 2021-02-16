#include <math.h>
#include "HybridSaccadeFF_acc.h"
#include "HybridSaccadeFF_acc_private.h"
#include <stdio.h>
#include "slexec_vm_simstruct_bridge.h"
#include "slexec_vm_zc_functions.h"
#include "slexec_vm_lookup_functions.h"
#include "slsv_diagnostic_codegen_c_api.h"
#include "simtarget/slSimTgtMdlrefSfcnBridge.h"
#include "simstruc.h"
#include "fixedpoint.h"
#define CodeFormat S-Function
#define AccDefine1 Accelerator_S-Function
#include "simtarget/slAccSfcnBridge.h"
#ifndef __RTW_UTFREE__  
extern void * utMalloc ( size_t ) ; extern void utFree ( void * ) ;
#endif
boolean_T HybridSaccadeFF_acc_rt_TDelayUpdateTailOrGrowBuf ( int_T * bufSzPtr
, int_T * tailPtr , int_T * headPtr , int_T * lastPtr , real_T tMinusDelay ,
real_T * * tBufPtr , real_T * * uBufPtr , real_T * * xBufPtr , boolean_T
isfixedbuf , boolean_T istransportdelay , int_T * maxNewBufSzPtr ) { int_T
testIdx ; int_T tail = * tailPtr ; int_T bufSz = * bufSzPtr ; real_T * tBuf =
* tBufPtr ; real_T * xBuf = ( NULL ) ; int_T numBuffer = 2 ; if (
istransportdelay ) { numBuffer = 3 ; xBuf = * xBufPtr ; } testIdx = ( tail <
( bufSz - 1 ) ) ? ( tail + 1 ) : 0 ; if ( ( tMinusDelay <= tBuf [ testIdx ] )
&& ! isfixedbuf ) { int_T j ; real_T * tempT ; real_T * tempU ; real_T *
tempX = ( NULL ) ; real_T * uBuf = * uBufPtr ; int_T newBufSz = bufSz + 1024
; if ( newBufSz > * maxNewBufSzPtr ) { * maxNewBufSzPtr = newBufSz ; } tempU
= ( real_T * ) utMalloc ( numBuffer * newBufSz * sizeof ( real_T ) ) ; if (
tempU == ( NULL ) ) { return ( false ) ; } tempT = tempU + newBufSz ; if (
istransportdelay ) tempX = tempT + newBufSz ; for ( j = tail ; j < bufSz ; j
++ ) { tempT [ j - tail ] = tBuf [ j ] ; tempU [ j - tail ] = uBuf [ j ] ; if
( istransportdelay ) tempX [ j - tail ] = xBuf [ j ] ; } for ( j = 0 ; j <
tail ; j ++ ) { tempT [ j + bufSz - tail ] = tBuf [ j ] ; tempU [ j + bufSz -
tail ] = uBuf [ j ] ; if ( istransportdelay ) tempX [ j + bufSz - tail ] =
xBuf [ j ] ; } if ( * lastPtr > tail ) { * lastPtr -= tail ; } else { *
lastPtr += ( bufSz - tail ) ; } * tailPtr = 0 ; * headPtr = bufSz ; utFree (
uBuf ) ; * bufSzPtr = newBufSz ; * tBufPtr = tempT ; * uBufPtr = tempU ; if (
istransportdelay ) * xBufPtr = tempX ; } else { * tailPtr = testIdx ; }
return ( true ) ; } real_T HybridSaccadeFF_acc_rt_TDelayInterpolate ( real_T
tMinusDelay , real_T tStart , real_T * tBuf , real_T * uBuf , int_T bufSz ,
int_T * lastIdx , int_T oldestIdx , int_T newIdx , real_T initOutput ,
boolean_T discrete , boolean_T minorStepAndTAtLastMajorOutput ) { int_T i ;
real_T yout , t1 , t2 , u1 , u2 ; if ( ( newIdx == 0 ) && ( oldestIdx == 0 )
&& ( tMinusDelay > tStart ) ) return initOutput ; if ( tMinusDelay <= tStart
) return initOutput ; if ( ( tMinusDelay <= tBuf [ oldestIdx ] ) ) { if (
discrete ) { return ( uBuf [ oldestIdx ] ) ; } else { int_T tempIdx =
oldestIdx + 1 ; if ( oldestIdx == bufSz - 1 ) tempIdx = 0 ; t1 = tBuf [
oldestIdx ] ; t2 = tBuf [ tempIdx ] ; u1 = uBuf [ oldestIdx ] ; u2 = uBuf [
tempIdx ] ; if ( t2 == t1 ) { if ( tMinusDelay >= t2 ) { yout = u2 ; } else {
yout = u1 ; } } else { real_T f1 = ( t2 - tMinusDelay ) / ( t2 - t1 ) ;
real_T f2 = 1.0 - f1 ; yout = f1 * u1 + f2 * u2 ; } return yout ; } } if (
minorStepAndTAtLastMajorOutput ) { if ( newIdx != 0 ) { if ( * lastIdx ==
newIdx ) { ( * lastIdx ) -- ; } newIdx -- ; } else { if ( * lastIdx == newIdx
) { * lastIdx = bufSz - 1 ; } newIdx = bufSz - 1 ; } } i = * lastIdx ; if (
tBuf [ i ] < tMinusDelay ) { while ( tBuf [ i ] < tMinusDelay ) { if ( i ==
newIdx ) break ; i = ( i < ( bufSz - 1 ) ) ? ( i + 1 ) : 0 ; } } else { while
( tBuf [ i ] >= tMinusDelay ) { i = ( i > 0 ) ? i - 1 : ( bufSz - 1 ) ; } i =
( i < ( bufSz - 1 ) ) ? ( i + 1 ) : 0 ; } * lastIdx = i ; if ( discrete ) {
double tempEps = ( DBL_EPSILON ) * 128.0 ; double localEps = tempEps *
muDoubleScalarAbs ( tBuf [ i ] ) ; if ( tempEps > localEps ) { localEps =
tempEps ; } localEps = localEps / 2.0 ; if ( tMinusDelay >= ( tBuf [ i ] -
localEps ) ) { yout = uBuf [ i ] ; } else { if ( i == 0 ) { yout = uBuf [
bufSz - 1 ] ; } else { yout = uBuf [ i - 1 ] ; } } } else { if ( i == 0 ) {
t1 = tBuf [ bufSz - 1 ] ; u1 = uBuf [ bufSz - 1 ] ; } else { t1 = tBuf [ i -
1 ] ; u1 = uBuf [ i - 1 ] ; } t2 = tBuf [ i ] ; u2 = uBuf [ i ] ; if ( t2 ==
t1 ) { if ( tMinusDelay >= t2 ) { yout = u2 ; } else { yout = u1 ; } } else {
real_T f1 = ( t2 - tMinusDelay ) / ( t2 - t1 ) ; real_T f2 = 1.0 - f1 ; yout
= f1 * u1 + f2 * u2 ; } } return ( yout ) ; } void rt_ssGetBlockPath (
SimStruct * S , int_T sysIdx , int_T blkIdx , char_T * * path ) {
_ssGetBlockPath ( S , sysIdx , blkIdx , path ) ; } void rt_ssSet_slErrMsg (
SimStruct * S , void * diag ) { if ( ! _ssIsErrorStatusAslErrMsg ( S ) ) {
_ssSet_slErrMsg ( S , diag ) ; } else { _ssDiscardDiagnostic ( S , diag ) ; }
} void rt_ssReportDiagnosticAsWarning ( SimStruct * S , void * diag ) {
_ssReportDiagnosticAsWarning ( S , diag ) ; } static void mdlOutputs (
SimStruct * S , int_T tid ) { real_T B_3_8_0 ; real_T B_3_27_0 ; boolean_T
stateChanged ; boolean_T didZcEventOccur ; boolean_T rtb_B_3_1_0 ; real_T
rtb_B_3_17_0 ; int32_T isHit ; B_HybridSaccadeFF_T * _rtB ;
P_HybridSaccadeFF_T * _rtP ; X_HybridSaccadeFF_T * _rtX ;
PrevZCX_HybridSaccadeFF_T * _rtZCE ; DW_HybridSaccadeFF_T * _rtDW ; _rtDW = (
( DW_HybridSaccadeFF_T * ) ssGetRootDWork ( S ) ) ; _rtZCE = ( (
PrevZCX_HybridSaccadeFF_T * ) _ssGetPrevZCSigState ( S ) ) ; _rtX = ( (
X_HybridSaccadeFF_T * ) ssGetContStates ( S ) ) ; _rtP = ( (
P_HybridSaccadeFF_T * ) ssGetModelRtp ( S ) ) ; _rtB = ( (
B_HybridSaccadeFF_T * ) _ssGetModelBlockIO ( S ) ) ; rtb_B_3_1_0 = (
muDoubleScalarAbs ( _rtX -> Integrator1_CSTATE ) > _rtB -> B_3_2_0 ) ; isHit
= ssIsSampleHit ( S , 1 , 0 ) ; if ( isHit != 0 ) { if ( _rtDW ->
Memory2_PreviousInput ) { _rtB -> B_3_4_0 = _rtDW -> Memory3_PreviousInput ;
} else { _rtB -> B_3_4_0 = _rtB -> B_3_3_0 ; } } _rtB -> B_3_5_0 = (
rtb_B_3_1_0 || ( _rtB -> B_3_4_0 != 0.0 ) ) ; if ( ssIsMajorTimeStep ( S ) !=
0 ) { stateChanged = false ; didZcEventOccur = ( ( ( _rtZCE ->
Integrator1_Reset_ZCE == 1 ) != ( int32_T ) _rtB -> B_3_5_0 ) && ( _rtZCE ->
Integrator1_Reset_ZCE != 3 ) ) ; _rtZCE -> Integrator1_Reset_ZCE = _rtB ->
B_3_5_0 ; if ( _rtB -> B_3_5_0 ) { didZcEventOccur = true ; _rtX ->
Integrator1_CSTATE = _rtP -> P_6 ; stateChanged = true ; } if (
didZcEventOccur ) { ssSetBlockStateForSolverChangedAtMajorStep ( S ) ; if (
stateChanged ) { ssSetContTimeOutputInconsistentWithStateAtMajorStep ( S ) ;
} } } _rtB -> B_3_6_0 = _rtX -> Integrator1_CSTATE ; isHit = ssIsSampleHit (
S , 1 , 0 ) ; if ( isHit != 0 ) { ssCallAccelRunBlock ( S , 3 , 7 ,
SS_CALL_MDL_OUTPUTS ) ; } { real_T * * uBuffer = ( real_T * * ) & _rtDW ->
SaccadeExecutiontime_PWORK . TUbufferPtrs [ 0 ] ; real_T * * tBuffer = (
real_T * * ) & _rtDW -> SaccadeExecutiontime_PWORK . TUbufferPtrs [ 1 ] ;
real_T simTime = ssGetT ( S ) ; real_T tMinusDelay = simTime - _rtP -> P_7 ;
B_3_8_0 = HybridSaccadeFF_acc_rt_TDelayInterpolate ( tMinusDelay , 0.0 , *
tBuffer , * uBuffer , _rtDW -> SaccadeExecutiontime_IWORK . CircularBufSize ,
& _rtDW -> SaccadeExecutiontime_IWORK . Last , _rtDW ->
SaccadeExecutiontime_IWORK . Tail , _rtDW -> SaccadeExecutiontime_IWORK .
Head , _rtP -> P_8 , 0 , ( boolean_T ) ( ssIsMinorTimeStep ( S ) && (
ssGetTimeOfLastOutput ( S ) == ssGetT ( S ) ) ) ) ; } ssCallAccelRunBlock ( S
, 3 , 9 , SS_CALL_MDL_OUTPUTS ) ; isHit = ssIsSampleHit ( S , 1 , 0 ) ; if (
isHit != 0 ) { _rtB -> B_3_10_0 = _rtDW -> Memory1_PreviousInput ; } if (
rtb_B_3_1_0 ) { _rtB -> B_3_11_0 = _rtB -> B_3_9_0 ; } else { _rtB ->
B_3_11_0 = _rtB -> B_3_10_0 ; } _rtB -> B_3_14_0 = ( muDoubleScalarAbs ( _rtB
-> B_3_11_0 - B_3_8_0 ) > _rtB -> B_3_4_0_m ) ; rtb_B_3_1_0 = ! _rtB ->
B_3_14_0 ; isHit = ssIsSampleHit ( S , 1 , 0 ) ; if ( isHit != 0 ) { _rtB ->
B_3_16_0 = _rtDW -> Memory_PreviousInput ; } if ( rtb_B_3_1_0 ) {
rtb_B_3_17_0 = B_3_8_0 ; } else { rtb_B_3_17_0 = _rtB -> B_3_16_0 ; }
rtb_B_3_1_0 = ( rtb_B_3_1_0 && _rtB -> B_3_5_0 ) ; isHit = ssIsSampleHit ( S
, 1 , 0 ) ; if ( isHit != 0 ) { _rtB -> B_3_19_0 = _rtDW ->
LastOutput_PreviousInput ; } if ( rtb_B_3_1_0 ) { _rtB -> B_3_21_0 =
rtb_B_3_17_0 ; } else if ( _rtB -> B_3_5_0 ) { _rtB -> B_3_21_0 =
rtb_B_3_17_0 ; } else { _rtB -> B_3_21_0 = _rtB -> B_3_19_0 ; } _rtB ->
B_3_22_0 = ! _rtB -> B_3_5_0 ; isHit = ssIsSampleHit ( S , 1 , 0 ) ; if ( (
isHit != 0 ) && ( ssIsMajorTimeStep ( S ) != 0 ) ) { if ( _rtB -> B_3_22_0 )
{ if ( ! _rtDW -> EnabledSubsystem_MODE ) { if ( ssGetTaskTime ( S , 1 ) !=
ssGetTStart ( S ) ) { ssSetBlockStateForSolverChangedAtMajorStep ( S ) ; }
_rtX -> Internal_CSTATE = _rtP -> P_3 ; _rtDW -> EnabledSubsystem_MODE = true
; } } else { if ( _rtDW -> EnabledSubsystem_MODE ) {
ssSetBlockStateForSolverChangedAtMajorStep ( S ) ; _rtDW ->
EnabledSubsystem_MODE = false ; } } } if ( _rtDW -> EnabledSubsystem_MODE ) {
_rtB -> B_0_0_0 = 0.0 ; _rtB -> B_0_0_0 += _rtP -> P_2 * _rtX ->
Internal_CSTATE ; if ( ssIsMajorTimeStep ( S ) != 0 ) { srUpdateBC ( _rtDW ->
EnabledSubsystem_SubsysRanBC ) ; } } if ( _rtB -> B_3_5_0 ) { rtb_B_3_17_0 =
_rtB -> B_3_0_0 ; } else { rtb_B_3_17_0 = _rtB -> B_0_0_0 ; } _rtB ->
B_3_25_0 = _rtB -> B_3_21_0 + rtb_B_3_17_0 ; isHit = ssIsSampleHit ( S , 1 ,
0 ) ; if ( isHit != 0 ) { ssCallAccelRunBlock ( S , 3 , 26 ,
SS_CALL_MDL_OUTPUTS ) ; } { real_T * * uBuffer = ( real_T * * ) & _rtDW ->
NeurologicalDelay_PWORK . TUbufferPtrs [ 0 ] ; real_T * * tBuffer = ( real_T
* * ) & _rtDW -> NeurologicalDelay_PWORK . TUbufferPtrs [ 1 ] ; real_T
simTime = ssGetT ( S ) ; real_T tMinusDelay = simTime - _rtP -> P_12 ;
B_3_27_0 = HybridSaccadeFF_acc_rt_TDelayInterpolate ( tMinusDelay , 0.0 , *
tBuffer , * uBuffer , _rtDW -> NeurologicalDelay_IWORK . CircularBufSize , &
_rtDW -> NeurologicalDelay_IWORK . Last , _rtDW -> NeurologicalDelay_IWORK .
Tail , _rtDW -> NeurologicalDelay_IWORK . Head , _rtP -> P_13 , 0 , (
boolean_T ) ( ssIsMinorTimeStep ( S ) && ( ssGetTimeOfLastOutput ( S ) ==
ssGetT ( S ) ) ) ) ; } _rtB -> B_3_28_0 = _rtB -> B_3_9_0 - B_3_27_0 ; if (
_rtB -> B_3_5_0 ) { rtb_B_3_17_0 = _rtB -> B_3_1_0 ; } else { rtb_B_3_17_0 =
_rtP -> P_5 * _rtB -> B_3_28_0 + _rtP -> P_4 * _rtB -> B_3_6_0 ; } if (
rtb_B_3_17_0 > _rtP -> P_14 ) { _rtB -> B_3_31_0 = _rtP -> P_14 ; } else if (
rtb_B_3_17_0 < _rtP -> P_15 ) { _rtB -> B_3_31_0 = _rtP -> P_15 ; } else {
_rtB -> B_3_31_0 = rtb_B_3_17_0 ; } UNUSED_PARAMETER ( tid ) ; } static void
mdlOutputsTID2 ( SimStruct * S , int_T tid ) { B_HybridSaccadeFF_T * _rtB ;
P_HybridSaccadeFF_T * _rtP ; _rtP = ( ( P_HybridSaccadeFF_T * ) ssGetModelRtp
( S ) ) ; _rtB = ( ( B_HybridSaccadeFF_T * ) _ssGetModelBlockIO ( S ) ) ;
_rtB -> B_3_0_0 = _rtP -> P_16 ; _rtB -> B_3_1_0 = _rtP -> P_17 ; _rtB ->
B_3_2_0 = _rtP -> P_18 ; _rtB -> B_3_3_0 = _rtP -> P_19 ; _rtB -> B_3_4_0_m =
_rtP -> P_20 ; UNUSED_PARAMETER ( tid ) ; }
#define MDL_UPDATE
static void mdlUpdate ( SimStruct * S , int_T tid ) { int32_T isHit ;
B_HybridSaccadeFF_T * _rtB ; P_HybridSaccadeFF_T * _rtP ;
DW_HybridSaccadeFF_T * _rtDW ; _rtDW = ( ( DW_HybridSaccadeFF_T * )
ssGetRootDWork ( S ) ) ; _rtP = ( ( P_HybridSaccadeFF_T * ) ssGetModelRtp ( S
) ) ; _rtB = ( ( B_HybridSaccadeFF_T * ) _ssGetModelBlockIO ( S ) ) ; isHit =
ssIsSampleHit ( S , 1 , 0 ) ; if ( isHit != 0 ) { _rtDW ->
Memory3_PreviousInput = _rtB -> B_3_14_0 ; _rtDW -> Memory2_PreviousInput =
_rtB -> B_3_5_0 ; } { real_T * * uBuffer = ( real_T * * ) & _rtDW ->
SaccadeExecutiontime_PWORK . TUbufferPtrs [ 0 ] ; real_T * * tBuffer = (
real_T * * ) & _rtDW -> SaccadeExecutiontime_PWORK . TUbufferPtrs [ 1 ] ;
real_T simTime = ssGetT ( S ) ; _rtDW -> SaccadeExecutiontime_IWORK . Head =
( ( _rtDW -> SaccadeExecutiontime_IWORK . Head < ( _rtDW ->
SaccadeExecutiontime_IWORK . CircularBufSize - 1 ) ) ? ( _rtDW ->
SaccadeExecutiontime_IWORK . Head + 1 ) : 0 ) ; if ( _rtDW ->
SaccadeExecutiontime_IWORK . Head == _rtDW -> SaccadeExecutiontime_IWORK .
Tail ) { if ( ! HybridSaccadeFF_acc_rt_TDelayUpdateTailOrGrowBuf ( & _rtDW ->
SaccadeExecutiontime_IWORK . CircularBufSize , & _rtDW ->
SaccadeExecutiontime_IWORK . Tail , & _rtDW -> SaccadeExecutiontime_IWORK .
Head , & _rtDW -> SaccadeExecutiontime_IWORK . Last , simTime - _rtP -> P_7 ,
tBuffer , uBuffer , ( NULL ) , ( boolean_T ) 0 , false , & _rtDW ->
SaccadeExecutiontime_IWORK . MaxNewBufSize ) ) { ssSetErrorStatus ( S ,
"tdelay memory allocation error" ) ; return ; } } ( * tBuffer ) [ _rtDW ->
SaccadeExecutiontime_IWORK . Head ] = simTime ; ( * uBuffer ) [ _rtDW ->
SaccadeExecutiontime_IWORK . Head ] = _rtB -> B_3_9_0 ; } isHit =
ssIsSampleHit ( S , 1 , 0 ) ; if ( isHit != 0 ) { _rtDW ->
Memory1_PreviousInput = _rtB -> B_3_11_0 ; _rtDW -> Memory_PreviousInput =
_rtB -> B_3_25_0 ; _rtDW -> LastOutput_PreviousInput = _rtB -> B_3_21_0 ; } {
real_T * * uBuffer = ( real_T * * ) & _rtDW -> NeurologicalDelay_PWORK .
TUbufferPtrs [ 0 ] ; real_T * * tBuffer = ( real_T * * ) & _rtDW ->
NeurologicalDelay_PWORK . TUbufferPtrs [ 1 ] ; real_T simTime = ssGetT ( S )
; _rtDW -> NeurologicalDelay_IWORK . Head = ( ( _rtDW ->
NeurologicalDelay_IWORK . Head < ( _rtDW -> NeurologicalDelay_IWORK .
CircularBufSize - 1 ) ) ? ( _rtDW -> NeurologicalDelay_IWORK . Head + 1 ) : 0
) ; if ( _rtDW -> NeurologicalDelay_IWORK . Head == _rtDW ->
NeurologicalDelay_IWORK . Tail ) { if ( !
HybridSaccadeFF_acc_rt_TDelayUpdateTailOrGrowBuf ( & _rtDW ->
NeurologicalDelay_IWORK . CircularBufSize , & _rtDW ->
NeurologicalDelay_IWORK . Tail , & _rtDW -> NeurologicalDelay_IWORK . Head ,
& _rtDW -> NeurologicalDelay_IWORK . Last , simTime - _rtP -> P_12 , tBuffer
, uBuffer , ( NULL ) , ( boolean_T ) 0 , false , & _rtDW ->
NeurologicalDelay_IWORK . MaxNewBufSize ) ) { ssSetErrorStatus ( S ,
"tdelay memory allocation error" ) ; return ; } } ( * tBuffer ) [ _rtDW ->
NeurologicalDelay_IWORK . Head ] = simTime ; ( * uBuffer ) [ _rtDW ->
NeurologicalDelay_IWORK . Head ] = _rtB -> B_3_25_0 ; } UNUSED_PARAMETER (
tid ) ; }
#define MDL_UPDATE
static void mdlUpdateTID2 ( SimStruct * S , int_T tid ) { UNUSED_PARAMETER (
tid ) ; }
#define MDL_DERIVATIVES
static void mdlDerivatives ( SimStruct * S ) { B_HybridSaccadeFF_T * _rtB ;
P_HybridSaccadeFF_T * _rtP ; XDot_HybridSaccadeFF_T * _rtXdot ;
DW_HybridSaccadeFF_T * _rtDW ; _rtDW = ( ( DW_HybridSaccadeFF_T * )
ssGetRootDWork ( S ) ) ; _rtXdot = ( ( XDot_HybridSaccadeFF_T * ) ssGetdX ( S
) ) ; _rtP = ( ( P_HybridSaccadeFF_T * ) ssGetModelRtp ( S ) ) ; _rtB = ( (
B_HybridSaccadeFF_T * ) _ssGetModelBlockIO ( S ) ) ; if ( ! _rtB -> B_3_5_0 )
{ _rtXdot -> Integrator1_CSTATE = _rtB -> B_3_28_0 ; } else { _rtXdot ->
Integrator1_CSTATE = 0.0 ; } if ( _rtDW -> EnabledSubsystem_MODE ) { _rtXdot
-> Internal_CSTATE = 0.0 ; _rtXdot -> Internal_CSTATE += _rtP -> P_1 * _rtB
-> B_3_31_0 ; } else { ( ( XDot_HybridSaccadeFF_T * ) ssGetdX ( S ) ) ->
Internal_CSTATE = 0.0 ; } } static void mdlInitializeSizes ( SimStruct * S )
{ ssSetChecksumVal ( S , 0 , 3863805205U ) ; ssSetChecksumVal ( S , 1 ,
3675486573U ) ; ssSetChecksumVal ( S , 2 , 2603714256U ) ; ssSetChecksumVal (
S , 3 , 916260144U ) ; { mxArray * slVerStructMat = NULL ; mxArray * slStrMat
= mxCreateString ( "simulink" ) ; char slVerChar [ 10 ] ; int status =
mexCallMATLAB ( 1 , & slVerStructMat , 1 , & slStrMat , "ver" ) ; if ( status
== 0 ) { mxArray * slVerMat = mxGetField ( slVerStructMat , 0 , "Version" ) ;
if ( slVerMat == NULL ) { status = 1 ; } else { status = mxGetString (
slVerMat , slVerChar , 10 ) ; } } mxDestroyArray ( slStrMat ) ;
mxDestroyArray ( slVerStructMat ) ; if ( ( status == 1 ) || ( strcmp (
slVerChar , "10.1" ) != 0 ) ) { return ; } } ssSetOptions ( S ,
SS_OPTION_EXCEPTION_FREE_CODE ) ; if ( ssGetSizeofDWork ( S ) != sizeof (
DW_HybridSaccadeFF_T ) ) { ssSetErrorStatus ( S ,
"Unexpected error: Internal DWork sizes do "
"not match for accelerator mex file." ) ; } if ( ssGetSizeofGlobalBlockIO ( S
) != sizeof ( B_HybridSaccadeFF_T ) ) { ssSetErrorStatus ( S ,
"Unexpected error: Internal BlockIO sizes do "
"not match for accelerator mex file." ) ; } { int ssSizeofParams ;
ssGetSizeofParams ( S , & ssSizeofParams ) ; if ( ssSizeofParams != sizeof (
P_HybridSaccadeFF_T ) ) { static char msg [ 256 ] ; sprintf ( msg ,
"Unexpected error: Internal Parameters sizes do "
"not match for accelerator mex file." ) ; } } _ssSetModelRtp ( S , ( real_T *
) & HybridSaccadeFF_rtDefaultP ) ; rt_InitInfAndNaN ( sizeof ( real_T ) ) ; (
( P_HybridSaccadeFF_T * ) ssGetModelRtp ( S ) ) -> P_14 = rtInf ; ( (
P_HybridSaccadeFF_T * ) ssGetModelRtp ( S ) ) -> P_15 = rtMinusInf ; } static
void mdlInitializeSampleTimes ( SimStruct * S ) { slAccRegPrmChangeFcn ( S ,
mdlOutputsTID2 ) ; } static void mdlTerminate ( SimStruct * S ) { }
#include "simulink.c"
