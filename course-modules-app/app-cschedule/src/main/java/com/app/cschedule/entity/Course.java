package com.app.cschedule.entity; // 声明包名为com.app.cschedule.entity

import com.app.cschedule.common.support.BaseEntity; // 导入BaseEntity类
import lombok.Data; // 导入lombok注解@Data
import lombok.ToString; // 导入lombok注解@ToString
import lombok.experimental.Accessors; // 导入lombok注解@Accessors

/**
 * @author ankoye@qq.com
 */
@Data // 自动生成getter、setter方法、equals方法、hashCode方法、toString方法
@Accessors(chain = true) // 支持链式调用
@ToString(exclude = {"synopsis","teacher", "members", "resources", "notices"}) // 生成toString方法，排除synopsis、teacher、members、resources、notices字段
public class Course extends BaseEntity { // 定义Course类，继承BaseEntity类

//    private static final long serialVersionUID = 5454990500926278155L;

    private String courseId; // 课程ID，字符串类型
    private String courseNum; // 课程编号，字符串类型
    private String courseName; // 课程名称，字符串类型
    private String coursePic; // 课程图片，字符串类型
    private String clazzName; // 班级名称，字符串类型
    private String term; // 学期，字符串类型
    private String synopsis; // 课程简介，字符串类型
    private Integer arrivesNum; // 到课人数，整数类型
    private Integer resourcesNum; // 资源数量，整数类型
    private Integer experiencesNum; // 体验人数，整数类型
    private Boolean appraise; // 评价，布尔类型
    private String teacherId; // 教师ID，字符串类型
    private String teacherName; // 教师姓名，字符串类型
}