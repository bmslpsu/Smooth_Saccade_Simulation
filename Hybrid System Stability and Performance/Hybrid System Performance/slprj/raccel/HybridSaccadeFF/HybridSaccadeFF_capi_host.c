#include "HybridSaccadeFF_capi_host.h"
static HybridSaccadeFF_host_DataMapInfo_T root;
static int initialized = 0;
__declspec( dllexport ) rtwCAPI_ModelMappingInfo *getRootMappingInfo()
{
    if (initialized == 0) {
        initialized = 1;
        HybridSaccadeFF_host_InitializeDataMapInfo(&(root), "HybridSaccadeFF");
    }
    return &root.mmi;
}

rtwCAPI_ModelMappingInfo *mexFunction() {return(getRootMappingInfo());}
