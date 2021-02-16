#ifndef RTW_HEADER_HybridSaccadeFF_h_
#define RTW_HEADER_HybridSaccadeFF_h_
#include <stddef.h>
#include <float.h>
#include <string.h>
#include "rtw_modelmap.h"
#ifndef HybridSaccadeFF_COMMON_INCLUDES_
#define HybridSaccadeFF_COMMON_INCLUDES_
#include <stdlib.h>
#include "rtwtypes.h"
#include "simtarget/slSimTgtSigstreamRTW.h"
#include "simtarget/slSimTgtSlioCoreRTW.h"
#include "simtarget/slSimTgtSlioClientsRTW.h"
#include "simtarget/slSimTgtSlioSdiRTW.h"
#include "sigstream_rtw.h"
#include "simstruc.h"
#include "fixedpoint.h"
#include "raccel.h"
#include "slsv_diagnostic_codegen_c_api.h"
#include "rt_logging.h"
#include "dt_info.h"
#include "ext_work.h"
#endif
#include "HybridSaccadeFF_types.h"
#include "multiword_types.h"
#include "mwmathutil.h"
#include "rtGetInf.h"
#include "rt_defines.h"
#include "rt_nonfinite.h"
#define MODEL_NAME HybridSaccadeFF
#define NSAMPLE_TIMES (3) 
#define NINPUTS (0)       
#define NOUTPUTS (0)     
#define NBLOCKIO (15) 
#define NUM_ZC_EVENTS (1) 
#ifndef NCSTATES
#define NCSTATES (2)   
#elif NCSTATES != 2
#error Invalid specification of NCSTATES defined in compiler command
#endif
#ifndef rtmGetDataMapInfo
#define rtmGetDataMapInfo(rtm) (*rt_dataMapInfoPtr)
#endif
#ifndef rtmSetDataMapInfo
#define rtmSetDataMapInfo(rtm, val) (rt_dataMapInfoPtr = &val)
#endif
#ifndef IN_RACCEL_MAIN
#endif
typedef struct { real_T jktyvjmrgo ; real_T ccv0nxufjm ; real_T gdj3m1nfho ;
real_T hnga2lbxre ; real_T bydpu1oymy ; real_T gaba2pigju ; real_T e35j4h45yz
; real_T ng1zasawwk ; real_T hlhz4puca1 ; real_T fj53apf4xs ; real_T
nflkjfkiic ; real_T npca3gyxjj ; boolean_T b2dt5rhhow ; boolean_T hz4uiyeou1
; } B ; typedef struct { real_T l54phutyhz ; real_T jpe5cwfb50 ; real_T
lhrsky5wel ; struct { real_T modelTStart ; } f1zzk0jlgh ; struct { real_T
modelTStart ; } hsryzgdvch ; struct { void * LoggedData ; } hsi2bse4xr ;
struct { void * TUbufferPtrs [ 2 ] ; } jzkzl30hxw ; struct { void * TimePtr ;
void * DataPtr ; void * RSimInfoPtr ; } apnnhgulim ; struct { void *
LoggedData ; } bewaxyjsxf ; struct { void * TUbufferPtrs [ 2 ] ; } okmhtyxt54
; struct { int_T Tail ; int_T Head ; int_T Last ; int_T CircularBufSize ;
int_T MaxNewBufSize ; } dqh0z5crxa ; struct { int_T PrevIndex ; } h2xjgzuuat
; struct { int_T Tail ; int_T Head ; int_T Last ; int_T CircularBufSize ;
int_T MaxNewBufSize ; } j5oxfm5lji ; int8_T irumfm1oxp ; boolean_T cxuxej1fem
; boolean_T fqyklb41f5 ; boolean_T c2h2rz5b30 ; } DW ; typedef struct {
real_T awoq5tf10b ; real_T crhmgzcgl3 ; } X ; typedef struct { real_T
awoq5tf10b ; real_T crhmgzcgl3 ; } XDot ; typedef struct { boolean_T
awoq5tf10b ; boolean_T crhmgzcgl3 ; } XDis ; typedef struct { ZCSigState
p5axgerwfh ; } PrevZCX ; typedef struct { rtwCAPI_ModelMappingInfo mmi ; }
DataMapInfo ; struct P_ { real_T K_I ; real_T K_P ; real_T T_lim_low ; real_T
T_lim_up ; real_T n_delay ; real_T sac_time ; real_T switch_thresh ; real_T
Out1_Y0 ; real_T Internal_B ; real_T Internal_C ; real_T
Internal_InitialCondition ; real_T Integrator1_IC ; real_T
SaccadeExecutiontime_InitOutput ; real_T FromWorkspace_Time0 [ 2001 ] ;
real_T FromWorkspace_Data0 [ 2001 ] ; real_T Memory1_InitialCondition ;
real_T Memory_InitialCondition ; real_T LastOutput_InitialCondition ; real_T
NeurologicalDelay_InitOutput ; real_T Constant_Value ; real_T
Constant_Value_dlokgks1d5 ; real_T Constant1_Value ; real_T Constant2_Value ;
boolean_T Memory3_InitialCondition ; boolean_T Memory2_InitialCondition ; } ;
extern const char * RT_MEMORY_ALLOCATION_ERROR ; extern B rtB ; extern X rtX
; extern DW rtDW ; extern PrevZCX rtPrevZCX ; extern P rtP ; extern const
rtwCAPI_ModelMappingStaticInfo * HybridSaccadeFF_GetCAPIStaticMap ( void ) ;
extern SimStruct * const rtS ; extern const int_T gblNumToFiles ; extern
const int_T gblNumFrFiles ; extern const int_T gblNumFrWksBlocks ; extern
rtInportTUtable * gblInportTUtables ; extern const char * gblInportFileName ;
extern const int_T gblNumRootInportBlks ; extern const int_T
gblNumModelInputs ; extern const int_T gblInportDataTypeIdx [ ] ; extern
const int_T gblInportDims [ ] ; extern const int_T gblInportComplex [ ] ;
extern const int_T gblInportInterpoFlag [ ] ; extern const int_T
gblInportContinuous [ ] ; extern const int_T gblParameterTuningTid ; extern
DataMapInfo * rt_dataMapInfoPtr ; extern rtwCAPI_ModelMappingInfo *
rt_modelMapInfoPtr ; void MdlOutputs ( int_T tid ) ; void
MdlOutputsParameterSampleTime ( int_T tid ) ; void MdlUpdate ( int_T tid ) ;
void MdlTerminate ( void ) ; void MdlInitializeSizes ( void ) ; void
MdlInitializeSampleTimes ( void ) ; SimStruct * raccel_register_model ( void
) ;
#endif
