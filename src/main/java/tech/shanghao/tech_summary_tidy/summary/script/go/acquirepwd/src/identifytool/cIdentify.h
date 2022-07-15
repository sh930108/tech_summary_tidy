
#ifndef CIDENTIFY_H_
#define CIDENTIFY_H_

#ifdef __cplusplus
extern "C" {
#endif

#if (defined(_WIN32) || defined(_WIN64))
#define C_IDENTIFY_API    __declspec(dllexport)
#else
#define C_IDENTIFY_API    extern
#endif

C_IDENTIFY_API int CIdentify_Init();
C_IDENTIFY_API int CIdentify_Fini();
C_IDENTIFY_API int CIdentify_Apply(const char* szInput, int nInputLen, char* szIdentifyData, int *iIdentifyDataLen);
C_IDENTIFY_API int CIdentify_Check(const char* szInput, int nInputLen, const char* szIdentifyData, int iIdentifyDataLen);
C_IDENTIFY_API int CIdentify_ApplyEx(const char* szInput, int nInputLen, char* szIdentifyData, int *iIdentifyDataLen);
C_IDENTIFY_API int CIdentify_CheckEx(const char* szInput, int nInputLen, int nExpireTime, const char* szIdentifyData, int iIdentifyDataLen);
C_IDENTIFY_API int CIdentify_DecryptData(const char* szSrc, int iSrcLen, char* szDst, int *iDstLen);
C_IDENTIFY_API int CIdentify_EncryptData(const char* szSrc, int iSrcLen, char* szDst, int *iDstLen);


#ifdef __cplusplus
}
#endif


#endif