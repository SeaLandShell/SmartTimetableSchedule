package com.app.cschedule.common.annotation; // 定义包名为com.app.cschedule.common.annotation

import com.app.cschedule.common.constant.LogType; // 导入LogType类

import java.lang.annotation.*; // 导入Java中的注解相关类

@Target(ElementType.METHOD) // 定义注解的作用目标为方法
@Retention(RetentionPolicy.RUNTIME) // 设置注解保留策略为运行时
@Documented // 指明该注解应该被javadoc工具记录
public @interface LogAnnotation { // 定义LogAnnotation注解

    String module() default ""; // 定义注解属性module，默认值为空字符串

    String operation() default ""; // 定义注解属性operation，默认值为空字符串

    LogType[] exclude() default {}; // 定义注解属性exclude为LogType数组，默认为空数组
}