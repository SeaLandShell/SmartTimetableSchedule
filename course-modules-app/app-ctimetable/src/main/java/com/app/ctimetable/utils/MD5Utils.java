package com.app.ctimetable.utils; // 声明该类所属的包名为com.app.ctimetable.utils

import org.jetbrains.annotations.NotNull; // 导入NotNull注解，用于标记参数或返回值不能为null

import java.math.BigInteger; // 导入BigInteger类，用于处理大整数
import java.nio.charset.StandardCharsets; // 导入StandardCharsets类，提供标准字符集编码
import java.security.MessageDigest; // 导入MessageDigest类，用于加密算法
import java.security.NoSuchAlgorithmException; // 导入NoSuchAlgorithmException类，用于处理加密算法不存在的异常

public class MD5Utils { // 定义MD5Utils类

    public static String MD5(@NotNull String s){ // 定义MD5方法，接受一个非空字符串作为参数，并返回加密后的MD5值

        byte[] secretBytes = null; // 声明一个字节数组secretBytes，用于存储加密后的字节数据，初始值为null

        try {
            secretBytes = MessageDigest.getInstance("md5") // 获取MD5加密实例
                    .digest(s.getBytes(StandardCharsets.UTF_8)); // 对输入字符串进行UTF-8编码后加密
        } catch (NoSuchAlgorithmException e) { // 捕获NoSuchAlgorithmException异常
            e.printStackTrace(); // 打印异常信息
        }
        assert secretBytes != null; // 使用断言确保secretBytes不为null，即确保加密后的字节数组不为null

        StringBuilder code = new StringBuilder(new BigInteger(1, secretBytes).toString(16)); // 创建StringBuilder对象code，用于构建MD5加密后的字符串表示
        for (int i = 0; i < 32 - code.length(); i++) { // 循环补齐MD5加密后的字符串长度为32位
            code.insert(0, "0"); // 在字符串前面补0
        }
        return code.toString(); // 返回补齐后的MD5加密字符串作为方法的结果
    }
}
