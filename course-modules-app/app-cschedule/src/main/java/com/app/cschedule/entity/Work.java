package com.app.cschedule.entity;

import com.app.cschedule.common.support.BaseEntity;
import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Data;
import lombok.experimental.Accessors;

import java.util.Date;

// BaseEntity class is assumed to be defined elsewhere in your codebase
@Data // 自动生成getter、setter方法、equals方法、hashCode方法、toString方法
@Accessors(chain = true) // 支持链式调用
public class Work extends BaseEntity {
    // 作业ID
    private String workId;
    // 课程ID
    private String courseId;
    // 作业名
    private String workName;
    // 是否启用
    private boolean isEnabled;
    // 作业要求
    private String content;
    // 作业附件链接(链接到mongodb的对应键)
    private String linkResource;
    // 作业开始时间
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date startTime;
    // 作业截止时间
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date endTime;
    // 是否过期（0标识过期，1标识未过期）
    private long state;

}
