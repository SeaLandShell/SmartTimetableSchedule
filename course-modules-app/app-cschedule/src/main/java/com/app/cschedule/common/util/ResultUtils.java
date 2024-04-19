package com.app.cschedule.common.util; // 声明包名

import com.app.cschedule.common.result.Result; // 导入Result类
import com.fasterxml.jackson.databind.ObjectMapper; // 导入ObjectMapper类

import javax.servlet.http.HttpServletResponse; // 导入HttpServletResponse类
import java.io.IOException; // 导入IOException类

public class ResultUtils { // 定义ResultUtils类

    private static ObjectMapper mapper = new ObjectMapper(); // 创建ObjectMapper对象并初始化为静态变量

    public static void responseWrite(HttpServletResponse response, Result result) { // 定义responseWrite方法，接收HttpServletResponse类型和Result类型参数，无返回值
        response.setCharacterEncoding("UTF-8"); // 设置响应编码为UTF-8
        response.setContentType("application/json; charset=utf-8"); // 设置响应内容类型为application/json; charset=utf-8
        try { // 捕获可能发生的异常
            response.getWriter().write(mapper.writeValueAsString(result)); // 将Result对象转换为JSON字符串并写入响应
        } catch (IOException e) { // 捕获IOException异常
            e.printStackTrace(); // 打印异常信息
        }
    }
}