package com.app.cschedule.controller; // 定义包名

import com.app.cschedule.common.annotation.LogAnnotation; // 导入日志注解类
import com.app.cschedule.common.constant.LogType; // 导入日志类型常量类
import com.app.cschedule.common.result.Result; // 导入结果类
import com.app.cschedule.common.support.BaseController; // 导入基础控制器类
import com.app.cschedule.common.util.FileUrlUtils; // 导入文件URL工具类
import com.app.cschedule.entity.Course; // 导入课程实体类
import com.app.cschedule.model.CourseDTO; // 导入课程DTO类
import com.app.cschedule.service.CourseService; // 导入课程服务类
import io.swagger.annotations.Api; // 导入Swagger注解Api
import io.swagger.annotations.ApiOperation; // 导入Swagger注解ApiOperation
import org.springframework.beans.factory.annotation.Autowired; // 导入自动装配注解Autowired
import org.springframework.web.bind.annotation.*; // 导入Web注解
import org.springframework.web.multipart.MultipartFile; // 导入Spring文件上传类

import java.util.List; // 导入Java集合List类

@Api(tags = "课程管理") // 定义Swagger标签为"课程管理"
@RequestMapping("/schedule") // 定义请求映射路径为"/api/v1"
@RestController // 定义为REST控制器
public class CourseController extends BaseController { // 定义课程控制器类继承基础控制器类
    @Autowired // 自动装配课程服务类
    private CourseService courseService; // 课程服务类对象

    @ApiOperation(value = "获取用户所有课程") // 定义Swagger操作描述为"获取用户所有课程"
    @LogAnnotation(operation = "获取用户所有课程", exclude = {LogType.URL}) // 添加日志注解，操作为"获取用户所有课程"，排除URL日志类型
    @GetMapping("/{userId}/courses") // 定义GET请求映射路径为"/{userId}/courses"
    public Result getAllCourses(@PathVariable String userId) { // 定义获取所有课程方法，参数为路径变量userId
        List<Course> courses = courseService.getAllCourses(userId); // 调用课程服务类的获取所有课程方法
        return Result.success(courses); // 返回成功结果
    }

    @ApiOperation(value = "按班课搜索课程") // 定义Swagger操作描述为"按班课搜索课程"
    @LogAnnotation(operation = "按班课搜索课程") // 添加日志注解，操作为"按班课搜索课程"
    @GetMapping("/courses/{num}") // 定义GET请求映射路径为"/courses/{num}"
    public Result searchCourse(@PathVariable String num) { // 定义搜索课程方法，参数为路径变量num
        Course course = courseService.searchCourse(num); // 调用课程服务类的搜索课程方法
        return Result.success(course); // 返回成功结果
    }

    @ApiOperation(value = "创建课程") // 定义Swagger操作描述为"创建课程"
    @LogAnnotation(operation = "创建课程") // 添加日志注解，操作为"创建课程"
    @PostMapping("/courses") // 定义POST请求映射路径为"/courses"
    public Result createCourse(@RequestBody Course form) { // 定义创建课程方法，参数为请求体Course对象
        Course course = courseService.createCourse(form); // 调用课程服务类的创建课程方法
        return handleResult(new CourseDTO().convertFor(course)); // 处理并返回转换后的课程DTO对象
    }

    @ApiOperation(value = "开启/关闭评分") // 定义Swagger操作描述为"开启/关闭评分"
    @LogAnnotation(operation = "开启/关闭评分") // 添加日志注解，操作为"开启/关闭评分"
    @PutMapping("/courses/appraise/{id}") // 定义PUT请求映射路径为"/courses/appraise/{id}"
    public Result toggleAppraise(@PathVariable String id) { // 定义开启/关闭评分方法，参数为路径变量id
        boolean appraise = courseService.toggleAppraise(id); // 调用课程服务类的开启/关闭评分方法
        return  Result.success(appraise); // 返回成功结果
    }

    @ApiOperation(value = "更换班级图片") // 定义Swagger操作描述为"更换班级图片"
    @LogAnnotation(operation = "更换班级图片") // 添加日志注解，操作为"更换班级图片"
    @PostMapping("/courses/photo/{id}") // 定义POST请求映射路径为"/courses/photo/{id}"
    public Result uploadPic(@PathVariable String id, @RequestParam("file") MultipartFile file) { // 定义上传图片方法，参数为路径变量id和文件对象file
        String path = courseService.uploadPic(id, file); // 调用课程服务类的上传图片方法
        return Result.success(FileUrlUtils.toServerUrl(path)); // 返回成功结果，将路径转换为服务器URL
    }
}