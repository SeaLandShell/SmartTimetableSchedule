package com.app.cschedule.entity; // 声明包名为com.app.cschedule.entity

import com.app.cschedule.common.support.BaseEntity; // 导入BaseEntity类
import lombok.Data; // 导入lombok注解@Data
import lombok.experimental.Accessors; // 导入lombok注解@Accessors

/**
 * @author ankoye@qq.com
 */
@Data // 自动生成getter、setter方法、equals方法、hashCode方法、toString方法
@Accessors(chain = true) // 支持链式调用
public class Member extends BaseEntity { // 定义Member类，继承BaseEntity类

//    private static final long serialVersionUID = 5678845178960858841L;

    private String userId; // 用户ID，字符串类型
    private String courseId; // 课程ID，字符串类型
    private Integer arrive; // 到课次数，整数类型
    private Integer resource; // 资源数量，整数类型
    private Integer experience; // 体验次数，整数类型
    private Integer score; // 评分，整数类型
    private String remark; // 备注，字符串类型
}