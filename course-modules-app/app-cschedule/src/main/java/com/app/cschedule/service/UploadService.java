package com.app.cschedule.service;

import com.app.cschedule.common.support.IService;
import com.app.cschedule.entity.Upload;
import com.app.cschedule.entity.Work;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface UploadService extends IService<Upload> {
    List<Upload> getWorksByCourseId(String courseId);

    int addUpload(Upload upload);


    Upload selectUploadByCourseIdUploadName(@Param("courseId") String courseId,@Param("workId") String workId,@Param("userId") Long userId);

    Upload selectUpload(Upload upload);

//    Upload selectUploadByCourseIdUploadName(String courseId,String UploadName);

//    int updateByExId(Upload Upload);

//    int delete(Upload Upload);
}
