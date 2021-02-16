#include "rt_logging_mmi.h"
#include "HybridSaccadeFF_capi.h"
#include <math.h>
#include "HybridSaccadeFF.h"
#include "HybridSaccadeFF_private.h"
#include "HybridSaccadeFF_dt.h"
extern void * CreateDiagnosticAsVoidPtr_wrapper ( const char * id , int nargs
, ... ) ; RTWExtModeInfo * gblRTWExtModeInfo = NULL ; extern boolean_T
gblExtModeStartPktReceived ; void raccelForceExtModeShutdown ( ) { if ( !
gblExtModeStartPktReceived ) { boolean_T stopRequested = false ;
rtExtModeWaitForStartPkt ( gblRTWExtModeInfo , 2 , & stopRequested ) ; }
rtExtModeShutdown ( 2 ) ; }
#include "slsv_diagnostic_codegen_c_api.h"
const int_T gblNumToFiles = 0 ; const int_T gblNumFrFiles = 0 ; const int_T
gblNumFrWksBlocks = 1 ;
#ifdef RSIM_WITH_SOLVER_MULTITASKING
boolean_T gbl_raccel_isMultitasking = 1 ;
#else
boolean_T gbl_raccel_isMultitasking = 0 ;
#endif
boolean_T gbl_raccel_tid01eq = 1 ; int_T gbl_raccel_NumST = 3 ; const char_T
* gbl_raccel_Version = "10.1 (R2020a) 18-Nov-2019" ; void
raccel_setup_MMIStateLog ( SimStruct * S ) {
#ifdef UseMMIDataLogging
rt_FillStateSigInfoFromMMI ( ssGetRTWLogInfo ( S ) , & ssGetErrorStatus ( S )
) ;
#else
UNUSED_PARAMETER ( S ) ;
#endif
} static DataMapInfo rt_dataMapInfo ; DataMapInfo * rt_dataMapInfoPtr = &
rt_dataMapInfo ; rtwCAPI_ModelMappingInfo * rt_modelMapInfoPtr = & (
rt_dataMapInfo . mmi ) ; const char * gblSlvrJacPatternFileName =
"slprj\\raccel\\HybridSaccadeFF\\HybridSaccadeFF_Jpattern.mat" ; const int_T
gblNumRootInportBlks = 0 ; const int_T gblNumModelInputs = 0 ; extern
rtInportTUtable * gblInportTUtables ; extern const char * gblInportFileName ;
extern void * gblAperiodicPartitionHitTimes ; const int_T
gblInportDataTypeIdx [ ] = { - 1 } ; const int_T gblInportDims [ ] = { - 1 }
; const int_T gblInportComplex [ ] = { - 1 } ; const int_T
gblInportInterpoFlag [ ] = { - 1 } ; const int_T gblInportContinuous [ ] = {
- 1 } ; int_T enableFcnCallFlag [ ] = { 1 , 1 , 1 } ; const char *
raccelLoadInputsAndAperiodicHitTimes ( const char * inportFileName , int *
matFileFormat ) { return rt_RapidReadInportsMatFile ( inportFileName ,
matFileFormat , 1 ) ; }
#include "simstruc.h"
#include "fixedpoint.h"
B rtB ; X rtX ; DW rtDW ; PrevZCX rtPrevZCX ; static SimStruct model_S ;
SimStruct * const rtS = & model_S ;
#ifndef __RTW_UTFREE__  
extern void * utMalloc ( size_t ) ;
#endif
void * rt_TDelayCreateBuf ( int_T numBuffer , int_T bufSz , int_T elemSz ) {
return ( ( void * ) utMalloc ( numBuffer * bufSz * elemSz ) ) ; }
#ifndef __RTW_UTFREE__  
extern void * utMalloc ( size_t ) ; extern void utFree ( void * ) ;
#endif
boolean_T rt_TDelayUpdateTailOrGrowBuf ( int_T * bufSzPtr , int_T * tailPtr ,
int_T * headPtr , int_T * lastPtr , real_T tMinusDelay , real_T * * tBufPtr ,
real_T * * uBufPtr , real_T * * xBufPtr , boolean_T isfixedbuf , boolean_T
istransportdelay , int_T * maxNewBufSzPtr ) { int_T testIdx ; int_T tail = *
tailPtr ; int_T bufSz = * bufSzPtr ; real_T * tBuf = * tBufPtr ; real_T *
xBuf = ( NULL ) ; int_T numBuffer = 2 ; if ( istransportdelay ) { numBuffer =
3 ; xBuf = * xBufPtr ; } testIdx = ( tail < ( bufSz - 1 ) ) ? ( tail + 1 ) :
0 ; if ( ( tMinusDelay <= tBuf [ testIdx ] ) && ! isfixedbuf ) { int_T j ;
real_T * tempT ; real_T * tempU ; real_T * tempX = ( NULL ) ; real_T * uBuf =
* uBufPtr ; int_T newBufSz = bufSz + 1024 ; if ( newBufSz > * maxNewBufSzPtr
) { * maxNewBufSzPtr = newBufSz ; } tempU = ( real_T * ) utMalloc ( numBuffer
* newBufSz * sizeof ( real_T ) ) ; if ( tempU == ( NULL ) ) { return ( false
) ; } tempT = tempU + newBufSz ; if ( istransportdelay ) tempX = tempT +
newBufSz ; for ( j = tail ; j < bufSz ; j ++ ) { tempT [ j - tail ] = tBuf [
j ] ; tempU [ j - tail ] = uBuf [ j ] ; if ( istransportdelay ) tempX [ j -
tail ] = xBuf [ j ] ; } for ( j = 0 ; j < tail ; j ++ ) { tempT [ j + bufSz -
tail ] = tBuf [ j ] ; tempU [ j + bufSz - tail ] = uBuf [ j ] ; if (
istransportdelay ) tempX [ j + bufSz - tail ] = xBuf [ j ] ; } if ( * lastPtr
> tail ) { * lastPtr -= tail ; } else { * lastPtr += ( bufSz - tail ) ; } *
tailPtr = 0 ; * headPtr = bufSz ; utFree ( uBuf ) ; * bufSzPtr = newBufSz ; *
tBufPtr = tempT ; * uBufPtr = tempU ; if ( istransportdelay ) * xBufPtr =
tempX ; } else { * tailPtr = testIdx ; } return ( true ) ; } real_T
rt_TDelayInterpolate ( real_T tMinusDelay , real_T tStart , real_T * tBuf ,
real_T * uBuf , int_T bufSz , int_T * lastIdx , int_T oldestIdx , int_T
newIdx , real_T initOutput , boolean_T discrete , boolean_T
minorStepAndTAtLastMajorOutput ) { int_T i ; real_T yout , t1 , t2 , u1 , u2
; if ( ( newIdx == 0 ) && ( oldestIdx == 0 ) && ( tMinusDelay > tStart ) )
return initOutput ; if ( tMinusDelay <= tStart ) return initOutput ; if ( (
tMinusDelay <= tBuf [ oldestIdx ] ) ) { if ( discrete ) { return ( uBuf [
oldestIdx ] ) ; } else { int_T tempIdx = oldestIdx + 1 ; if ( oldestIdx ==
bufSz - 1 ) tempIdx = 0 ; t1 = tBuf [ oldestIdx ] ; t2 = tBuf [ tempIdx ] ;
u1 = uBuf [ oldestIdx ] ; u2 = uBuf [ tempIdx ] ; if ( t2 == t1 ) { if (
tMinusDelay >= t2 ) { yout = u2 ; } else { yout = u1 ; } } else { real_T f1 =
( t2 - tMinusDelay ) / ( t2 - t1 ) ; real_T f2 = 1.0 - f1 ; yout = f1 * u1 +
f2 * u2 ; } return yout ; } } if ( minorStepAndTAtLastMajorOutput ) { if (
newIdx != 0 ) { if ( * lastIdx == newIdx ) { ( * lastIdx ) -- ; } newIdx -- ;
} else { if ( * lastIdx == newIdx ) { * lastIdx = bufSz - 1 ; } newIdx =
bufSz - 1 ; } } i = * lastIdx ; if ( tBuf [ i ] < tMinusDelay ) { while (
tBuf [ i ] < tMinusDelay ) { if ( i == newIdx ) break ; i = ( i < ( bufSz - 1
) ) ? ( i + 1 ) : 0 ; } } else { while ( tBuf [ i ] >= tMinusDelay ) { i = (
i > 0 ) ? i - 1 : ( bufSz - 1 ) ; } i = ( i < ( bufSz - 1 ) ) ? ( i + 1 ) : 0
; } * lastIdx = i ; if ( discrete ) { double tempEps = ( DBL_EPSILON ) *
128.0 ; double localEps = tempEps * muDoubleScalarAbs ( tBuf [ i ] ) ; if (
tempEps > localEps ) { localEps = tempEps ; } localEps = localEps / 2.0 ; if
( tMinusDelay >= ( tBuf [ i ] - localEps ) ) { yout = uBuf [ i ] ; } else {
if ( i == 0 ) { yout = uBuf [ bufSz - 1 ] ; } else { yout = uBuf [ i - 1 ] ;
} } } else { if ( i == 0 ) { t1 = tBuf [ bufSz - 1 ] ; u1 = uBuf [ bufSz - 1
] ; } else { t1 = tBuf [ i - 1 ] ; u1 = uBuf [ i - 1 ] ; } t2 = tBuf [ i ] ;
u2 = uBuf [ i ] ; if ( t2 == t1 ) { if ( tMinusDelay >= t2 ) { yout = u2 ; }
else { yout = u1 ; } } else { real_T f1 = ( t2 - tMinusDelay ) / ( t2 - t1 )
; real_T f2 = 1.0 - f1 ; yout = f1 * u1 + f2 * u2 ; } } return ( yout ) ; }
#ifndef __RTW_UTFREE__  
extern void utFree ( void * ) ;
#endif
void rt_TDelayFreeBuf ( void * buf ) { utFree ( buf ) ; } void MdlInitialize
( void ) { rtDW . cxuxej1fem = rtP . Memory3_InitialCondition ; rtDW .
fqyklb41f5 = rtP . Memory2_InitialCondition ; rtX . awoq5tf10b = rtP .
Integrator1_IC ; if ( ! ssIsFirstInitCond ( rtS ) ) {
ssSetContTimeOutputInconsistentWithStateAtMajorStep ( rtS ) ; } rtDW .
l54phutyhz = rtP . Memory1_InitialCondition ; rtDW . jpe5cwfb50 = rtP .
Memory_InitialCondition ; rtDW . lhrsky5wel = rtP .
LastOutput_InitialCondition ; rtX . crhmgzcgl3 = rtP .
Internal_InitialCondition ; rtB . npca3gyxjj = rtP . Out1_Y0 ; } void
MdlStart ( void ) { { void * * slioCatalogueAddr = rt_slioCatalogueAddr ( ) ;
void * r2 = ( NULL ) ; void * * pOSigstreamManagerAddr = ( NULL ) ; const int
maxErrorBufferSize = 16384 ; char errMsgCreatingOSigstreamManager [ 16384 ] ;
bool errorCreatingOSigstreamManager = false ; const char *
errorAddingR2SharedResource = ( NULL ) ; * slioCatalogueAddr =
rtwGetNewSlioCatalogue ( rt_GetMatSigLogSelectorFileName ( ) ) ;
errorAddingR2SharedResource = rtwAddR2SharedResource (
rtwGetPointerFromUniquePtr ( rt_slioCatalogue ( ) ) , 1 ) ; if (
errorAddingR2SharedResource != ( NULL ) ) { rtwTerminateSlioCatalogue (
slioCatalogueAddr ) ; * slioCatalogueAddr = ( NULL ) ; ssSetErrorStatus ( rtS
, errorAddingR2SharedResource ) ; return ; } r2 = rtwGetR2SharedResource (
rtwGetPointerFromUniquePtr ( rt_slioCatalogue ( ) ) ) ;
pOSigstreamManagerAddr = rt_GetOSigstreamManagerAddr ( ) ;
errorCreatingOSigstreamManager = rtwOSigstreamManagerCreateInstance (
rt_GetMatSigLogSelectorFileName ( ) , r2 , pOSigstreamManagerAddr ,
errMsgCreatingOSigstreamManager , maxErrorBufferSize ) ; if (
errorCreatingOSigstreamManager ) { * pOSigstreamManagerAddr = ( NULL ) ;
ssSetErrorStatus ( rtS , errMsgCreatingOSigstreamManager ) ; return ; } } {
bool externalInputIsInDatasetFormat = false ; void * pISigstreamManager =
rt_GetISigstreamManager ( ) ; rtwISigstreamManagerGetInputIsInDatasetFormat (
pISigstreamManager , & externalInputIsInDatasetFormat ) ; if (
externalInputIsInDatasetFormat ) { } } { int_T dimensions [ 1 ] = { 1 } ;
rtDW . hsi2bse4xr . LoggedData = rt_CreateLogVar ( ssGetRTWLogInfo ( rtS ) ,
ssGetTStart ( rtS ) , ssGetTFinal ( rtS ) , 0.0 , ( & ssGetErrorStatus ( rtS
) ) , "interror" , SS_DOUBLE , 0 , 0 , 0 , 1 , 1 , dimensions , NO_LOGVALDIMS
, ( NULL ) , ( NULL ) , 0 , 1 , 0.005 , 1 ) ; if ( rtDW . hsi2bse4xr .
LoggedData == ( NULL ) ) return ; } { int_T dimensions [ 1 ] = { 1 } ; rtDW .
bewaxyjsxf . LoggedData = rt_CreateLogVar ( ssGetRTWLogInfo ( rtS ) ,
ssGetTStart ( rtS ) , ssGetTFinal ( rtS ) , 0.0 , ( & ssGetErrorStatus ( rtS
) ) , "V_out" , SS_DOUBLE , 0 , 0 , 0 , 1 , 1 , dimensions , NO_LOGVALDIMS ,
( NULL ) , ( NULL ) , 0 , 1 , 0.005 , 1 ) ; if ( rtDW . bewaxyjsxf .
LoggedData == ( NULL ) ) return ; } { { real_T * pBuffer = ( real_T * )
rt_TDelayCreateBuf ( 2 , 1024 , sizeof ( real_T ) ) ; if ( pBuffer == ( NULL
) ) { ssSetErrorStatus ( rtS , "tdelay memory allocation error" ) ; return ;
} rtDW . dqh0z5crxa . Tail = 0 ; rtDW . dqh0z5crxa . Head = 0 ; rtDW .
dqh0z5crxa . Last = 0 ; rtDW . dqh0z5crxa . CircularBufSize = 1024 ; pBuffer
[ 0 ] = rtP . SaccadeExecutiontime_InitOutput ; pBuffer [ 1024 ] = ssGetT (
rtS ) ; rtDW . jzkzl30hxw . TUbufferPtrs [ 0 ] = ( void * ) & pBuffer [ 0 ] ;
rtDW . jzkzl30hxw . TUbufferPtrs [ 1 ] = ( void * ) & pBuffer [ 1024 ] ; } }
{ FWksInfo * fromwksInfo ; if ( ( fromwksInfo = ( FWksInfo * ) calloc ( 1 ,
sizeof ( FWksInfo ) ) ) == ( NULL ) ) { ssSetErrorStatus ( rtS ,
"from workspace STRING(Name) memory allocation error" ) ; } else {
fromwksInfo -> origWorkspaceVarName = "V_in" ; fromwksInfo -> origDataTypeId
= 0 ; fromwksInfo -> origIsComplex = 0 ; fromwksInfo -> origWidth = 1 ;
fromwksInfo -> origElSize = sizeof ( real_T ) ; fromwksInfo -> data = ( void
* ) rtP . FromWorkspace_Data0 ; fromwksInfo -> nDataPoints = 2001 ;
fromwksInfo -> time = ( double * ) rtP . FromWorkspace_Time0 ; rtDW .
apnnhgulim . TimePtr = fromwksInfo -> time ; rtDW . apnnhgulim . DataPtr =
fromwksInfo -> data ; rtDW . apnnhgulim . RSimInfoPtr = fromwksInfo ; } rtDW
. h2xjgzuuat . PrevIndex = 0 ; } rtDW . c2h2rz5b30 = false ;
ssSetBlockStateForSolverChangedAtMajorStep ( rtS ) ; { { real_T * pBuffer = (
real_T * ) rt_TDelayCreateBuf ( 2 , 1024 , sizeof ( real_T ) ) ; if ( pBuffer
== ( NULL ) ) { ssSetErrorStatus ( rtS , "tdelay memory allocation error" ) ;
return ; } rtDW . j5oxfm5lji . Tail = 0 ; rtDW . j5oxfm5lji . Head = 0 ; rtDW
. j5oxfm5lji . Last = 0 ; rtDW . j5oxfm5lji . CircularBufSize = 1024 ;
pBuffer [ 0 ] = rtP . NeurologicalDelay_InitOutput ; pBuffer [ 1024 ] =
ssGetT ( rtS ) ; rtDW . okmhtyxt54 . TUbufferPtrs [ 0 ] = ( void * ) &
pBuffer [ 0 ] ; rtDW . okmhtyxt54 . TUbufferPtrs [ 1 ] = ( void * ) & pBuffer
[ 1024 ] ; } } MdlInitialize ( ) ; } void MdlOutputs ( int_T tid ) { real_T
pvzvlavali ; real_T i2p4hy0ep0 ; boolean_T stateChanged ; boolean_T
didZcEventOccur ; boolean_T k1tlnwwlcw ; real_T aylxn2c2jp ; srClearBC ( rtDW
. irumfm1oxp ) ; k1tlnwwlcw = ( muDoubleScalarAbs ( rtX . awoq5tf10b ) > rtP
. switch_thresh ) ; if ( ssIsSampleHit ( rtS , 1 , 0 ) ) { if ( rtDW .
fqyklb41f5 ) { rtB . jktyvjmrgo = rtDW . cxuxej1fem ; } else { rtB .
jktyvjmrgo = rtP . Constant1_Value ; } } rtB . b2dt5rhhow = ( k1tlnwwlcw || (
rtB . jktyvjmrgo != 0.0 ) ) ; if ( ssIsMajorTimeStep ( rtS ) ) { stateChanged
= false ; didZcEventOccur = ( ( ( rtPrevZCX . p5axgerwfh == 1 ) != ( int32_T
) rtB . b2dt5rhhow ) && ( rtPrevZCX . p5axgerwfh != 3 ) ) ; rtPrevZCX .
p5axgerwfh = rtB . b2dt5rhhow ; if ( rtB . b2dt5rhhow ) { didZcEventOccur =
true ; rtX . awoq5tf10b = rtP . Integrator1_IC ; stateChanged = true ; } if (
didZcEventOccur ) { ssSetBlockStateForSolverChangedAtMajorStep ( rtS ) ; if (
stateChanged ) { ssSetContTimeOutputInconsistentWithStateAtMajorStep ( rtS )
; } } } rtB . ccv0nxufjm = rtX . awoq5tf10b ; if ( ssIsSampleHit ( rtS , 1 ,
0 ) ) { if ( ssGetLogOutput ( rtS ) ) { { double locTime = ssGetTaskTime (
rtS , 1 ) ; ; if ( rtwTimeInLoggingInterval ( rtliGetLoggingInterval (
ssGetRootSS ( rtS ) -> mdlInfo -> rtwLogInfo ) , locTime ) ) {
rt_UpdateLogVar ( ( LogVar * ) ( LogVar * ) ( rtDW . hsi2bse4xr . LoggedData
) , & rtB . ccv0nxufjm , 0 ) ; } } } } { real_T * * uBuffer = ( real_T * * )
& rtDW . jzkzl30hxw . TUbufferPtrs [ 0 ] ; real_T * * tBuffer = ( real_T * *
) & rtDW . jzkzl30hxw . TUbufferPtrs [ 1 ] ; real_T simTime = ssGetT ( rtS )
; real_T tMinusDelay = simTime - rtP . sac_time ; pvzvlavali =
rt_TDelayInterpolate ( tMinusDelay , 0.0 , * tBuffer , * uBuffer , rtDW .
dqh0z5crxa . CircularBufSize , & rtDW . dqh0z5crxa . Last , rtDW . dqh0z5crxa
. Tail , rtDW . dqh0z5crxa . Head , rtP . SaccadeExecutiontime_InitOutput , 0
, ( boolean_T ) ( ssIsMinorTimeStep ( rtS ) && ( ssGetTimeOfLastOutput ( rtS
) == ssGetT ( rtS ) ) ) ) ; } { real_T * pDataValues = ( real_T * ) rtDW .
apnnhgulim . DataPtr ; real_T * pTimeValues = ( real_T * ) rtDW . apnnhgulim
. TimePtr ; int_T currTimeIndex = rtDW . h2xjgzuuat . PrevIndex ; real_T t =
ssGetTaskTime ( rtS , 0 ) ; int numPoints , lastPoint ; FWksInfo *
fromwksInfo = ( FWksInfo * ) rtDW . apnnhgulim . RSimInfoPtr ; numPoints =
fromwksInfo -> nDataPoints ; lastPoint = numPoints - 1 ; if ( t <=
pTimeValues [ 0 ] ) { currTimeIndex = 0 ; } else if ( t >= pTimeValues [
lastPoint ] ) { currTimeIndex = lastPoint - 1 ; } else { if ( t < pTimeValues
[ currTimeIndex ] ) { while ( t < pTimeValues [ currTimeIndex ] ) {
currTimeIndex -- ; } } else { while ( t >= pTimeValues [ currTimeIndex + 1 ]
) { currTimeIndex ++ ; } } } rtDW . h2xjgzuuat . PrevIndex = currTimeIndex ;
{ real_T t1 = pTimeValues [ currTimeIndex ] ; real_T t2 = pTimeValues [
currTimeIndex + 1 ] ; if ( t1 == t2 ) { if ( t < t1 ) { rtB . gdj3m1nfho =
pDataValues [ currTimeIndex ] ; } else { rtB . gdj3m1nfho = pDataValues [
currTimeIndex + 1 ] ; } } else { real_T f1 = ( t2 - t ) / ( t2 - t1 ) ;
real_T f2 = 1.0 - f1 ; real_T d1 ; real_T d2 ; int_T TimeIndex =
currTimeIndex ; d1 = pDataValues [ TimeIndex ] ; d2 = pDataValues [ TimeIndex
+ 1 ] ; rtB . gdj3m1nfho = ( real_T ) rtInterpolate ( d1 , d2 , f1 , f2 ) ;
pDataValues += numPoints ; } } } if ( ssIsSampleHit ( rtS , 1 , 0 ) ) { rtB .
hnga2lbxre = rtDW . l54phutyhz ; } if ( k1tlnwwlcw ) { rtB . bydpu1oymy = rtB
. gdj3m1nfho ; } else { rtB . bydpu1oymy = rtB . hnga2lbxre ; } rtB .
hz4uiyeou1 = ( muDoubleScalarAbs ( rtB . bydpu1oymy - pvzvlavali ) > rtP .
Constant2_Value ) ; k1tlnwwlcw = ! rtB . hz4uiyeou1 ; if ( ssIsSampleHit (
rtS , 1 , 0 ) ) { rtB . gaba2pigju = rtDW . jpe5cwfb50 ; rtB . e35j4h45yz =
rtDW . lhrsky5wel ; } if ( k1tlnwwlcw && rtB . b2dt5rhhow ) { rtB .
ng1zasawwk = pvzvlavali ; } else if ( rtB . b2dt5rhhow ) { if ( k1tlnwwlcw )
{ rtB . ng1zasawwk = pvzvlavali ; } else { rtB . ng1zasawwk = rtB .
gaba2pigju ; } } else { rtB . ng1zasawwk = rtB . e35j4h45yz ; } if (
ssIsSampleHit ( rtS , 1 , 0 ) && ssIsMajorTimeStep ( rtS ) ) { if ( ! rtB .
b2dt5rhhow ) { if ( ! rtDW . c2h2rz5b30 ) { if ( ssGetTaskTime ( rtS , 1 ) !=
ssGetTStart ( rtS ) ) { ssSetBlockStateForSolverChangedAtMajorStep ( rtS ) ;
} rtX . crhmgzcgl3 = rtP . Internal_InitialCondition ; rtDW . c2h2rz5b30 =
true ; } } else { if ( rtDW . c2h2rz5b30 ) {
ssSetBlockStateForSolverChangedAtMajorStep ( rtS ) ; rtDW . c2h2rz5b30 =
false ; } } } if ( rtDW . c2h2rz5b30 ) { rtB . npca3gyxjj = 0.0 ; rtB .
npca3gyxjj += rtP . Internal_C * rtX . crhmgzcgl3 ; if ( ssIsMajorTimeStep (
rtS ) ) { srUpdateBC ( rtDW . irumfm1oxp ) ; } } if ( rtB . b2dt5rhhow ) {
aylxn2c2jp = rtP . Constant_Value ; } else { aylxn2c2jp = rtB . npca3gyxjj ;
} rtB . hlhz4puca1 = rtB . ng1zasawwk + aylxn2c2jp ; if ( ssIsSampleHit ( rtS
, 1 , 0 ) ) { if ( ssGetLogOutput ( rtS ) ) { { double locTime =
ssGetTaskTime ( rtS , 1 ) ; ; if ( rtwTimeInLoggingInterval (
rtliGetLoggingInterval ( ssGetRootSS ( rtS ) -> mdlInfo -> rtwLogInfo ) ,
locTime ) ) { rt_UpdateLogVar ( ( LogVar * ) ( LogVar * ) ( rtDW . bewaxyjsxf
. LoggedData ) , & rtB . hlhz4puca1 , 0 ) ; } } } } { real_T * * uBuffer = (
real_T * * ) & rtDW . okmhtyxt54 . TUbufferPtrs [ 0 ] ; real_T * * tBuffer =
( real_T * * ) & rtDW . okmhtyxt54 . TUbufferPtrs [ 1 ] ; real_T simTime =
ssGetT ( rtS ) ; real_T tMinusDelay = simTime - rtP . n_delay ; i2p4hy0ep0 =
rt_TDelayInterpolate ( tMinusDelay , 0.0 , * tBuffer , * uBuffer , rtDW .
j5oxfm5lji . CircularBufSize , & rtDW . j5oxfm5lji . Last , rtDW . j5oxfm5lji
. Tail , rtDW . j5oxfm5lji . Head , rtP . NeurologicalDelay_InitOutput , 0 ,
( boolean_T ) ( ssIsMinorTimeStep ( rtS ) && ( ssGetTimeOfLastOutput ( rtS )
== ssGetT ( rtS ) ) ) ) ; } rtB . fj53apf4xs = rtB . gdj3m1nfho - i2p4hy0ep0
; if ( rtB . b2dt5rhhow ) { aylxn2c2jp = rtP . Constant_Value_dlokgks1d5 ; }
else { aylxn2c2jp = rtP . K_P * rtB . fj53apf4xs + rtP . K_I * rtB .
ccv0nxufjm ; } if ( aylxn2c2jp > rtP . T_lim_up ) { rtB . nflkjfkiic = rtP .
T_lim_up ; } else if ( aylxn2c2jp < rtP . T_lim_low ) { rtB . nflkjfkiic =
rtP . T_lim_low ; } else { rtB . nflkjfkiic = aylxn2c2jp ; } UNUSED_PARAMETER
( tid ) ; } void MdlUpdate ( int_T tid ) { if ( ssIsSampleHit ( rtS , 1 , 0 )
) { rtDW . cxuxej1fem = rtB . hz4uiyeou1 ; rtDW . fqyklb41f5 = rtB .
b2dt5rhhow ; } { real_T * * uBuffer = ( real_T * * ) & rtDW . jzkzl30hxw .
TUbufferPtrs [ 0 ] ; real_T * * tBuffer = ( real_T * * ) & rtDW . jzkzl30hxw
. TUbufferPtrs [ 1 ] ; real_T simTime = ssGetT ( rtS ) ; rtDW . dqh0z5crxa .
Head = ( ( rtDW . dqh0z5crxa . Head < ( rtDW . dqh0z5crxa . CircularBufSize -
1 ) ) ? ( rtDW . dqh0z5crxa . Head + 1 ) : 0 ) ; if ( rtDW . dqh0z5crxa .
Head == rtDW . dqh0z5crxa . Tail ) { if ( ! rt_TDelayUpdateTailOrGrowBuf ( &
rtDW . dqh0z5crxa . CircularBufSize , & rtDW . dqh0z5crxa . Tail , & rtDW .
dqh0z5crxa . Head , & rtDW . dqh0z5crxa . Last , simTime - rtP . sac_time ,
tBuffer , uBuffer , ( NULL ) , ( boolean_T ) 0 , false , & rtDW . dqh0z5crxa
. MaxNewBufSize ) ) { ssSetErrorStatus ( rtS ,
"tdelay memory allocation error" ) ; return ; } } ( * tBuffer ) [ rtDW .
dqh0z5crxa . Head ] = simTime ; ( * uBuffer ) [ rtDW . dqh0z5crxa . Head ] =
rtB . gdj3m1nfho ; } if ( ssIsSampleHit ( rtS , 1 , 0 ) ) { rtDW . l54phutyhz
= rtB . bydpu1oymy ; rtDW . jpe5cwfb50 = rtB . hlhz4puca1 ; rtDW . lhrsky5wel
= rtB . ng1zasawwk ; } { real_T * * uBuffer = ( real_T * * ) & rtDW .
okmhtyxt54 . TUbufferPtrs [ 0 ] ; real_T * * tBuffer = ( real_T * * ) & rtDW
. okmhtyxt54 . TUbufferPtrs [ 1 ] ; real_T simTime = ssGetT ( rtS ) ; rtDW .
j5oxfm5lji . Head = ( ( rtDW . j5oxfm5lji . Head < ( rtDW . j5oxfm5lji .
CircularBufSize - 1 ) ) ? ( rtDW . j5oxfm5lji . Head + 1 ) : 0 ) ; if ( rtDW
. j5oxfm5lji . Head == rtDW . j5oxfm5lji . Tail ) { if ( !
rt_TDelayUpdateTailOrGrowBuf ( & rtDW . j5oxfm5lji . CircularBufSize , & rtDW
. j5oxfm5lji . Tail , & rtDW . j5oxfm5lji . Head , & rtDW . j5oxfm5lji . Last
, simTime - rtP . n_delay , tBuffer , uBuffer , ( NULL ) , ( boolean_T ) 0 ,
false , & rtDW . j5oxfm5lji . MaxNewBufSize ) ) { ssSetErrorStatus ( rtS ,
"tdelay memory allocation error" ) ; return ; } } ( * tBuffer ) [ rtDW .
j5oxfm5lji . Head ] = simTime ; ( * uBuffer ) [ rtDW . j5oxfm5lji . Head ] =
rtB . hlhz4puca1 ; } UNUSED_PARAMETER ( tid ) ; } void MdlUpdateTID2 ( int_T
tid ) { UNUSED_PARAMETER ( tid ) ; } void MdlDerivatives ( void ) { XDot *
_rtXdot ; _rtXdot = ( ( XDot * ) ssGetdX ( rtS ) ) ; if ( ! rtB . b2dt5rhhow
) { _rtXdot -> awoq5tf10b = rtB . fj53apf4xs ; } else { _rtXdot -> awoq5tf10b
= 0.0 ; } if ( rtDW . c2h2rz5b30 ) { _rtXdot -> crhmgzcgl3 = 0.0 ; _rtXdot ->
crhmgzcgl3 += rtP . Internal_B * rtB . nflkjfkiic ; } else { ( ( XDot * )
ssGetdX ( rtS ) ) -> crhmgzcgl3 = 0.0 ; } } void MdlProjection ( void ) { }
void MdlTerminate ( void ) { rt_TDelayFreeBuf ( rtDW . jzkzl30hxw .
TUbufferPtrs [ 0 ] ) ; rt_FREE ( rtDW . apnnhgulim . RSimInfoPtr ) ;
rt_TDelayFreeBuf ( rtDW . okmhtyxt54 . TUbufferPtrs [ 0 ] ) ; if (
rt_slioCatalogue ( ) != ( NULL ) ) { void * * slioCatalogueAddr =
rt_slioCatalogueAddr ( ) ; rtwSaveDatasetsToMatFile (
rtwGetPointerFromUniquePtr ( rt_slioCatalogue ( ) ) ,
rt_GetMatSigstreamLoggingFileName ( ) ) ; rtwTerminateSlioCatalogue (
slioCatalogueAddr ) ; * slioCatalogueAddr = NULL ; } } void
MdlInitializeSizes ( void ) { ssSetNumContStates ( rtS , 2 ) ;
ssSetNumPeriodicContStates ( rtS , 0 ) ; ssSetNumY ( rtS , 0 ) ; ssSetNumU (
rtS , 0 ) ; ssSetDirectFeedThrough ( rtS , 0 ) ; ssSetNumSampleTimes ( rtS ,
2 ) ; ssSetNumBlocks ( rtS , 42 ) ; ssSetNumBlockIO ( rtS , 15 ) ;
ssSetNumBlockParams ( rtS , 4025 ) ; } void MdlInitializeSampleTimes ( void )
{ ssSetSampleTime ( rtS , 0 , 0.0 ) ; ssSetSampleTime ( rtS , 1 , 0.005 ) ;
ssSetOffsetTime ( rtS , 0 , 0.0 ) ; ssSetOffsetTime ( rtS , 1 , 0.0 ) ; }
void raccel_set_checksum ( ) { ssSetChecksumVal ( rtS , 0 , 859324911U ) ;
ssSetChecksumVal ( rtS , 1 , 2769031156U ) ; ssSetChecksumVal ( rtS , 2 ,
360706461U ) ; ssSetChecksumVal ( rtS , 3 , 3159082144U ) ; }
#if defined(_MSC_VER)
#pragma optimize( "", off )
#endif
SimStruct * raccel_register_model ( void ) { static struct _ssMdlInfo mdlInfo
; ( void ) memset ( ( char * ) rtS , 0 , sizeof ( SimStruct ) ) ; ( void )
memset ( ( char * ) & mdlInfo , 0 , sizeof ( struct _ssMdlInfo ) ) ;
ssSetMdlInfoPtr ( rtS , & mdlInfo ) ; { static time_T mdlPeriod [
NSAMPLE_TIMES ] ; static time_T mdlOffset [ NSAMPLE_TIMES ] ; static time_T
mdlTaskTimes [ NSAMPLE_TIMES ] ; static int_T mdlTsMap [ NSAMPLE_TIMES ] ;
static int_T mdlSampleHits [ NSAMPLE_TIMES ] ; static boolean_T
mdlTNextWasAdjustedPtr [ NSAMPLE_TIMES ] ; static int_T mdlPerTaskSampleHits
[ NSAMPLE_TIMES * NSAMPLE_TIMES ] ; static time_T mdlTimeOfNextSampleHit [
NSAMPLE_TIMES ] ; { int_T i ; for ( i = 0 ; i < NSAMPLE_TIMES ; i ++ ) {
mdlPeriod [ i ] = 0.0 ; mdlOffset [ i ] = 0.0 ; mdlTaskTimes [ i ] = 0.0 ;
mdlTsMap [ i ] = i ; mdlSampleHits [ i ] = 1 ; } } ssSetSampleTimePtr ( rtS ,
& mdlPeriod [ 0 ] ) ; ssSetOffsetTimePtr ( rtS , & mdlOffset [ 0 ] ) ;
ssSetSampleTimeTaskIDPtr ( rtS , & mdlTsMap [ 0 ] ) ; ssSetTPtr ( rtS , &
mdlTaskTimes [ 0 ] ) ; ssSetSampleHitPtr ( rtS , & mdlSampleHits [ 0 ] ) ;
ssSetTNextWasAdjustedPtr ( rtS , & mdlTNextWasAdjustedPtr [ 0 ] ) ;
ssSetPerTaskSampleHitsPtr ( rtS , & mdlPerTaskSampleHits [ 0 ] ) ;
ssSetTimeOfNextSampleHitPtr ( rtS , & mdlTimeOfNextSampleHit [ 0 ] ) ; }
ssSetSolverMode ( rtS , SOLVER_MODE_SINGLETASKING ) ; { ssSetBlockIO ( rtS ,
( ( void * ) & rtB ) ) ; ( void ) memset ( ( ( void * ) & rtB ) , 0 , sizeof
( B ) ) ; } { real_T * x = ( real_T * ) & rtX ; ssSetContStates ( rtS , x ) ;
( void ) memset ( ( void * ) x , 0 , sizeof ( X ) ) ; } { void * dwork = (
void * ) & rtDW ; ssSetRootDWork ( rtS , dwork ) ; ( void ) memset ( dwork ,
0 , sizeof ( DW ) ) ; } { static DataTypeTransInfo dtInfo ; ( void ) memset (
( char_T * ) & dtInfo , 0 , sizeof ( dtInfo ) ) ; ssSetModelMappingInfo ( rtS
, & dtInfo ) ; dtInfo . numDataTypes = 14 ; dtInfo . dataTypeSizes = &
rtDataTypeSizes [ 0 ] ; dtInfo . dataTypeNames = & rtDataTypeNames [ 0 ] ;
dtInfo . BTransTable = & rtBTransTable ; dtInfo . PTransTable = &
rtPTransTable ; dtInfo . dataTypeInfoTable = rtDataTypeInfoTable ; }
HybridSaccadeFF_InitializeDataMapInfo ( ) ; ssSetIsRapidAcceleratorActive (
rtS , true ) ; ssSetRootSS ( rtS , rtS ) ; ssSetVersion ( rtS ,
SIMSTRUCT_VERSION_LEVEL2 ) ; ssSetModelName ( rtS , "HybridSaccadeFF" ) ;
ssSetPath ( rtS , "HybridSaccadeFF" ) ; ssSetTStart ( rtS , 0.0 ) ;
ssSetTFinal ( rtS , 10.0 ) ; ssSetStepSize ( rtS , 0.005 ) ;
ssSetFixedStepSize ( rtS , 0.005 ) ; { static RTWLogInfo rt_DataLoggingInfo ;
rt_DataLoggingInfo . loggingInterval = NULL ; ssSetRTWLogInfo ( rtS , &
rt_DataLoggingInfo ) ; } { { static int_T rt_LoggedStateWidths [ ] = { 1 , 1
} ; static int_T rt_LoggedStateNumDimensions [ ] = { 1 , 1 } ; static int_T
rt_LoggedStateDimensions [ ] = { 1 , 1 } ; static boolean_T
rt_LoggedStateIsVarDims [ ] = { 0 , 0 } ; static BuiltInDTypeId
rt_LoggedStateDataTypeIds [ ] = { SS_DOUBLE , SS_DOUBLE } ; static int_T
rt_LoggedStateComplexSignals [ ] = { 0 , 0 } ; static RTWPreprocessingFcnPtr
rt_LoggingStatePreprocessingFcnPtrs [ ] = { ( NULL ) , ( NULL ) } ; static
const char_T * rt_LoggedStateLabels [ ] = { "CSTATE" , "CSTATE" } ; static
const char_T * rt_LoggedStateBlockNames [ ] = {
"HybridSaccadeFF/Smooth System/Integrator1" ,
 "HybridSaccadeFF/Plant with reset/Enabled\nSubsystem/Plant (torque to velocity)/Internal"
} ; static const char_T * rt_LoggedStateNames [ ] = { "" , "" } ; static
boolean_T rt_LoggedStateCrossMdlRef [ ] = { 0 , 0 } ; static
RTWLogDataTypeConvert rt_RTWLogDataTypeConvert [ ] = { { 0 , SS_DOUBLE ,
SS_DOUBLE , 0 , 0 , 0 , 1.0 , 0 , 0.0 } , { 0 , SS_DOUBLE , SS_DOUBLE , 0 , 0
, 0 , 1.0 , 0 , 0.0 } } ; static RTWLogSignalInfo rt_LoggedStateSignalInfo =
{ 2 , rt_LoggedStateWidths , rt_LoggedStateNumDimensions ,
rt_LoggedStateDimensions , rt_LoggedStateIsVarDims , ( NULL ) , ( NULL ) ,
rt_LoggedStateDataTypeIds , rt_LoggedStateComplexSignals , ( NULL ) ,
rt_LoggingStatePreprocessingFcnPtrs , { rt_LoggedStateLabels } , ( NULL ) , (
NULL ) , ( NULL ) , { rt_LoggedStateBlockNames } , { rt_LoggedStateNames } ,
rt_LoggedStateCrossMdlRef , rt_RTWLogDataTypeConvert } ; static void *
rt_LoggedStateSignalPtrs [ 2 ] ; rtliSetLogXSignalPtrs ( ssGetRTWLogInfo (
rtS ) , ( LogSignalPtrsType ) rt_LoggedStateSignalPtrs ) ;
rtliSetLogXSignalInfo ( ssGetRTWLogInfo ( rtS ) , & rt_LoggedStateSignalInfo
) ; rt_LoggedStateSignalPtrs [ 0 ] = ( void * ) & rtX . awoq5tf10b ;
rt_LoggedStateSignalPtrs [ 1 ] = ( void * ) & rtX . crhmgzcgl3 ; }
rtliSetLogT ( ssGetRTWLogInfo ( rtS ) , "tout" ) ; rtliSetLogX (
ssGetRTWLogInfo ( rtS ) , "" ) ; rtliSetLogXFinal ( ssGetRTWLogInfo ( rtS ) ,
"" ) ; rtliSetLogVarNameModifier ( ssGetRTWLogInfo ( rtS ) , "none" ) ;
rtliSetLogFormat ( ssGetRTWLogInfo ( rtS ) , 4 ) ; rtliSetLogMaxRows (
ssGetRTWLogInfo ( rtS ) , 0 ) ; rtliSetLogDecimation ( ssGetRTWLogInfo ( rtS
) , 1 ) ; rtliSetLogY ( ssGetRTWLogInfo ( rtS ) , "" ) ;
rtliSetLogYSignalInfo ( ssGetRTWLogInfo ( rtS ) , ( NULL ) ) ;
rtliSetLogYSignalPtrs ( ssGetRTWLogInfo ( rtS ) , ( NULL ) ) ; } { static
struct _ssStatesInfo2 statesInfo2 ; ssSetStatesInfo2 ( rtS , & statesInfo2 )
; } { static ssPeriodicStatesInfo periodicStatesInfo ;
ssSetPeriodicStatesInfo ( rtS , & periodicStatesInfo ) ; } { static
ssJacobianPerturbationBounds jacobianPerturbationBounds ;
ssSetJacobianPerturbationBounds ( rtS , & jacobianPerturbationBounds ) ; } {
static ssSolverInfo slvrInfo ; static boolean_T contStatesDisabled [ 2 ] ;
ssSetSolverInfo ( rtS , & slvrInfo ) ; ssSetSolverName ( rtS , "ode3" ) ;
ssSetVariableStepSolver ( rtS , 0 ) ; ssSetSolverConsistencyChecking ( rtS ,
0 ) ; ssSetSolverAdaptiveZcDetection ( rtS , 0 ) ;
ssSetSolverRobustResetMethod ( rtS , 0 ) ; ssSetSolverStateProjection ( rtS ,
0 ) ; ssSetSolverMassMatrixType ( rtS , ( ssMatrixType ) 0 ) ;
ssSetSolverMassMatrixNzMax ( rtS , 0 ) ; ssSetModelOutputs ( rtS , MdlOutputs
) ; ssSetModelLogData ( rtS , rt_UpdateTXYLogVars ) ;
ssSetModelLogDataIfInInterval ( rtS , rt_UpdateTXXFYLogVars ) ;
ssSetModelUpdate ( rtS , MdlUpdate ) ; ssSetModelDerivatives ( rtS ,
MdlDerivatives ) ; ssSetTNextTid ( rtS , INT_MIN ) ; ssSetTNext ( rtS ,
rtMinusInf ) ; ssSetSolverNeedsReset ( rtS ) ; ssSetNumNonsampledZCs ( rtS ,
0 ) ; ssSetContStateDisabled ( rtS , contStatesDisabled ) ; } { ZCSigState *
zc = ( ZCSigState * ) & rtPrevZCX ; ssSetPrevZCSigState ( rtS , zc ) ; } {
rtPrevZCX . p5axgerwfh = UNINITIALIZED_ZCSIG ; } ssSetChecksumVal ( rtS , 0 ,
859324911U ) ; ssSetChecksumVal ( rtS , 1 , 2769031156U ) ; ssSetChecksumVal
( rtS , 2 , 360706461U ) ; ssSetChecksumVal ( rtS , 3 , 3159082144U ) ; {
static const sysRanDType rtAlwaysEnabled = SUBSYS_RAN_BC_ENABLE ; static
RTWExtModeInfo rt_ExtModeInfo ; static const sysRanDType * systemRan [ 4 ] ;
gblRTWExtModeInfo = & rt_ExtModeInfo ; ssSetRTWExtModeInfo ( rtS , &
rt_ExtModeInfo ) ; rteiSetSubSystemActiveVectorAddresses ( & rt_ExtModeInfo ,
systemRan ) ; systemRan [ 0 ] = & rtAlwaysEnabled ; systemRan [ 1 ] = (
sysRanDType * ) & rtDW . irumfm1oxp ; systemRan [ 2 ] = & rtAlwaysEnabled ;
systemRan [ 3 ] = & rtAlwaysEnabled ; rteiSetModelMappingInfoPtr (
ssGetRTWExtModeInfo ( rtS ) , & ssGetModelMappingInfo ( rtS ) ) ;
rteiSetChecksumsPtr ( ssGetRTWExtModeInfo ( rtS ) , ssGetChecksums ( rtS ) )
; rteiSetTPtr ( ssGetRTWExtModeInfo ( rtS ) , ssGetTPtr ( rtS ) ) ; } rtP .
T_lim_low = rtMinusInf ; rtP . T_lim_up = rtInf ; return rtS ; }
#if defined(_MSC_VER)
#pragma optimize( "", on )
#endif
const int_T gblParameterTuningTid = 2 ; void MdlOutputsParameterSampleTime (
int_T tid ) { UNUSED_PARAMETER ( tid ) ; }
