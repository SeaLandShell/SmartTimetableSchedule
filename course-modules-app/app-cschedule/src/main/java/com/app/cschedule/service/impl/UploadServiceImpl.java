package com.app.cschedule.service.impl;

import com.app.cschedule.common.support.BaseService;
import com.app.cschedule.entity.Upload;
import com.app.cschedule.mapper.UploadMapper;
import com.app.cschedule.service.UploadService;
import com.course.common.core.utils.DateUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.List;
@Service
public class UploadServiceImpl extends BaseService<Upload> implements UploadService {

    @Autowired
    private UploadMapper uploadMapper;

    @Override
    public int addUpload(Upload upload) {
        if (uploadMapper.selectOne(upload) != null) {
            return 0;
        }
        return uploadMapper.insert(upload);
    }

    @Override
    public List<Upload> getWorksByCourseId(String courseId){
        List<Upload> uploads=uploadMapper.getUploadsByCourseId(courseId);
        return uploads;
    }

    @Override
    public Upload selectUploadByCourseIdUploadName(String courseId,String workId,Long userId){
        return uploadMapper.selectUploadByCourseIdUploadName(courseId,workId,userId);
    }

    @Override
    public Upload selectUpload(Upload upload) {
        return uploadMapper.selectOne(upload);
    }
}
