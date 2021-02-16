#ifndef RTW_HEADER_HybridSaccadeFF_acc_h_
#define RTW_HEADER_HybridSaccadeFF_acc_h_
#include <stddef.h>
#include <float.h>
#ifndef HybridSaccadeFF_acc_COMMON_INCLUDES_
#define HybridSaccadeFF_acc_COMMON_INCLUDES_
#include <stdlib.h>
#define S_FUNCTION_NAME simulink_only_sfcn 
#define S_FUNCTION_LEVEL 2
#define RTW_GENERATED_S_FUNCTION
#include "rtwtypes.h"
#include "simstruc.h"
#include "fixedpoint.h"
#endif
#include "HybridSaccadeFF_acc_types.h"
#include "multiword_types.h"
#include "mwmathutil.h"
#include "rtGetInf.h"
#include "rt_defines.h"
#include "rt_nonfinite.h"
typedef struct { real_T B_3_4_0 ; real_T B_3_6_0 ; real_T B_3_9_0 ; real_T
B_3_10_0 ; real_T B_3_11_0 ; real_T B_3_16_0 ; real_T B_3_19_0 ; real_T
B_3_21_0 ; real_T B_3_25_0 ; real_T B_3_28_0 ; real_T B_3_31_0 ; real_T
B_3_0_0 ; real_T B_3_1_0 ; real_T B_3_2_0 ; real_T B_3_3_0 ; real_T B_3_4_0_m
; real_T B_0_0_0 ; boolean_T B_3_5_0 ; boolean_T B_3_14_0 ; boolean_T
B_3_22_0 ; char_T pad_B_3_22_0 [ 5 ] ; } B_HybridSaccadeFF_T ; typedef struct
{ real_T Memory1_PreviousInput ; real_T Memory_PreviousInput ; real_T
LastOutput_PreviousInput ; struct { real_T modelTStart ; }
SaccadeExecutiontime_RWORK ; struct { real_T modelTStart ; }
NeurologicalDelay_RWORK ; void * ToWorkspace1_PWORK ; struct { void *
TUbufferPtrs [ 2 ] ; } SaccadeExecutiontime_PWORK ; void *
FromWorkspace_PWORK [ 3 ] ; void * ToWorkspace2_PWORK ; struct { void *
TUbufferPtrs [ 2 ] ; } NeurologicalDelay_PWORK ; int32_T
TmpAtomicSubsysAtSwitchInport3_sysIdxToRun ; int32_T
TmpAtomicSubsysAtSaccadeCompleteInport3_sysIdxToRun ; int32_T
EnabledSubsystem_sysIdxToRun ; struct { int_T Tail ; int_T Head ; int_T Last
; int_T CircularBufSize ; int_T MaxNewBufSize ; } SaccadeExecutiontime_IWORK
; int_T FromWorkspace_IWORK ; struct { int_T Tail ; int_T Head ; int_T Last ;
int_T CircularBufSize ; int_T MaxNewBufSize ; } NeurologicalDelay_IWORK ;
int8_T EnabledSubsystem_SubsysRanBC ; boolean_T Memory3_PreviousInput ;
boolean_T Memory2_PreviousInput ; boolean_T EnabledSubsystem_MODE ; char_T
pad_EnabledSubsystem_MODE [ 4 ] ; } DW_HybridSaccadeFF_T ; typedef struct {
real_T Integrator1_CSTATE ; real_T Internal_CSTATE ; } X_HybridSaccadeFF_T ;
typedef struct { real_T Integrator1_CSTATE ; real_T Internal_CSTATE ; }
XDot_HybridSaccadeFF_T ; typedef struct { boolean_T Integrator1_CSTATE ;
boolean_T Internal_CSTATE ; } XDis_HybridSaccadeFF_T ; typedef struct {
ZCSigState Integrator1_Reset_ZCE ; } PrevZCX_HybridSaccadeFF_T ; struct
P_HybridSaccadeFF_T_ { real_T P_0 ; real_T P_1 ; real_T P_2 ; real_T P_3 ;
real_T P_4 ; real_T P_5 ; real_T P_6 ; real_T P_7 ; real_T P_8 ; real_T P_9 ;
real_T P_10 ; real_T P_11 ; real_T P_12 ; real_T P_13 ; real_T P_14 ; real_T
P_15 ; real_T P_16 ; real_T P_17 ; real_T P_18 ; real_T P_19 ; real_T P_20 ;
boolean_T P_21 ; boolean_T P_22 ; char_T pad_P_22 [ 6 ] ; } ; extern
P_HybridSaccadeFF_T HybridSaccadeFF_rtDefaultP ;
#endif
