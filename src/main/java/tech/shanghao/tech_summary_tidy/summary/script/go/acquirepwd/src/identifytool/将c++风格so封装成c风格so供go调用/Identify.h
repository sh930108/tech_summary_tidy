/** @file   Identify.h
 *  @brief  �����м����ƽϵ�� �㷨���ܿ�SDK�ĺ����ӿ�����
 *
 *  @author   yuanhuan1
 *  @date     2017/03/16
 *  
 *  @note     ��ʷ��¼: V1.0.0
 *  @note   
 *
 *  @warning  
 */

#ifndef __Identify_H__
#define __Identify_H__
#include "Identify_define.h"

#if (defined(_WIN32) || defined(_WIN64))
#ifdef IDENTIFY_EXPORTS
    #define IDENTIFY_EXTERN    __declspec(dllexport)
#else
    #define IDENTIFY_EXTERN    __declspec(dllimport)
#endif /* DENTIFY_EXPORTS */
#define IDENTIFY_API __stdcall
#elif defined(__linux__)
    #define IDENTIFY_API
    #define IDENTIFY_EXTERN    __attribute__ ((visibility("default")))
#else
	#define IDENTIFY_API
	#define IDENTIFY_EXTERN
#endif /* (defined(_WIN32) || defined(_WIN64) */

