#include "cIdentify.h"
#include "Identify.h"
#include "stdio.h"

C_IDENTIFY_API int CIdentify_Init()
{
    return Identify_Init();
}
C_IDENTIFY_API int CIdentify_Fini()
{
    return Identify_Fini();
}
C_IDENTIFY_API int CIdentify_Apply(const char* szInput, int nInputLen, char* szIdentifyData, int *iIdentifyDataLen)
{
    int temp = 0;
    int* i = iIdentifyDataLen?iIdentifyDataLen : &temp;
    return Identify_Apply(szInput, nInputLen, szIdentifyData, *i);
}
C_IDENTIFY_API int CIdentify_Check(const char* szInput, int nInputLen, const char* szIdentifyData, int iIdentifyDataLen)
{
    return Identify_Check(szInput, nInputLen, szIdentifyData, iIdentifyDataLen);
}
C_IDENTIFY_API int CIdentify_ApplyEx(const char* szInput, int nInputLen, char* szIdentifyData, int *iIdentifyDataLen)
{
    int temp = 0;
    int* i = iIdentifyDataLen?iIdentifyDataLen : &temp;	
    return Identify_ApplyEx(szInput, nInputLen, szIdentifyData, *i);
}
C_IDENTIFY_API int CIdentify_CheckEx(const char* szInput, int nInputLen, int nExpireTime, const char* szIdentifyData, int iIdentifyDataLen)
{
    return Identify_CheckEx(szInput, nInputLen, nExpireTime, szIdentifyData, iIdentifyDataLen);
}
C_IDENTIFY_API int CIdentify_DecryptData(const char* szSrc, int iSrcLen, char* szDst, int *iDstLen)
{
    int temp = 0;
    int* i = iDstLen?iDstLen : &temp;
    return Identify_DecryptData(szSrc, iSrcLen, szDst, *i);
}
C_IDENTIFY_API int CIdentify_EncryptData(const char* szSrc, int iSrcLen, char* szDst, int *iDstLen)
{
    int temp = 0;
    int * i = iDstLen?iDstLen : &temp;
    return Identify_EncryptData(szSrc, iSrcLen, szDst, *i);
}
