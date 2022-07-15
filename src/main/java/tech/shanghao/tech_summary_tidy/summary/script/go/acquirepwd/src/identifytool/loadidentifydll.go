//Package identifytool go对Identify.dll功能的包裹,提供加解密、token获取校验功能
package identifytool

import (
	"encoding/base64"
	"syscall"
	"unsafe"
)

var (
	goIdentify = syscall.NewLazyDLL("Identify.dll")

	procIdentifyInit = goIdentify.NewProc("Identify_Init")
	procIdentifyFini = goIdentify.NewProc("Identify_Fini")

	procIdentifyEncryptData = goIdentify.NewProc("Identify_EncryptData")
	procIdentifyDecryptData = goIdentify.NewProc("Identify_DecryptData")

	procIdentifyApply = goIdentify.NewProc("Identify_Apply")
	procIdentifyCheck = goIdentify.NewProc("Identify_Check")

	procIdentifyApplyEx = goIdentify.NewProc("Identify_ApplyEx")
	procIdentifyCheckEx = goIdentify.NewProc("Identify_CheckEx")
)

//IdentifyInit 身份认证库初始化
func IdentifyInit() int {
	ret, _, _ := procIdentifyInit.Call()
	return int(ret)
}

//IdentifyFini 身份认证库反初始化
func IdentifyFini() int {
	ret, _, _ := procIdentifyFini.Call()
	return int(ret)
}

//IdentifyApply 不带时间戳Token获取
func IdentifyApply(data []byte, dataLen int) ([]byte, int) {

	nSize := 1024
	buf := make([]byte, nSize)
	nBytesRead := nSize

	pData := uintptr(0)
	pDataLen := uintptr(0)

	if dataLen > 0 {
		pData = uintptr(unsafe.Pointer(&data[0]))
		pDataLen = uintptr(dataLen)
	}

	ret, _, _ := procIdentifyApply.Call(pData, pDataLen, uintptr(unsafe.Pointer(&buf[0])), uintptr(unsafe.Pointer(&nBytesRead)))
	if ret < 0 {
		return buf, 0
	}
	return buf, nBytesRead
}

//IdentifyCheck 不带时间戳Token验证
func IdentifyCheck(data []byte, dataLen int, buf []byte, nSize int) int {

	pData := uintptr(0)
	pDataLen := uintptr(0)

	if dataLen > 0 {
		pData = uintptr(unsafe.Pointer(&data[0]))
		pDataLen = uintptr(dataLen)
	}

	ret, _, _ := procIdentifyCheck.Call(pData, pDataLen, uintptr(unsafe.Pointer(&buf[0])), uintptr(nSize))
	return int(ret)
}

//IdentifyApplybase64 base64加密后不带时间戳Token
func IdentifyApplybase64(data []byte, dataLen int) (base64Str string) {
	tokenData, tokenDataLen := IdentifyApply(data, dataLen)
	return base64.StdEncoding.EncodeToString(tokenData[0:tokenDataLen])
}

//IdentifyCheckbase64 base64解密后不带时间戳Token验证
func IdentifyCheckbase64(data []byte, dataLen int, base64Str string) int {
	if len(base64Str) <= 0 {
		return -1
	}
	tokenData, err := base64.StdEncoding.DecodeString(base64Str)
	if err != nil {
		return -1
	}
	return IdentifyCheck(data, dataLen, tokenData, len(tokenData))
}

//IdentifyApplyEx 带时间戳Token获取
func IdentifyApplyEx(data []byte, dataLen int) ([]byte, int) {

	nSize := 1024
	buf := make([]byte, nSize)
	nBytesRead := nSize

	pData := uintptr(0)
	pDataLen := uintptr(0)

	if dataLen > 0 {
		pData = uintptr(unsafe.Pointer(&data[0]))
		pDataLen = uintptr(dataLen)
	}

	ret, _, _ := procIdentifyApplyEx.Call(pData, pDataLen, uintptr(unsafe.Pointer(&buf[0])), uintptr(unsafe.Pointer(&nBytesRead)))
	if ret < 0 {
		return buf, 0
	}
	return buf, nBytesRead
}

//IdentifyCheckEx 带时间戳Token验证
func IdentifyCheckEx(data []byte, dataLen int, buf []byte, nSize int) int {

	pData := uintptr(0)
	pDataLen := uintptr(0)
	pnTimeflag := uintptr(0)
	var nTimeflag int
	nTimeflag = 20 * 60
	pnTimeflag = uintptr(nTimeflag)
	if dataLen > 0 {
		pData = uintptr(unsafe.Pointer(&data[0]))
		pDataLen = uintptr(dataLen)
	}

	ret, _, _ := procIdentifyCheckEx.Call(pData, pDataLen, pnTimeflag, uintptr(unsafe.Pointer(&buf[0])), uintptr(nSize))
	return int(ret)
}

//IdentifyApplyExbase64 base64加密后带时间戳Token
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

	nBytesRead := nSize

	pData := uintptr(0)
	pDataLen := uintptr(0)

	if dataLen > 0 {
		pData = uintptr(unsafe.Pointer(&data[0]))
		pDataLen = uintptr(dataLen)
	}

	ret, _, _ := procIdentifyEncryptData.Call(pData, pDataLen, uintptr(unsafe.Pointer(&buf[0])), uintptr(unsafe.Pointer(&nBytesRead)))
	if ret < 0 {
		return buf, 0
	}
	return buf, nBytesRead
}

//IdentifyDecryptData 解密数据
func IdentifyDecryptData(data []byte, dataLen int) ([]byte, int) {
	nSize := 1024
	buf := make([]byte, nSize)

	nBytesRead := nSize

	pData := uintptr(0)
	pDataLen := uintptr(0)

	if dataLen > 0 {
		pData = uintptr(unsafe.Pointer(&data[0]))
		pDataLen = uintptr(dataLen)
	}

	ret, _, _ := procIdentifyDecryptData.Call(pData, pDataLen, uintptr(unsafe.Pointer(&buf[0])), uintptr(unsafe.Pointer(&nBytesRead)))
	if ret < 0 {
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
