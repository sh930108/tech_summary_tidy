// +build linux

//Package identifytool go对Identify.so功能的包裹,提供加解密、token获取校验功能
package identifytool

/*
#cgo linux CFLAGS: -I ${SRCDIR}/
#cgo linux LDFLAGS: -Wl,-rpath=./ -L${SRCDIR}/ -lcIdentify
#include "cIdentify.h"
*/
import "C"
import "customlog"
import "unsafe"
import "encoding/base64"
import "strconv"

//IdentifyInit 身份认证库初始化
func IdentifyInit() int {
	ret := C.CIdentify_Init()
        if ret < 0 {
            customlog.PrintErrorLog("Identify_Init Fail ErrorCode: 0x" + getErrorCodeStr(int(ret)))
	}
	return int(ret)
}

//IdentifyFini 身份认证库反初始化
func IdentifyFini() int {
	ret := C.CIdentify_Fini()
        if ret < 0 {
            customlog.PrintErrorLog("Identify_Fini Fail ErrorCode: 0x" + getErrorCodeStr(int(ret)))
	}
	return int(ret)
}

//IdentifyApply 不带时间戳Token获取
func IdentifyApply(data []byte, dataLen int) ([]byte, int) {
	nSize := 1024
	buf := make([]byte, nSize)
	nBytesRead := nSize

	pData := (*C.char)(nil)
	DataLen := (C.int)(dataLen)
	if dataLen > 0 {
		pData = (*C.char)(unsafe.Pointer(&data[0]))
	}

	pResult := (*C.char)(unsafe.Pointer(&buf[0]))
	pResult_len := (*C.int)(unsafe.Pointer(&nBytesRead))

	ret := C.CIdentify_Apply(pData, DataLen, pResult, pResult_len)
	if ret < 0 {
            customlog.PrintErrorLog("Identify_Apply Fail ErrorCode:0x"+getErrorCodeStr(int(ret)))
	    return buf, 0
	}
        
	return buf, nBytesRead
}

//IdentifyCheck 不带时间戳Token验证
func IdentifyCheck(data []byte, dataLen int, buf []byte, nSize int) int {

	if nSize <= 0 {
		return -1
	}

	pData := (*C.char)(nil)
	DataLen := (C.int)(dataLen)
	if dataLen > 0 {
		pData = (*C.char)(unsafe.Pointer(&data[0]))
	}

	pResult := (*C.char)(unsafe.Pointer(&buf[0]))
	result_len := (C.int)(nSize)

	ret := C.CIdentify_Check(pData, DataLen, pResult, result_len)
        if ret < 0 {
            customlog.PrintErrorLog("Identify_Check Fail ErrorCode: 0x" + getErrorCodeStr(int(ret)))
	}
	return int(ret)
}

//IdentifyApplybase64 base64加密后不带时间戳Token
func IdentifyApplybase64(data []byte, dataLen int) (base64Str string) {
	token_data, token_dataLen := IdentifyApply(data, dataLen)
	if token_dataLen <= 0 {
		return ""
	}
	return base64.StdEncoding.EncodeToString(token_data[0:token_dataLen])
}

//IdentifyCheckbase64 base64解密后不带时间戳Token验证
func IdentifyCheckbase64(data []byte, dataLen int, base64Str string) int {
	if len(base64Str) <= 0 {
		return -1
	}

	token_data, err := base64.StdEncoding.DecodeString(base64Str)
	if err != nil {
		return -1
	}
	return IdentifyCheck(data, dataLen, token_data, len(token_data))
}

//IdentifyApplyEx 带时间戳Token获取
func IdentifyApplyEx(data []byte, dataLen int) ([]byte, int) {

	nSize := 1024
	buf := make([]byte, nSize)

	nBytesRead := nSize

	pData := (*C.char)(nil)
	DataLen := (C.int)(dataLen)
	if dataLen > 0 {
		pData = (*C.char)(unsafe.Pointer(&data[0]))
	}

	pResult := (*C.char)(unsafe.Pointer(&buf[0]))
	pResult_len := (*C.int)(unsafe.Pointer(&nBytesRead))

	ret := C.CIdentify_ApplyEx(pData, DataLen, pResult, pResult_len)
	if ret < 0 {
                customlog.PrintErrorLog("Identify_ApplyEx Fail ErrorCode: 0x" + getErrorCodeStr(int(ret)))
		return buf, 0
	}
	return buf, nBytesRead
}

