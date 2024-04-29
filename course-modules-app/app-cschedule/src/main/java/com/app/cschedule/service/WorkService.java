package com.app.cschedule.service;

import com.app.cschedule.common.support.IService;
import com.app.cschedule.entity.Work;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface WorkService extends IService<Work> {

    List<Work> getWorksByCourseId(String courseId);
    int addWork(Work Work);

    Work selectWork(Work work);

    Work selectWorkByCourseIdWorkName(String courseId,String workName);

    int updateByExId(Work work);

    int delete(Work work);


//    int customDelete(Work Work);
}
