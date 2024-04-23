package com.app.cschedule.service.impl;

import com.app.cschedule.common.support.BaseService;
import com.app.cschedule.common.util.FileContentTypeUtils;
import com.app.cschedule.common.util.FileUrlUtils;
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
    public Resource addResource(Resource resource, MultipartFile file) { // 定义添加资源的方法，接收Resource对象和MultipartFile对象作为参数
        String receiveName = resource.getResName();
        if(receiveName.contains(".")){
            receiveName = receiveName.substring(0,receiveName.lastIndexOf("."));
        }
        String fileName = receiveName + FileContentTypeUtils.getFileType(file.getOriginalFilename()); // 获取文件名，结合文件类型
        String path = FileUtils.storeFile(file, fileName, FileUtils.getUserPath(resource.getCourseId())); // 存储文件到指定路径
        resource.setResId(RandomStringUtils.randomAlphanumeric(20)); // 为资源生成一个20位的随机ID
        resource.setDownLink(FileUrlUtils.toDownloadUrl(path)); // 设置资源的下载链接为存储路径
        resource.setResSize(file.getSize()); // 设置资源大小为文件大小
        resource.setUploadTime(new Date()); // 设置资源上传时间为当前时间
        resource.setExperience(0);
        resourceMapper.insert(resource); // 调用resourceMapper插入资源到数据库
        return resource; // 返回添加后的资源对象
    }
}
