package com.app.cschedule.controller; // 包声明

import com.app.cschedule.common.annotation.LogAnnotation; // 导入LogAnnotation注解
import com.app.cschedule.common.result.Result; // 导入Result类
import com.app.cschedule.common.result.ResultCode; // 导入ResultCode枚举
import com.app.cschedule.common.support.BaseController; // 导入BaseController类
import com.app.cschedule.common.util.FileUtils;
import com.app.cschedule.common.util.JsonUtils; // 导入JsonUtils工具类
import com.app.cschedule.entity.Resource; // 导入Resource实体类
import com.app.cschedule.model.ResourceDTO; // 导入ResourceDTO模型类
import com.app.cschedule.service.ResourceService; // 导入ResourceService服务类
import com.app.cschedule.service.mongo_service.ResourcesEntity;
import com.app.cschedule.service.mongo_service.ResourcesRepository;
import io.swagger.annotations.Api; // 导入Api注解
import io.swagger.annotations.ApiOperation; // 导入ApiOperation注解
import org.springframework.beans.factory.annotation.Autowired; // 导入Autowired注解
import org.springframework.data.domain.Example;
import org.springframework.web.bind.annotation.*; // 导入RequestMapping注解和相关注解
import org.springframework.web.multipart.MultipartFile; // 导入MultipartFile类

import java.io.IOException;
import java.util.List;

@Api(tags = "班级资源管理") // 使用Api注解，定义接口标签为"班级资源管理"
@RestController // 声明该类是一个控制器，并返回RESTful风格的数据
@RequestMapping("/resources") // 映射请求路径为/resources的接口
public class ResourceController extends BaseController { // 定义ResourceController类，继承BaseController类

    @javax.annotation.Resource
    private ResourcesRepository resourcesRepository;
    @Autowired // 使用Autowired注解，自动装配ResourceService对象
    private ResourceService resourceService; // 声明ResourceService对象

    @ApiOperation(value = "添加资源") // 使用ApiOperation注解，定义接口操作为"添加资源"
    @LogAnnotation(operation = "添加资源") // 记录添加资源操作日志
    @PostMapping // 映射POST请求
    public Result addResource(@RequestParam("info") String resourceForm , @RequestParam("file") MultipartFile file) { // 定义添加资源的方法，接收资源信息和文件作为参数
//        System.out.println(resourceForm);
        Resource resource = JsonUtils.toBean(resourceForm, Resource.class); // 将资源信息转换为Resource对象
        if(resource == null) { // 如果资源对象为空
            return Result.error(ResultCode.PARAM_IS_INVALID); // 返回参数无效的错误结果
        }
        resource =  resourceService.addResource(resource, file); // 调用ResourceService的addResource方法添加资源
        return handleResult(new ResourceDTO().convertFor(resource)); // 处理结果并返回转换后的ResourceDTO对象
    }

    @ApiOperation(value = "删除资源") // 使用ApiOperation注解，定义接口操作为"删除资源"
    @LogAnnotation(operation = "删除资源") // 记录删除资源操作日志
    @DeleteMapping("/delete/{id}") // 映射DELETE请求，路径中包含资源ID
    public Result deleteResource(@PathVariable String id) throws IOException { // 定义删除资源的方法，接收资源ID作为参数
        Resource resource = resourceService.selectResourceByResId(id);
//        System.out.println(resource.toString());
        ResourcesEntity entity = new ResourcesEntity();
        entity.setResName(resource.getResName());
        entity.setCourseId(resource.getCourseId());
//        获取mongo中所存的所有为该资源名资源路径
        List<ResourcesEntity> list1 = resourcesRepository.findAll(Example.of(entity));
//        根据文件path和courceId删除文件和mongo记录
        for(ResourcesEntity item : list1){
            FileUtils.deleteFile(item.getDownLinkPath());
            resourcesRepository.delete(item);
        }
        return handleResult(resourceService.deleteByExId(id)); // 处理结果并返回ResourceService的deleteByExId方法删除资源
    }
}