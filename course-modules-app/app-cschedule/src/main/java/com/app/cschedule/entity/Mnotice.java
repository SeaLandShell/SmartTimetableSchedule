package com.app.cschedule.entity;

import com.app.cschedule.common.support.BaseEntity;
import lombok.Data;
import lombok.experimental.Accessors;

@Data
@Accessors(chain = true)
public class Mnotice extends BaseEntity {
    // 通知ID
    private String mnoticeId;
    // 课程ID
    private String courseId;
    // 发送者姓名
    private String sendName;
    // 发送者ID
    private String sendId;
    // 接收者ID
    private String receiveId;
    // 接收者姓名
    private String receiveName;
    // 标题
    private String title;
    // 内容
    private String content;
}