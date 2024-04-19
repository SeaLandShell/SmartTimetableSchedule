package com.app.cschedule.entity; // 声明包名为com.app.cschedule.entity

import com.app.cschedule.common.support.BaseEntity; // 导入BaseEntity类
import com.fasterxml.jackson.annotation.JsonFormat; // 导入JsonFormat注解
import lombok.Data; // 导入lombok注解@Data
import lombok.experimental.Accessors; // 导入lombok注解@Accessors
import org.hibernate.validator.constraints.Length; // 导入Length注解
import javax.validation.constraints.NotNull; // 导入NotNull注解
import java.util.Date; // 导入Date类

/**
 * @author ankoye@qq.com
 */
@Data // 自动生成getter、setter方法、equals方法、hashCode方法、toString方法
@Accessors(chain = true) // 支持链式调用
public class Notice extends BaseEntity { // 定义Notice类，继承BaseEntity类

//    private static final long serialVersionUID = 3044656695007853904L;

    private String noticeId; // 消息ID，字符串类型

    @Length(min=1, max=100, message = "消息内容长度在1-100范围内")
    private String content; // 消息内容，字符串类型，长度在1-100范围内

    @NotNull
    private String author; // 作者，字符串类型，不能为空

    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date releaseTime; // 发布时间，Date类型，格式为yyyy-MM-dd HH:mm:ss

    private Integer type; // 类型，整数类型

    @NotNull
    private String courseId; // 课程ID，字符串类型，不能为空
}