//IdentifyCheckEx 带时间戳Token验证
func IdentifyCheckEx(data []byte, dataLen int, buf []byte, nSize int) int {

	if nSize <= 0 {
		return -1
	}

	pData := (*C.char)(nil)
	DataLen := (C.int)(dataLen)
	if dataLen > 0 {
		pData = (*C.char)(unsafe.Pointer(&data[0]))
	}

	pResult := (*C.char)(unsafe.Pointer(&buf[0]))
	result_len := (C.int)(nSize)

	ret := C.CIdentify_CheckEx(pData, DataLen, 20 * 60, pResult, result_len) 
	if ret < 0 {
                customlog.PrintErrorLog("Identify_CheckEx Fail ErrorCode: 0x" + getErrorCodeStr(int(ret)))
	}
	return int(ret)
}

////IdentifyApplyExbase64 base64加密后带时间戳Token
func IdentifyApplyExbase64(data []byte, dataLen int) (base64Str string) {
	tokenData, tokenDataLen := IdentifyApplyEx(data, dataLen)
	return base64.StdEncoding.EncodeToString(tokenData[0:tokenDataLen])
}

//IdentifyCheckExbase64 base64解密后带时间戳Token验证
func IdentifyCheckExbase64(data []byte, dataLen int, base64Str string) int {
	if len(base64Str) <= 0 {
		return -1
	}
	tokenData, err := base64.StdEncoding.DecodeString(base64Str)
	if err != nil {
		return -1
	}
	return IdentifyCheckEx(data, dataLen, tokenData, len(tokenData))
}

//IdentifyEncryptData 加密数据
func IdentifyEncryptData(data []byte, dataLen int) ([]byte, int) {
	nSize := 1024
	buf := make([]byte, nSize)

	if dataLen <= 0 {
		return buf, 0
	}
	nBytesRead := nSize

	pData := (*C.char)(unsafe.Pointer(&data[0]))
	DataLen := (C.int)(dataLen)

	pResult := (*C.char)(unsafe.Pointer(&buf[0]))
	pResult_len := (*C.int)(unsafe.Pointer(&nBytesRead))

	ret := C.CIdentify_EncryptData(pData, DataLen, pResult, pResult_len)
	if ret < 0 {
                customlog.PrintErrorLog("Identify_EncryptData Fail ErrorCode: 0x" + getErrorCodeStr(int(ret)))
		return buf, 0
	}
	return buf, nBytesRead
}

//IdentifyDecryptData 解密数据
func IdentifyDecryptData(data []byte, dataLen int) ([]byte, int) {
	nSize := 1024
	buf := make([]byte, nSize)

	if dataLen <= 0 {
		return buf, 0
	}
	nBytesRead := nSize
	pData := (*C.char)(unsafe.Pointer(&data[0]))
	DataLen := (C.int)(dataLen)

	pResult := (*C.char)(unsafe.Pointer(&buf[0]))
	pResultlen := (*C.int)(unsafe.Pointer(&nBytesRead))

	ret := C.CIdentify_DecryptData(pData, DataLen, pResult, pResultlen)
	if ret < 0 {
                customlog.PrintErrorLog("Identify_DecryptData Fail ErrorCode: 0x" + getErrorCodeStr(int(ret)))
		return buf, 0
	}
	return buf, nBytesRead
}

//EncryptDataBase64 base64加密后的加密数据
func EncryptDataBase64(input string) (base64Str string) {
	if len(input) <= 0 {
		return ""
	}
	data2 := []byte(input)
	encodeData, encodeDataLen := IdentifyEncryptData(data2, len(data2))
	if encodeDataLen <= 0 {
		return ""
	}
	return base64.StdEncoding.EncodeToString(encodeData[0:encodeDataLen])
}

//DecryptDataBase64 base64解密后的解密数据
func DecryptDataBase64(base64Str string) (output string) {
	if len(base64Str) <= 0 {
		return ""
	}

	data2, err := base64.StdEncoding.DecodeString(base64Str)
	if err != nil {
		return ""
	}
	decodeData, decodeDataLen := IdentifyDecryptData(data2, len(data2))
	if decodeDataLen <= 0 {
		return ""
	}
	return string(decodeData[0:decodeDataLen])
}
//getErrorCodeStr 将返回错误数值转换为Identify_define.h中定义错误码
func getErrorCodeStr(errorCode int) string {
        
        // 错误码差值
        base := 2147483648//错误码基数 0x80000000
        errorCode += base 

        // int -> string
        strErrorCode := strconv.Itoa(errorCode)

        // string -> int64
        myuint64,_ := strconv.ParseUint(strErrorCode, 10, 64)
            
        // int64 -> string
        str64 := strconv.FormatUint(myuint64, 16)
        
        // string -> int64
        my64,_ := strconv.ParseUint(str64, 16, 64)
        my64 += 0x80000000
       
        // int64 -> string
        strFinal := strconv.FormatUint(my64, 16)
        return strFinal
}
