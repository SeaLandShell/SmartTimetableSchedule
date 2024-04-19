package com.app.cschedule.common.util; // 声明包名

import com.fasterxml.jackson.core.JsonProcessingException; // 导入JsonProcessingException类
import com.fasterxml.jackson.databind.ObjectMapper; // 导入ObjectMapper类

import java.io.IOException; // 导入IOException类
import java.io.InputStream; // 导入InputStream类
import java.util.List; // 导入List类

public class JsonUtils { // 定义JsonUtils类

    private static final ObjectMapper mapper = new ObjectMapper(); // 创建ObjectMapper对象并初始化为静态变量

    public static String toString(Object obj) { // 定义toString方法，接收Object类型参数，返回String类型
        if (obj == null) // 如果obj为空
            return null; // 返回空
        if (obj.getClass() == String.class) // 如果obj的类是String类
            return (String) obj; // 返回强制转换为String类型的obj
        try { // 捕获可能发生的异常
            return mapper.writeValueAsString(obj); // 将obj转换为JSON字符串并返回
        } catch (JsonProcessingException e) { // 捕获JsonProcessingException异常
            e.printStackTrace(); // 打印异常信息
        }
        return null; // 返回空
    }

    public static <T> T toBean(String json, Class<T> tClass) { // 定义toBean方法，接收String类型和Class<T>类型参数，返回T类型
        try { // 捕获可能发生的异常
            return mapper.readValue(json, tClass); // 将JSON字符串转换为指定类型的对象并返回
        } catch (JsonProcessingException e) { // 捕获JsonProcessingException异常
            e.printStackTrace(); // 打印异常信息
        }
        return null; // 返回空
    }

    public static <T> T toBean(InputStream is, Class<T> tClass) { // 定义toBean方法，接收InputStream类型和Class<T>类型参数，返回T类型
        try { // 捕获可能发生的异常
            return mapper.readValue(is, tClass); // 将输入流转换为指定类型的对象并返回
        } catch (IOException e) { // 捕获IOException异常
            e.printStackTrace(); // 打印异常信息
        }
        return null; // 返回空
    }

    public static <T> List<T> toList(String json, Class<T> eClass) { // 定义toList方法，接收String类型和Class<T>类型参数，返回List<T>类型
        try { // 捕获可能发生的异常
            return mapper.readValue(json, mapper.getTypeFactory().constructCollectionType(List.class, eClass)); // 将JSON字符串转换为List对象并返回
        } catch (JsonProcessingException e) { // 捕获JsonProcessingException异常
            e.printStackTrace(); // 打印异常信息
        }
        return null; // 返回空
    }
}