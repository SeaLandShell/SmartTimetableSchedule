package com.app.cschedule.controller; // 定义包名

import com.app.cschedule.common.annotation.LogAnnotation; // 导入日志注解类
import com.app.cschedule.common.constant.LogType; // 导入日志类型常量类
import com.app.cschedule.common.result.Result; // 导入结果类
import com.app.cschedule.common.support.BaseController; // 导入基础控制器类
import com.app.cschedule.model.CourseDTO; // 导入课程DTO类
import com.app.cschedule.service.CourseService; // 导入课程服务类
import com.course.common.core.constant.Constants;
import com.course.common.core.domain.R;
import com.course.common.core.web.domain.AjaxResult;
import com.course.common.redis.service.RedisService;
import io.swagger.annotations.Api; // 导入Swagger注解Api
import io.swagger.annotations.ApiOperation; // 导入Swagger注解ApiOperation
import org.springframework.beans.factory.annotation.Autowired; // 导入自动装配注解Autowired
import org.springframework.web.bind.annotation.*; // 导入Web注解

import java.util.Random;
import java.util.concurrent.TimeUnit;

@Api(tags = "班级管理") // 定义Swagger标签为"班级管理"
@RequestMapping("/classes") // 定义请求映射路径为"/api/v1/classes"
@RestController // 定义为REST控制器
public class ClazzController extends BaseController { // 定义班级控制器类继承基础控制器类
    @Autowired // 自动装配课程服务类
    private CourseService courseService; // 课程服务类对象
    @Autowired
    private RedisService redisService;

    @ApiOperation(value = "获取班级详情") // 定义Swagger操作描述为"获取班级详情"
    @LogAnnotation(operation = "获取班级详情", exclude = {LogType.URL}) // 添加日志注解，操作为"获取班级详情"，排除URL日志类型
    @GetMapping("/{id}") // 定义GET请求映射路径为"/{id}"
    public Result getCourseDetail(@PathVariable String id) { // 定义获取课程详情方法，参数为路径变量id
        CourseDTO course = courseService.getCourseDetail(id); // 调用课程服务类的获取课程详情方法
        return Result.success(course); // 返回成功结果
    }

    @ApiOperation(value = "解散班级") // 定义Swagger操作描述为"解散班级"
    @LogAnnotation(operation = "解散班级") // 添加日志注解，操作为"解散班级"
    @DeleteMapping("/{id}") // 定义DELETE请求映射路径为"/{id}"
    public Result deleteCourse(@PathVariable String id) { // 定义解散班级方法，参数为路径变量id
        return handleResult(courseService.deleteCourse(id)); // 处理并返回课程服务类的解散班级结果
    }
    @ApiOperation(value = "发起签到码") // 定义Swagger操作描述为"获取班级详情"
//    应该把courseId带上，学生签到时予以校验
    @LogAnnotation(operation = "发起签到码", exclude = {LogType.URL}) // 添加日志注解，操作为"获取班级详情"，排除URL日志类型
    @GetMapping("/signCode") // 定义GET请求映射路径为"/{id}"
    public R<Integer> signCode(Long timeMinute,String courseId) { // 定义获取课程详情方法，参数为路径变量id
        if(redisService.getCacheObject("attendance_count"+courseId)==null){
            redisService.setCacheObject("attendance_count"+courseId,0);
        }
        Integer attendance_count = redisService.getCacheObject("attendance_count"+courseId);
        Random random = new Random();
        int randomNumber = 100000 + random.nextInt(900000);
        redisService.setCacheObject("startAttendance"+courseId,true,timeMinute,TimeUnit.MINUTES);
        redisService.setCacheObject("timeMinute"+courseId,timeMinute,timeMinute,TimeUnit.MINUTES);
        redisService.setCacheObject("signCode"+courseId, randomNumber, timeMinute, TimeUnit.MINUTES);
        redisService.setCacheObject("timeStream" + courseId, System.currentTimeMillis(), timeMinute, TimeUnit.MINUTES);
        redisService.setCacheObject("attendance_count"+courseId,attendance_count.intValue()+1);
        return R.ok(randomNumber,"签到码申领成功"); // 返回成功结果
    }
    @ApiOperation(value = "发起签到总次数") // 定义Swagger操作描述为"获取班级详情"
//    应该把courseId带上，学生签到时予以校验
    @LogAnnotation(operation = "发起签到总次数", exclude = {LogType.URL}) // 添加日志注解，操作为"获取班级详情"，排除URL日志类型
    @GetMapping("/signCount") // 定义GET请求映射路径为"/{id}"
    public R<Integer> signCount(String courseId) { // 定义获取课程详情方法，参数为路径变量id
        Integer attendance_counts = redisService.getCacheObject("attendance_count"+courseId);
        if (attendance_counts == null) {
            return R.fail(1, "");
        }
        return R.ok(attendance_counts.intValue(), "发起签到总次数" + attendance_counts.intValue());
    }
}