#ifdef __cplusplus
extern "C" {
#endif  /* __cplusplus */

    /***************************************     ���ʼ���ӿ� begin       ***************************************/
    /** @fn       IDENTIFY_EXTERN int IDENTIFY_API Identify_Init()
    *   @brief    <��ʼ���ӿ�,֧�ֶ�γ�ʼ��>
    *   @return   �ɹ�ʱ����IDENTIFY_E_OK; ʧ��ʱ���ش�����.
    */
    IDENTIFY_EXTERN int IDENTIFY_API Identify_Init();

    /** @fn       IDENTIFY_EXTERN int IDENTIFY_API Identify_Fini()
    *   @brief    <����ʼ���ӿ�>
    *   @return   �ɹ�ʱ����IDENTIFY_E_OK; ʧ��ʱ���ش�����.
    */
    IDENTIFY_EXTERN int IDENTIFY_API Identify_Fini();
	/***************************************     ���ʼ���ӿ� end        ***************************************/


	/***************************************    ҵ��ӿ� begin   ****************************************/
 

    /** @fn       IDENTIFY_EXTERN int IDENTIFY_API Identify_Item(char* szOutData,int& nOutDataLen)
    *   @brief    <��������Կ>   V1.0�汾����16/32�ֽڸ���Կ
    *   @param    <szOutData    (OUT)����Կ��Ϣ���˸���Կ�����豸����������Կ�����������ڲ����ܴ��ڲ��ɼ��ַ��ʹ�������>
	*   @param    <nOutDataLen  (IN/OUT)��IN--szOutData�ڴ��С��OUT--szOutDataʵ�ʴ�С(ʵ�ʴ�СΪ16/32�ֽ�,AES128����ԿΪ16�ֽ�,AES256����Կλ32�ֽ�)> 
    *   @return   �ɹ�[IDENTIFY_E_OK]/������
    */
	IDENTIFY_EXTERN int IDENTIFY_API Identify_Item(char* szOutData, int& nOutDataLen);

	/** @fn       IDENTIFY_EXTERN int IDENTIFY_API Identify_Edit(const pRegCfgInfo pData)
    *   @brief    <дע���>
    *   @param    <pData    (IN)��д��ע������Ϣ>
    *   @return   �ɹ�[IDENTIFY_E_OK]/������
    */
	IDENTIFY_EXTERN int IDENTIFY_API Identify_Edit(const pRegCfgInfo pData);

	/** @fn       IDENTIFY_EXTERN int IDENTIFY_API Identify_Read(pRegCfgInfo pData)
    *   @brief    <��ע���> 
    *   @param    <pData    (OUT)������ע������Ϣ>
    *   @return   �ɹ�[IDENTIFY_E_OK]/������
    */
	IDENTIFY_EXTERN int IDENTIFY_API Identify_Read(pRegCfgInfo pData);

	/** @fn       IDENTIFY_EXTERN int IDENTIFY_API Identify_Apply(const char* szInput,int nInputLen,char* szIdentifyData, int& iIdentifyDataLen);
	*   @brief    <�������>�ڲ����طŹ�����⣬��Identify_Check����ʹ��
	*   @param    <szInput  (IN)Ӧ�ò����ݣ���Ӧ�ò����ݴ۸���ƣ���ΪNULL>
	*   @param    <nInputLen  (IN)szInput�ĳ��ȣ�szInputΪNULLʱ����Ϊ0��szInput��ΪNULLʱ��ΪszInput��ʵ�ʳ���>
    *   @param    <szIdentifyData  (OUT)�����Ϣ���ڲ����ܴ��ڲ��ɼ��ַ��ʹ�������>
	*   @param    <iIdentifyDataLen  (IN/OUT)��IN--�����ϢszIdentifyData�ڴ��С��OUT--�����ϢszIdentifyDataʵ�ʴ�С> V1.0�汾������Ҫ��szIdentifyData�ڴ��С��ԼΪ��8+32+64�ֽ�
    *   @return   �ɹ�ʱ����IDENTIFY_E_OK; ʧ��ʱ���ش�����.
    */
    IDENTIFY_EXTERN int IDENTIFY_API Identify_Apply(const char* szInput, int nInputLen, char* szIdentifyData, int& iIdentifyDataLen);

    /** @fn       IDENTIFY_EXTERN int IDENTIFY_API Identify_Check (const char* szInput,int nInputLen,const char* szIdentifyData, int iIdentifyDataLen)
    *   @brief    <��֤���>
	*   @param    <szInput  (IN)Ӧ�ò����ݣ���Ӧ�ò����ݴ۸���ƣ���ΪNULL>
	*   @param    <nInputLen  (IN)szInput�ĳ��ȣ�szInputΪNULLʱ����Ϊ0��szInput��ΪNULLʱ��ΪszInput��ʵ�ʳ���>
    *   @param    <szIdentifyData    (IN)�����Ϣ��ΪIdentify_Apply�ӿڷ��صĲ���3���ڲ����ܴ��ڲ��ɼ��ַ��ʹ�������>
	*   @param    <iIdentifyDataLen  (IN)�����Ϣʵ�ʳ��ȣ�ΪIdentify_Apply�ӿڷ��صĲ���4>
    *   @return   �ɹ�ʱ����IDENTIFY_E_OK; ʧ��ʱ���ش�����.
    */
    IDENTIFY_EXTERN int IDENTIFY_API Identify_Check(const char* szInput, int nInputLen, const char* szIdentifyData, int iIdentifyDataLen);

	/** @fn       IDENTIFY_EXTERN int IDENTIFY_API Identify_ApplyEx(const char* szInput,int nInputLen,char* szIdentifyData, int& iIdentifyDataLen);
	*   @brief    <�������>�ڲ������طŹ�������Identify_CheckEx����ʹ��
	*   @param    <szInput  (IN)Ӧ�ò����ݣ���Ӧ�ò����ݴ۸���ƣ���ΪNULL>
	*   @param    <nInputLen  (IN)szInput�ĳ��ȣ�szInputΪNULLʱ����Ϊ0��szInput��ΪNULLʱ��ΪszInput��ʵ�ʳ���>
    *   @param    <szIdentifyData  (OUT)�����Ϣ���ڲ����ܴ��ڲ��ɼ��ַ��ʹ�������>
	*   @param    <iIdentifyDataLen  (IN/OUT)��IN--�����ϢszIdentifyData�ڴ��С��OUT--�����ϢszIdentifyDataʵ�ʴ�С> V1.1�汾������Ҫ��szIdentifyData�ڴ��С��ԼΪ��8+32+64+13�ֽ�
    *   @return   �ɹ�ʱ����IDENTIFY_E_OK; ʧ��ʱ���ش�����.
    */
    IDENTIFY_EXTERN int IDENTIFY_API Identify_ApplyEx(const char* szInput, int nInputLen, char* szIdentifyData, int& iIdentifyDataLen);

    /** @fn       IDENTIFY_EXTERN int IDENTIFY_API Identify_CheckEx (const char* szInput,int nInputLen,int nExpireTime,const char* szIdentifyData, int iIdentifyDataLen)
    *   @brief    <��֤���>
	*   @param    <szInput  (IN)Ӧ�ò����ݣ���Ӧ�ò����ݴ۸���ƣ���ΪNULL>
	*   @param    <nInputLen  (IN)szInput�ĳ��ȣ�szInputΪNULLʱ����Ϊ0��szInput��ΪNULLʱ��ΪszInput��ʵ�ʳ���>
	*   @param    <nExpireTime  (IN)Token����ʱ�䣬��λ��>
    *   @param    <szIdentifyData    (IN)�����Ϣ��ΪIdentify_ApplyEx�ӿڷ��صĲ���3���ڲ����ܴ��ڲ��ɼ��ַ��ʹ�������>
	*   @param    <iIdentifyDataLen  (IN)�����Ϣʵ�ʳ��ȣ�ΪIdentify_ApplyEx�ӿڷ��صĲ���4>
    *   @return   �ɹ�ʱ����IDENTIFY_E_OK; ʧ��ʱ���ش�����.
    */
    IDENTIFY_EXTERN int IDENTIFY_API Identify_CheckEx(const char* szInput, int nInputLen, int nExpireTime, const char* szIdentifyData, int iIdentifyDataLen);

    /** @fn  IDENTIFY_EXTERN int IDENTIFY_API Identify_DecryptData(const char* szSrc, int iSrcLen, char* szDst, int& iDstLen)
     *  @brief ����������Ϣ
     *  @param szSrc[in] ������Ϣ���� 
     *  @param iSrcLen[in] �������ĳ���
     *  @param szDst[in] ������Ϣ����
     *  @param iDstLen[in] ������Ϣ���ĳ���
     *  @return �ɹ�ʱ����IDENTIFY_E_OK; ʧ��ʱ���ش�����.
     */
    IDENTIFY_EXTERN int IDENTIFY_API Identify_DecryptData(const char* szSrc, int iSrcLen, char* szDst, int& iDstLen);

    /** @fn  IDENTIFY_EXTERN int IDENTIFY_API Identify_EncryptData(const char* szSrc, int iSrcLen, char* szDst, int& iDstLen)
     *  @brief ����������Ϣ
     *  @param szSrc[in] ������Ϣ����
     *  @param iSrcLen[in] �������ĳ���
     *  @param szDst[in] ������Ϣ����
     *  @param iDstLen[in] �������ĳ���
     *  @return �ɹ�ʱ����IDENTIFY_E_OK; ʧ��ʱ���ش�����.
     */
    IDENTIFY_EXTERN int IDENTIFY_API Identify_EncryptData(const char* szSrc, int iSrcLen, char* szDst, int& iDstLen);


    /***************************************    ҵ��ӿ� end   ****************************************/
 
#ifdef __cplusplus
}
#endif  /* __cplusplus */

#endif /* __Identify_H__ */

