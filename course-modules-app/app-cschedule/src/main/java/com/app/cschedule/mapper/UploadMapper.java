package com.app.cschedule.mapper;

import com.app.cschedule.common.support.BaseMapper;
import com.app.cschedule.entity.Upload;
import com.app.cschedule.entity.Work;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
@BaseMapper.Meta(table = "t_upload",exId = "upload_id")
public interface UploadMapper extends BaseMapper<Upload> {

    List<Upload> getUploadsByCourseId(@Param("courseId") String courseId);

    Upload selectUploadByCourseIdUploadName(@Param("courseId") String courseId,@Param("workId") String workId,@Param("userId") Long userId);
}
