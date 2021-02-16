#include "rtw_capi.h"
#ifdef HOST_CAPI_BUILD
#include "HybridSaccadeFF_capi_host.h"
#define sizeof(s) ((size_t)(0xFFFF))
#undef rt_offsetof
#define rt_offsetof(s,el) ((uint16_T)(0xFFFF))
#define TARGET_CONST
#define TARGET_STRING(s) (s)    
#else
#include "builtin_typeid_types.h"
#include "HybridSaccadeFF.h"
#include "HybridSaccadeFF_capi.h"
#include "HybridSaccadeFF_private.h"
#ifdef LIGHT_WEIGHT_CAPI
#define TARGET_CONST                  
#define TARGET_STRING(s)               (NULL)                    
#else
#define TARGET_CONST                   const
#define TARGET_STRING(s)               (s)
#endif
#endif
static const rtwCAPI_Signals rtBlockSignals [ ] = { { 0 , 0 , TARGET_STRING (
"HybridSaccadeFF/From Workspace" ) , TARGET_STRING ( "" ) , 0 , 0 , 0 , 0 , 0
} , { 1 , 0 , TARGET_STRING ( "HybridSaccadeFF/Memory" ) , TARGET_STRING ( ""
) , 0 , 0 , 0 , 0 , 1 } , { 2 , 0 , TARGET_STRING (
"HybridSaccadeFF/Biological Torque limit" ) , TARGET_STRING ( "" ) , 0 , 0 ,
0 , 0 , 0 } , { 3 , 0 , TARGET_STRING ( "HybridSaccadeFF/Add" ) ,
TARGET_STRING ( "" ) , 0 , 0 , 0 , 0 , 0 } , { 4 , 0 , TARGET_STRING (
"HybridSaccadeFF/Sum" ) , TARGET_STRING ( "" ) , 0 , 0 , 0 , 0 , 0 } , { 5 ,
1 , TARGET_STRING ( "HybridSaccadeFF/Plant with reset/Enabled Subsystem" ) ,
TARGET_STRING ( "" ) , 0 , 0 , 0 , 0 , 0 } , { 6 , 0 , TARGET_STRING (
"HybridSaccadeFF/Saccade Logic and Memory Layer/Last Output" ) ,
TARGET_STRING ( "" ) , 0 , 0 , 0 , 0 , 1 } , { 7 , 0 , TARGET_STRING (
"HybridSaccadeFF/Saccade Logic and Memory Layer/Saccade Complete?" ) ,
TARGET_STRING ( "" ) , 0 , 0 , 0 , 0 , 0 } , { 8 , 0 , TARGET_STRING (
"HybridSaccadeFF/Smooth System/Integrator1" ) , TARGET_STRING ( "" ) , 0 , 0
, 0 , 0 , 0 } , { 9 , 0 , TARGET_STRING (
"HybridSaccadeFF/Supervisory \"Switching\" Layer/Logical Operator" ) ,
TARGET_STRING ( "" ) , 0 , 1 , 0 , 0 , 0 } , { 10 , 0 , TARGET_STRING (
"HybridSaccadeFF/Supervisory \"Switching\" Layer/Memory1" ) , TARGET_STRING (
"" ) , 0 , 0 , 0 , 0 , 1 } , { 11 , 0 , TARGET_STRING (
"HybridSaccadeFF/Supervisory \"Switching\" Layer/GreaterThan1" ) ,
TARGET_STRING ( "" ) , 0 , 1 , 0 , 0 , 0 } , { 12 , 0 , TARGET_STRING (
"HybridSaccadeFF/Supervisory \"Switching\" Layer/Switch" ) , TARGET_STRING (
"" ) , 0 , 0 , 0 , 0 , 0 } , { 13 , 0 , TARGET_STRING (
"HybridSaccadeFF/Supervisory \"Switching\" Layer/Switch1" ) , TARGET_STRING (
"" ) , 0 , 0 , 0 , 0 , 1 } , { 14 , 1 , TARGET_STRING (
 "HybridSaccadeFF/Plant with reset/Enabled Subsystem/Plant (torque to velocity)/Internal"
) , TARGET_STRING ( "" ) , 0 , 0 , 0 , 0 , 0 } , { 0 , 0 , ( NULL ) , ( NULL
) , 0 , 0 , 0 , 0 , 0 } } ; static const rtwCAPI_BlockParameters
rtBlockParameters [ ] = { { 15 , TARGET_STRING (
"HybridSaccadeFF/From Workspace" ) , TARGET_STRING ( "Time0" ) , 0 , 1 , 0 }
, { 16 , TARGET_STRING ( "HybridSaccadeFF/From Workspace" ) , TARGET_STRING (
"Data0" ) , 0 , 1 , 0 } , { 17 , TARGET_STRING ( "HybridSaccadeFF/Memory" ) ,
TARGET_STRING ( "InitialCondition" ) , 0 , 0 , 0 } , { 18 , TARGET_STRING (
"HybridSaccadeFF/Neurological Delay" ) , TARGET_STRING ( "InitialOutput" ) ,
0 , 0 , 0 } , { 19 , TARGET_STRING ( "HybridSaccadeFF/Saccade Execution time"
) , TARGET_STRING ( "InitialOutput" ) , 0 , 0 , 0 } , { 20 , TARGET_STRING (
"HybridSaccadeFF/Plant with reset/Constant" ) , TARGET_STRING ( "Value" ) , 0
, 0 , 0 } , { 21 , TARGET_STRING (
"HybridSaccadeFF/Saccade Logic and Memory Layer/Last Output" ) ,
TARGET_STRING ( "InitialCondition" ) , 0 , 0 , 0 } , { 22 , TARGET_STRING (
"HybridSaccadeFF/Smooth System/Constant" ) , TARGET_STRING ( "Value" ) , 0 ,
0 , 0 } , { 23 , TARGET_STRING ( "HybridSaccadeFF/Smooth System/Integrator1"
) , TARGET_STRING ( "InitialCondition" ) , 0 , 0 , 0 } , { 24 , TARGET_STRING
( "HybridSaccadeFF/Supervisory \"Switching\" Layer/Constant1" ) ,
TARGET_STRING ( "Value" ) , 0 , 0 , 0 } , { 25 , TARGET_STRING (
"HybridSaccadeFF/Supervisory \"Switching\" Layer/Constant2" ) , TARGET_STRING
( "Value" ) , 0 , 0 , 0 } , { 26 , TARGET_STRING (
"HybridSaccadeFF/Supervisory \"Switching\" Layer/Memory1" ) , TARGET_STRING (
"InitialCondition" ) , 0 , 0 , 0 } , { 27 , TARGET_STRING (
"HybridSaccadeFF/Supervisory \"Switching\" Layer/Memory2" ) , TARGET_STRING (
"InitialCondition" ) , 1 , 0 , 0 } , { 28 , TARGET_STRING (
"HybridSaccadeFF/Supervisory \"Switching\" Layer/Memory3" ) , TARGET_STRING (
"InitialCondition" ) , 1 , 0 , 0 } , { 29 , TARGET_STRING (
"HybridSaccadeFF/Plant with reset/Enabled Subsystem/Out1" ) , TARGET_STRING (
"InitialOutput" ) , 0 , 0 , 0 } , { 30 , TARGET_STRING (
 "HybridSaccadeFF/Plant with reset/Enabled Subsystem/Plant (torque to velocity)/Internal"
) , TARGET_STRING ( "B" ) , 0 , 0 , 0 } , { 31 , TARGET_STRING (
 "HybridSaccadeFF/Plant with reset/Enabled Subsystem/Plant (torque to velocity)/Internal"
) , TARGET_STRING ( "C" ) , 0 , 0 , 0 } , { 32 , TARGET_STRING (
 "HybridSaccadeFF/Plant with reset/Enabled Subsystem/Plant (torque to velocity)/Internal"
) , TARGET_STRING ( "InitialCondition" ) , 0 , 0 , 0 } , { 0 , ( NULL ) , (
NULL ) , 0 , 0 , 0 } } ; static const rtwCAPI_ModelParameters
rtModelParameters [ ] = { { 33 , TARGET_STRING ( "K_I" ) , 0 , 0 , 0 } , { 34
, TARGET_STRING ( "K_P" ) , 0 , 0 , 0 } , { 35 , TARGET_STRING ( "T_lim_low"
) , 0 , 0 , 0 } , { 36 , TARGET_STRING ( "T_lim_up" ) , 0 , 0 , 0 } , { 37 ,
TARGET_STRING ( "n_delay" ) , 0 , 0 , 0 } , { 38 , TARGET_STRING ( "sac_time"
) , 0 , 0 , 0 } , { 39 , TARGET_STRING ( "switch_thresh" ) , 0 , 0 , 0 } , {
0 , ( NULL ) , 0 , 0 , 0 } } ;
#ifndef HOST_CAPI_BUILD
static void * rtDataAddrMap [ ] = { & rtB . gdj3m1nfho , & rtB . gaba2pigju ,
& rtB . nflkjfkiic , & rtB . hlhz4puca1 , & rtB . fj53apf4xs , & rtB .
npca3gyxjj , & rtB . e35j4h45yz , & rtB . ng1zasawwk , & rtB . ccv0nxufjm , &
rtB . b2dt5rhhow , & rtB . hnga2lbxre , & rtB . hz4uiyeou1 , & rtB .
bydpu1oymy , & rtB . jktyvjmrgo , & rtB . npca3gyxjj , & rtP .
FromWorkspace_Time0 [ 0 ] , & rtP . FromWorkspace_Data0 [ 0 ] , & rtP .
Memory_InitialCondition , & rtP . NeurologicalDelay_InitOutput , & rtP .
SaccadeExecutiontime_InitOutput , & rtP . Constant_Value , & rtP .
LastOutput_InitialCondition , & rtP . Constant_Value_dlokgks1d5 , & rtP .
Integrator1_IC , & rtP . Constant1_Value , & rtP . Constant2_Value , & rtP .
Memory1_InitialCondition , & rtP . Memory2_InitialCondition , & rtP .
Memory3_InitialCondition , & rtP . Out1_Y0 , & rtP . Internal_B , & rtP .
Internal_C , & rtP . Internal_InitialCondition , & rtP . K_I , & rtP . K_P ,
& rtP . T_lim_low , & rtP . T_lim_up , & rtP . n_delay , & rtP . sac_time , &
rtP . switch_thresh , } ; static int32_T * rtVarDimsAddrMap [ ] = { ( NULL )
} ;
#endif
static TARGET_CONST rtwCAPI_DataTypeMap rtDataTypeMap [ ] = { { "double" ,
"real_T" , 0 , 0 , sizeof ( real_T ) , SS_DOUBLE , 0 , 0 , 0 } , {
"unsigned char" , "boolean_T" , 0 , 0 , sizeof ( boolean_T ) , SS_BOOLEAN , 0
, 0 , 0 } } ;
#ifdef HOST_CAPI_BUILD
#undef sizeof
#endif
static TARGET_CONST rtwCAPI_ElementMap rtElementMap [ ] = { { ( NULL ) , 0 ,
0 , 0 , 0 } , } ; static const rtwCAPI_DimensionMap rtDimensionMap [ ] = { {
rtwCAPI_SCALAR , 0 , 2 , 0 } , { rtwCAPI_VECTOR , 2 , 2 , 0 } } ; static
const uint_T rtDimensionArray [ ] = { 1 , 1 , 2001 , 1 } ; static const
real_T rtcapiStoredFloats [ ] = { 0.0 , 0.005 } ; static const
rtwCAPI_FixPtMap rtFixPtMap [ ] = { { ( NULL ) , ( NULL ) ,
rtwCAPI_FIX_RESERVED , 0 , 0 , 0 } , } ; static const rtwCAPI_SampleTimeMap
rtSampleTimeMap [ ] = { { ( const void * ) & rtcapiStoredFloats [ 0 ] , (
const void * ) & rtcapiStoredFloats [ 0 ] , 0 , 0 } , { ( const void * ) &
rtcapiStoredFloats [ 1 ] , ( const void * ) & rtcapiStoredFloats [ 0 ] , 1 ,
0 } } ; static rtwCAPI_ModelMappingStaticInfo mmiStatic = { { rtBlockSignals
, 15 , ( NULL ) , 0 , ( NULL ) , 0 } , { rtBlockParameters , 18 ,
rtModelParameters , 7 } , { ( NULL ) , 0 } , { rtDataTypeMap , rtDimensionMap
, rtFixPtMap , rtElementMap , rtSampleTimeMap , rtDimensionArray } , "float"
, { 859324911U , 2769031156U , 360706461U , 3159082144U } , ( NULL ) , 0 , 0
} ; const rtwCAPI_ModelMappingStaticInfo * HybridSaccadeFF_GetCAPIStaticMap (
void ) { return & mmiStatic ; }
#ifndef HOST_CAPI_BUILD
void HybridSaccadeFF_InitializeDataMapInfo ( void ) { rtwCAPI_SetVersion ( (
* rt_dataMapInfoPtr ) . mmi , 1 ) ; rtwCAPI_SetStaticMap ( ( *
rt_dataMapInfoPtr ) . mmi , & mmiStatic ) ; rtwCAPI_SetLoggingStaticMap ( ( *
rt_dataMapInfoPtr ) . mmi , ( NULL ) ) ; rtwCAPI_SetDataAddressMap ( ( *
rt_dataMapInfoPtr ) . mmi , rtDataAddrMap ) ; rtwCAPI_SetVarDimsAddressMap (
( * rt_dataMapInfoPtr ) . mmi , rtVarDimsAddrMap ) ;
rtwCAPI_SetInstanceLoggingInfo ( ( * rt_dataMapInfoPtr ) . mmi , ( NULL ) ) ;
rtwCAPI_SetChildMMIArray ( ( * rt_dataMapInfoPtr ) . mmi , ( NULL ) ) ;
rtwCAPI_SetChildMMIArrayLen ( ( * rt_dataMapInfoPtr ) . mmi , 0 ) ; }
#else
#ifdef __cplusplus
extern "C" {
#endif
void HybridSaccadeFF_host_InitializeDataMapInfo (
HybridSaccadeFF_host_DataMapInfo_T * dataMap , const char * path ) {
rtwCAPI_SetVersion ( dataMap -> mmi , 1 ) ; rtwCAPI_SetStaticMap ( dataMap ->
mmi , & mmiStatic ) ; rtwCAPI_SetDataAddressMap ( dataMap -> mmi , NULL ) ;
rtwCAPI_SetVarDimsAddressMap ( dataMap -> mmi , NULL ) ; rtwCAPI_SetPath (
dataMap -> mmi , path ) ; rtwCAPI_SetFullPath ( dataMap -> mmi , NULL ) ;
rtwCAPI_SetChildMMIArray ( dataMap -> mmi , ( NULL ) ) ;
rtwCAPI_SetChildMMIArrayLen ( dataMap -> mmi , 0 ) ; }
#ifdef __cplusplus
}
#endif
#endif
