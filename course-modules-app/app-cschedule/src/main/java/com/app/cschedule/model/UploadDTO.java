package com.app.cschedule.model;
import com.app.cschedule.common.util.FileUrlUtils;
import com.app.cschedule.entity.Upload;
import com.app.cschedule.entity.Upload;
import com.fasterxml.jackson.annotation.JsonFormat;
import com.google.common.base.Converter;
import lombok.Data;
import org.springframework.beans.BeanUtils;

import java.util.Date;

@Data
public class UploadDTO {

    private String uploadId;

    private String courseId;

    private long userId;
    // 作业ID
    private String workId;

    private String workName;
    // 作业要求
    private String content;
    // 作业附件链接(链接到mongodb的对应键)
    private String linkUpload;
    // 评价
    private String appraise;
    // 批语
    private String criticism;
    // 评分
    private int score;
    // 审核状态
    private String review;
    

    public Upload convertToUpload(){
        UploadConverter converter = new UploadConverter();
        Upload upload = converter.convert(this);
        return upload;
    }

    public UploadDTO convertFor(Upload upload){
        UploadConverter converter = new UploadConverter();
        UploadDTO uploadDto = converter.reverse().convert(upload);
        return uploadDto;
    }


    private static class UploadConverter extends Converter<UploadDTO, Upload> {
        @Override
        protected Upload doForward(UploadDTO uploadDto) {
            Upload upload = new Upload();
            // 使用BeanCopier也可以
            BeanUtils.copyProperties(uploadDto, upload);
            return upload;
        }

        @Override
        protected UploadDTO doBackward(Upload upload) {
            UploadDTO uploadDto = new UploadDTO();
            BeanUtils.copyProperties(upload, uploadDto);
            return uploadDto;
        }
    }
}
