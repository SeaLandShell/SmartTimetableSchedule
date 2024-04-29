package com.app.cschedule.entity; // 声明包名为com.app.cschedule.entity

import com.app.cschedule.common.support.BaseEntity; // 导入BaseEntity类
import com.fasterxml.jackson.annotation.JsonFormat; // 导入JsonFormat注解
import lombok.Data; // 导入lombok注解@Data
import lombok.experimental.Accessors; // 导入lombok注解@Accessors
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import java.util.Date; // 导入Date类

/**
 * @author ankoye@qq.com
 */
@Repository
@Data // 自动生成getter、setter方法、equals方法、hashCode方法、toString方法
@Accessors(chain = true) // 支持链式调用
public class Resource extends BaseEntity { // 定义Resource类，继承BaseEntity类

//    private static final long serialVersionUID = 2560725616980135700L;

    private String resId; // 资源ID，字符串类型

    private String resName; // 资源名称，字符串类型

    private Long resSize; // 资源大小，长整型

    private String downLink; // 下载链接，字符串类型

    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date uploadTime; // 上传时间，Date类型，格式为yyyy-MM-dd HH:mm:ss

    private Integer experience; // 体验次数，整数类型

    private String courseId; // 课程ID，字符串类型
}