package com.app.cschedule.controller;

import com.app.cschedule.common.annotation.LogAnnotation;
import com.app.cschedule.common.constant.LogType;
import com.app.cschedule.common.result.Result;
import com.app.cschedule.common.support.BaseController;
import com.app.cschedule.entity.Work;
import com.app.cschedule.service.WorkService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import org.apache.commons.lang3.RandomStringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Api(tags = "教师作业管理")
@RestController
@RequestMapping("/works")
public class WorkController extends BaseController {
    @Autowired
    private WorkService workService;

    @ApiOperation(value = "发布作业")
    @LogAnnotation(operation = "发布作业")
    @PostMapping
    public Result addWork(@RequestBody Work form) {
        Work hasWork = workService.selectWorkByCourseIdWorkName(form.getCourseId(), form.getWorkName());
        if(hasWork!=null){
            return handleResult(form).setMessage("当前命名作业已存在，请重新上传！").setCode(1);
        }
        form.setWorkId(RandomStringUtils.randomAlphanumeric(20));
        if(workService.addWork(form)>0){
            return handleResult(workService.selectWork(form));
        }else{
            return handleResult(form).setMessage("当前已存在作业列表中！").setCode(1);
        }
    }

    @ApiOperation(value = "获取作业详情") // 定义Swagger操作描述为"获取班级详情"
    @LogAnnotation(operation = "获取作业详情", exclude = {LogType.URL}) // 添加日志注解，操作为"获取班级详情"，排除URL日志类型
    @GetMapping("/{id}") // 定义GET请求映射路径为"/{id}"
    public Result getCourseDetail(@PathVariable String id) { // 定义获取课程详情方法，参数为路径变量id
        List<Work> works = workService.getWorksByCourseId(id); // 调用课程服务类的获取课程详情方法
        return Result.success(works); // 返回成功结果
    }

    @ApiOperation(value = "教师删除作业")
    @LogAnnotation(operation = "教师删除作业")
    @DeleteMapping("/workDelete")
    public Result workDelete(@RequestBody Work work) {
        if(workService.delete(work)>0){
            return handleResult(1);
        }
        return handleResult(work).setMessage("删除失败！").setCode(1);
    }

    @ApiOperation(value = "更改作业") // 定义Swagger操作描述为"获取班级详情"
    @LogAnnotation(operation = "更改作业详情", exclude = {LogType.URL}) // 添加日志注解，操作为"获取班级详情"，排除URL日志类型
    @PostMapping("/update") // 定义GET请求映射路径为"/{id}"
    public Result updateCourseDetail(@RequestBody Work work) { // 定义获取课程详情方法，参数为路径变量id
        return Result.success(workService.updateByExId(work)); // 返回成功结果
    }

    @ApiOperation(value = "删除作业")
    @LogAnnotation(operation = "删除作业")
    @DeleteMapping("/delete")
    public Result deleteWork(@PathVariable String id) {
        return handleResult(workService.delete(new Work().setWorkId(id)));
    }


}