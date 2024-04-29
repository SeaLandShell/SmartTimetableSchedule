package com.app.cschedule.mapper;

import com.app.cschedule.common.support.BaseMapper;
import com.app.cschedule.entity.Work;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
@BaseMapper.Meta(table = "t_work",exId = "work_id")
public interface WorkMapper extends BaseMapper<Work> {
    List<Work> getWorksByCourseId(@Param("courseId") String courseId);

    Work selectWorkByCourseIdWorkName(@Param("courseId") String courseId,@Param("workName") String workName);

//    int updateWork(Work Work);

//    int customDelete(Work Work);
}