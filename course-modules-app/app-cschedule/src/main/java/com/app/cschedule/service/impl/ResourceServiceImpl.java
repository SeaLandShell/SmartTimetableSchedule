package com.app.cschedule.service.impl;

import com.app.cschedule.common.support.BaseService;
import com.app.cschedule.common.util.FileContentTypeUtils;
import com.app.cschedule.common.util.FileUtils;
import com.app.cschedule.mapper.ResourceMapper;
import com.app.cschedule.entity.Resource;
import com.app.cschedule.service.ResourceService;
import org.apache.commons.lang3.RandomStringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.util.Date;

@Service
public class ResourceServiceImpl extends BaseService<Resource> implements ResourceService {

    @Autowired
    private ResourceMapper resourceMapper;

    @Override
    public Resource addResource(Resource resource, MultipartFile file) {
        String fileName = resource.getResName() + FileContentTypeUtils.getFileType(file.getOriginalFilename());
        String path = FileUtils.storeFile(file, fileName, FileUtils.getUserPath(resource.getCourseId()));
        resource.setResId(RandomStringUtils.randomAlphanumeric(20));
        resource.setDownLink(path);
        resource.setResSize(file.getSize());
        resource.setUploadTime(new Date());
        resourceMapper.insert(resource);
        return resource;
    }
}
