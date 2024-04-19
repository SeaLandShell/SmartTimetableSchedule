package com.app.ctimetable.utils; // 声明包名com.app.ctimetable.utils

import org.slf4j.Logger; // 导入Logger类
import org.slf4j.LoggerFactory; // 导入LoggerFactory类

import java.net.Inet4Address; // 导入Inet4Address类
import java.net.InetAddress; // 导入InetAddress类
import java.net.UnknownHostException; // 导入UnknownHostException类
import java.util.UUID; // 导入UUID类

public class Utils { // 定义Utils类
    public static final Logger logger = LoggerFactory.getLogger(Utils.class); // 声明一个静态的Logger类型的logger常量，用于记录日志

    // 定义一个静态方法getIpAddress，用于获取本地IP地址
    public static String getIpAddress() {
        InetAddress localHost = null; // 声明一个InetAddress类型的localHost变量，初始化为null
        try {
            localHost = Inet4Address.getLocalHost(); // 获取本地主机的Inet4Address对象
        } catch (UnknownHostException e) { // 捕获UnknownHostException异常
            logger.error(e.getMessage(), e); // 记录错误日志
        }
        if (localHost == null) { // 如果localHost为null
            return ""; // 返回空字符串
        } else { // 如果localHost不为null
            return TextUtils.orEmpty(localHost.getHostAddress(), ""); // 返回本地主机的IP地址，如果为空则返回空字符串
        }
    }

    // 定义一个静态方法getUUID，用于生成UUID
    public static String getUUID() {
        return UUID.randomUUID().toString().replace("-", ""); // 生成UUID并去除其中的"-"
    }
}
