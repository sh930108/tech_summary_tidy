package main

import (
	"customlog"
	"fmt"
	"os"
	"strconv"
	"time"

	"../identifytool"
)

func main() {
	/* 只打印调用接口错误日志 */
	customlog.InitLogByName("IdentifyError.log")

	/* 解析命令行参数 */
	args := os.Args
	if len(args) == 2 {
		cmd := args[1]
		if cmd == "-t" || cmd == "--token" { //不带时间戳token
			fmt.Println(token())
		} else if cmd == "-te" || cmd == "--tokenex" { //带时间戳token
			fmt.Println(tokenex())
		} else if cmd == "-h" || cmd == "--help" { //帮助说明
			showHelp()
		} else {
			errArgs()
		}
	} else if len(args) == 3 {
		cmd := args[1]
		data := args[2]
		if cmd == "-d" || cmd == "--decryption" { //解密数据
			fmt.Println(decryption(data))
		} else if cmd == "-e" || cmd == "--encryption" { //加密数据
			fmt.Println(encryption(data))
		} else if cmd == "-ct" || cmd == "--checktoken" { //校验不带时间戳token
			fmt.Println(checktoken(data))
		} else if cmd == "-cte" || cmd == "checktokenex" { //校验带时间戳token
			fmt.Println(checktokenex(data))
		}
	} else {
		errArgs()
	}

}

/* 返回不带时间戳token */
func token() string {
	rv := identifytool.IdentifyInit()
	if rv != 0 {
		return ""
	}
	tokenBase64Str := identifytool.IdentifyApplybase64(nil, 0)
	identifytool.IdentifyFini()
	return tokenBase64Str
}

/* 返回带时间戳token*/
func tokenex() string {
	rv := identifytool.IdentifyInit()
	if rv != 0 {
		return ""
	}
	tokenExBase64Str := identifytool.IdentifyApplyExbase64(nil, 0)
	identifytool.IdentifyFini()
	return tokenExBase64Str
}

/* 解密64加密数据 */
func decryption(secretdata string) string {
	rv := identifytool.IdentifyInit()
	if rv != 0 {
		return ""
	}

	rawData := identifytool.DecryptDataBase64(secretdata)
	identifytool.IdentifyFini()
	return rawData
}

/* 加密64加密数据 */
func encryption(rawdata string) string {
	rv := identifytool.IdentifyInit()
	if rv != 0 {
		return ""
	}

	secretdata := identifytool.EncryptDataBase64(rawdata)
	identifytool.IdentifyFini()
	return secretdata
}

/* 校验不带时间戳token*/
func checktoken(tokenBase64Str string) string {
	rv := identifytool.IdentifyInit()
	if rv != 0 {
		return "-1"
	}
	base64ret := identifytool.IdentifyCheckbase64(nil, 0, tokenBase64Str)
	identifytool.IdentifyFini()
	return strconv.Itoa(base64ret)
}

/* 校验带时间戳token*/
func checktokenex(tokenExBase64Str string) string {
	rv := identifytool.IdentifyInit()
	if rv != 0 {
		return "-1"
	}
	base64ret := identifytool.IdentifyCheckExbase64(nil, 0, tokenExBase64Str)
	println("base64ret:", base64ret)
	identifytool.IdentifyFini()
	return strconv.Itoa(base64ret)
}

func errArgs() {
	fmt.Printf("Error Arguments\n")
	showHelp()
}
func showHelp() {
	fmt.Printf("-h, --help  show this help message and exit\n")
	fmt.Printf("-d DECRYPTION, --decryption DECRYPTION  Decrypt the data encoded by base64\n")
	fmt.Printf("-e ENCRYPTION, --encryption ENCRYPTION  Encrypt the data by encode with base64\n")
	fmt.Printf("-t TOKEN, --token TOKEN  get token without timestamp\n")
	fmt.Printf("-te TOKENEX, --tokenex TOKENEX  get token with timestamp\n")
	fmt.Printf("-ct CHECKTOKEN, --checktoken CHECKTOKEN  check the token without timestamp\n")
	fmt.Printf("-cte CHECKTOKENEX, --checktokenex CHECKTOKENEX  check the token with timestamp\n")
	fmt.Printf("Waiting for 10s and exit...\n")
	time.Sleep(10 * time.Second)
}
