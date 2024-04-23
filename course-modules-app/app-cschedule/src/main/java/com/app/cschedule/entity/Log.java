package com.app.cschedule.entity; // 声明包名为com.app.cschedule.entity

import io.swagger.models.auth.In;
import lombok.Data; // 导入lombok注解@Data

import java.io.Serializable; // 导入Serializable接口
import java.util.Date; // 导入Date类

@Data // 自动生成getter、setter方法、equals方法、hashCode方法、toString方法
public class Log implements Serializable { // 定义Log类，实现Serializable接口

    private Integer userId; // 用户ID，字符串类型
    private String userName; // 用户名，字符串类型
    private String module; // 模块，字符串类型
    private String operation; // 操作，字符串类型
    private String method; // 方法，字符串类型
    private String params; // 参数，字符串类型
    private Long time; // 时间，长整型
    private String ip; // IP地址，字符串类型
    private Date createTime; // 创建时间，Date类型
}