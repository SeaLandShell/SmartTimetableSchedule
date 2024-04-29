package com.app.cschedule.service.impl;

import com.app.cschedule.common.support.BaseService;
import com.app.cschedule.entity.Work;
import com.app.cschedule.mapper.WorkMapper;
import com.app.cschedule.service.WorkService;
import com.course.common.core.utils.DateUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.List;

@Service
public class WorkServiceImpl extends BaseService<Work> implements WorkService {
    @Autowired
    private WorkMapper workMapper;

    @Override
    public int addWork(Work Work) {
        if (workMapper.selectOne(Work) != null) {
            return 0;
        }
        return workMapper.insert(Work);
    }

    @Override
    public List<Work> getWorksByCourseId(String courseId){
        List<Work> works=workMapper.getWorksByCourseId(courseId);
        for(Work work : works){
            Date startTime=work.getStartTime();
            Date endTime=work.getEndTime();
            Date currentTime=DateUtils.getNowDate();
            long currentTimestamp = currentTime.getTime();
            long startTimeTimestamp = startTime.getTime();
            long endTimeTimestamp = endTime.getTime();
            if (currentTimestamp >= startTimeTimestamp && currentTimestamp <= endTimeTimestamp) {
                if(work.getState()!=1){
                    work.setState(1);
                    workMapper.updateByExId(work);
                }
            } else if(currentTimestamp > endTimeTimestamp) {
                if(work.getState()==1){
                    work.setState(2);
                    workMapper.updateByExId(work);
                }
            }
        }
        return works;
    }

    @Override
    public Work selectWork(Work work) {
        return workMapper.selectOne(work);
    }

    @Override
    public Work selectWorkByCourseIdWorkName(String courseId,String workName){
        return workMapper.selectWorkByCourseIdWorkName(courseId,workName);
    }

    @Override
    public int updateByExId(Work work){
        return workMapper.updateByExId(work);
    }

    @Override
    public int delete(Work work){
        return workMapper.delete(work);
    }

//    @Override
//    public int customDelete(Work Work){
//        return workMapper.customDelete(Work);
//    }
}