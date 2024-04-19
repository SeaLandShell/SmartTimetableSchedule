package com.app.cschedule.service;

import com.app.cschedule.common.support.IService;
import com.app.cschedule.entity.Resource;
import org.springframework.web.multipart.MultipartFile;

public interface ResourceService extends IService<Resource> {

    /**
     * 添加班级资源
     * @param resource 资源信息表
     */
    Resource addResource(Resource resource, MultipartFile file);

}
