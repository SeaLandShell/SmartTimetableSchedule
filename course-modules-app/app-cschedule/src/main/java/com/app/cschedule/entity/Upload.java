package com.app.cschedule.entity;

import com.app.cschedule.common.support.BaseEntity;
import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Data;
import lombok.experimental.Accessors;
import lombok.experimental.FieldNameConstants;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

import java.util.Date;

@Data
@Accessors(chain=true)
@FieldNameConstants
@Document(collection = "uploadNoLimit")
public class Upload extends BaseEntity {
    // 上传ID
    @Id
    private String uploadId;
    // 课程ID
    private String courseId;
    // 学生ID
    private long userId;
    // 作业ID
    private String workId;

    private String workName;
    // 作业要求
    private String content;
    // 作业附件链接(链接到mongodb的对应键)
    private String linkResource;
    // 评价
    private String appraise;
    // 批语
    private String criticism;
    // 评分
    private int score;
    // 审核状态
    private String review;

}