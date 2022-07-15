#!/usr/bin/python
# -*- coding: utf-8 -*-
import base64
import ctypes
import sys
import platform
import argparse
import traceback
from ctypes import *  # @UnusedWildImport

Identify_dll = ""


def init_dll():
    global Identify_dll

    sys_name = platform.system()
    if (sys_name == "Windows"):
        Identify_dll = ctypes.windll.LoadLibrary('./Identify.dll')
    elif (sys_name == "Linux"):
        Identify_dll = ctypes.cdll.LoadLibrary('./libIdentify.so')

    Identify_dll.Identify_EncryptData.restype = c_int
    Identify_dll.Identify_DecryptData.restype = c_int
    Identify_dll.Identify_ApplyEx.restype = c_int
    Identify_dll.Identify_CheckEx.restype = c_int
    Identify_dll.Identify_Apply.restype = c_int
    Identify_dll.Identify_Check.restype = c_int
    Identify_dll.Identify_Init.restype = c_int
    Identify_dll.Identify_Fini.restype = c_int
    Identify_dll.Identify_Init()


def fini_dll():
    Identify_dll.Identify_Fini()


def encode_data(data):
    """
    加密数据
    :param data:
    :return:
    """
    try:
        buffer_size = 1024
        dst_buffer = ctypes.create_string_buffer(buffer_size)
        dst_buffer_ref_size = c_int(buffer_size)
        p_dst_buffer = addressof(dst_buffer)
        rv = Identify_dll.Identify_EncryptData(data, len(data), p_dst_buffer, byref(dst_buffer_ref_size))
        bin_len = dst_buffer_ref_size.value
        dst_buffer2 = ctypes.create_string_buffer(bin_len)
        for dst_index in range(bin_len):
            dst_buffer2[dst_index] = dst_buffer[dst_index]
        base64_encode_str = base64.b64encode(dst_buffer2)
        return base64_encode_str
    except Exception:
        traceback.format_exc()
        sys.exit(-1)


def decode_data(base64_data):
    """
    解密数据
    @param base64_data base编码过的加密数据
    """
    try:
        data = base64.b64decode(base64_data)
        data_size = len(data)
        buffer_size = 1024
        src_buffer = ctypes.create_string_buffer(buffer_size)
        src_buffer_ref_size = c_int(buffer_size)
        p_src_buffer = addressof(src_buffer)
        rv = Identify_dll.Identify_DecryptData(data, data_size, p_src_buffer, byref(src_buffer_ref_size))
        return string_at(p_src_buffer, src_buffer_ref_size)
    except Exception:
        traceback.format_exc()
        sys.exit(-1)


def get_token():
    """
    获取不带时间戳的token
    :return:
    """
    try:
        buffer_size = 1024
        src_buffer = ctypes.create_string_buffer(buffer_size)
        src_buffer_ref_size = c_int(buffer_size)
        p_src_buffer = addressof(src_buffer)

        rv = Identify_dll.Identify_Apply(0, 0, p_src_buffer, byref(src_buffer_ref_size))
        if rv == 0:
            bin_len = src_buffer_ref_size.value
            # print(bin_len)
            dst_buffer2 = ctypes.create_string_buffer(bin_len)
            for dst_index in range(bin_len):
                dst_buffer2[dst_index] = src_buffer[dst_index]

            base64_encode_str = base64.b64encode(dst_buffer2)
            return base64_encode_str
        return ""
    except Exception:
        traceback.format_exc()
        sys.exit(-1)


def get_token_ex():
    """
    获取带时间戳的token
    :return:
    """
    try:
        buffer_size_ex = 1024
        src_buffer_ex = ctypes.create_string_buffer(buffer_size_ex)
        src_buffer_ref_size_ex = c_int(buffer_size_ex)
        p_src_buffer_ex = addressof(src_buffer_ex)

        rv = Identify_dll.Identify_ApplyEx(0, 0, p_src_buffer_ex, byref(src_buffer_ref_size_ex))
        if rv == 0:
            bin_len_ex = src_buffer_ref_size_ex.value
            # print(bin_len_ex)
            dst_buffer2_ex = ctypes.create_string_buffer(bin_len_ex)
            for dst_index in range(bin_len_ex):
                dst_buffer2_ex[dst_index] = src_buffer_ex[dst_index]

            base64_encode_str = base64.b64encode(dst_buffer2_ex)
            return base64_encode_str
        else:
            print("get token_ex error, the errcode is " + rv)
            sys.exit(-1)
    except Exception:
        traceback.format_exc()
        sys.exit(-1)


def check_token(base64_data):
    token_str = base64.b64decode(base64_data)
    src_buffer_ref_size = c_int(len(token_str))
    p_src_buffer = bytes(token_str)
    rv = Identify_dll.Identify_Check(0, 0, p_src_buffer, src_buffer_ref_size)
    return rv


def check_token_ex(base64_data, ex_token_refresh_interval=20 * 60):
    """
    验证带时间戳的token
    :param base64_data:
    :param ex_token_refresh_interval: 超时时间 S
    :return:
    """
    token_str = base64.b64decode(base64_data)
    src_buffer_ref_size = c_int(len(token_str))
    p_src_buffer = bytes(token_str)
    rv = Identify_dll.Identify_CheckEx(0, 0, ex_token_refresh_interval, p_src_buffer, src_buffer_ref_size)
    return rv


if __name__ == "__main__":
    try:
        init_dll()
        # 解析命令行参数
        parser = argparse.ArgumentParser()
        group = parser.add_mutually_exclusive_group()
        # 解密数据
        group.add_argument(
            "-d", "--decryption",
            dest="decryption",
            help="Decrypt the data encoded by base64.",
        )
        # 加密数据
        group.add_argument(
            "-e", "--encryption",
            dest="encryption",
            help="encryption the data and encode with base64"
        )

        # 获取无时间戳token
        group.add_argument(
            "-t", "--token",
            dest="token",
            help="get token without timestamp",
        )
        # 获取含时间戳token
        group.add_argument(
            "-te", "--tokenex",
            dest="tokenex",
            help="get token with timestamp"
        )
        # 验证无时间戳token
        group.add_argument(
            "-ct", "--checktoken",
            dest="checktoken",
            help="check the token without the time stamp"
        )
        # 验证有时间戳token
        group.add_argument(
            "-cte", "--checktokenex",
            dest="checktokenex",
            help="check the token with the time stamp"
        )

        args = parser.parse_args()

        if args.token:
            token = get_token()
            sys.stdout.write(token)
        elif args.tokenex:
            token_ex = get_token_ex()
            sys.stdout.write(token_ex)
        elif args.checktoken is not None:
            # 验证无时间戳token，为0表示验证成功
            result = check_token(args.checktoken)
            if result == 0:
                sys.stdout.write('true')
            else:
                sys.stdout.write('false')
        elif args.checktokenex is not None:
            # 验证有时间戳token，为0表示验证成功
            result = check_token_ex(args.checktokenex)
            if result == 0:
                sys.stdout.write('true')
            else:
                sys.stdout.write('false')
        elif args.decryption is not None:
            plain_text = decode_data(args.decryption)
            sys.stdout.write(plain_text)
        elif args.encryption is not None:
            cipher = encode_data(args.encryption)
            sys.stdout.write(cipher)
        else:
            print "need at least one param"
        sys.stdout.flush()

    except Exception:
        traceback.format_exc()
        sys.exit(-1)
    finally:
        fini_dll()
