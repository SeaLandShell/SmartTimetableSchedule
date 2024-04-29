package com.app.cschedule.controller;

import com.alibaba.nacos.shaded.com.google.gson.Gson;
import com.app.cschedule.common.annotation.LogAnnotation;
import com.app.cschedule.common.constant.LogType;
import com.app.cschedule.common.result.Result;
import com.app.cschedule.common.result.ResultCode;
import com.app.cschedule.common.support.BaseController;
import com.app.cschedule.entity.Course;
import com.app.cschedule.entity.Member;
import com.app.cschedule.entity.Resource;
import com.app.cschedule.mapper.ResourceMapper;
import com.app.cschedule.model.MemberDTO;
import com.app.cschedule.service.CourseService;
import com.app.cschedule.service.MemberService;
import com.app.cschedule.service.ResourceService;
import com.app.ctimetable.service.CalendarService;
import com.course.common.core.domain.R;
import com.course.common.redis.service.RedisService;
import com.course.common.security.annotation.InnerAuth;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import io.swagger.models.auth.In;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Objects;
import java.util.concurrent.TimeUnit;

@Api(tags = "班级成员管理")
@RestController
@RequestMapping("/members")
public class MemberController extends BaseController {
    @Autowired
    private MemberService memberService;
    @Autowired
    private RedisService redisService;

    @Autowired
    private ResourceMapper resourceMapper;
    @Autowired
    private ResourceService resourceService;
    @Autowired
    private CourseService courseService;

    @Autowired
    private CalendarService calendarService;

    @ApiOperation(value = "加入课程")
    @LogAnnotation(operation = "加入课程")
    @PostMapping
    public Result addMember(@RequestBody Member form) {
        if(memberService.addMember(form)>0){
            return handleResult(memberService.selectMember(form));
        }else{
            return handleResult(form).setMessage("当前已存在课程中！").setCode(1);
        }
    }

    @ApiOperation(value = "退出课程/删除成员")
    @LogAnnotation(operation = "退出课程/删除成员")
    @DeleteMapping("/{id}")
    public Result deleteMember(@PathVariable Long id) {
        return handleResult(memberService.deleteById(id));
    }

    @ApiOperation(value = "自定义退出课程/删除成员")
    @LogAnnotation(operation = "自定义退出课程/删除成员，不根据mybatis构建sql生成器来执行")
    @DeleteMapping("/customDelete")
    public Result customDeleteMember(@RequestBody Member member) {
        Course course = courseService.searchCourseByCourseId(member.getCourseId());
        System.out.println("该成员所在课程信息："+course.toString());
//      更新成员课表，若移除成员，则将课表对应课程的courseNum置为空
        System.out.println(member.getUserId());
        System.out.println(course.getTerm());
        System.out.println(calendarService.getCalendar(2,"2021-2022学年 第2学期"));
        String calendar = calendarService.getCalendar(member.getUserId(),course.getTerm());
        if(calendar==null){
            return handleResult(member).setMessage("该成员本学期本课程未导入课表，并不在课程内！").setCode(1);
        }
        System.out.println("查找到的calenddar："+calendar);
        Gson gson = new Gson();
        com.app.ctimetable.entity.Course[] coursesArray = gson.fromJson(calendar, com.app.ctimetable.entity.Course[].class);
        List<com.app.ctimetable.entity.Course> coursesList = Arrays.asList(coursesArray);
        for (com.app.ctimetable.entity.Course courseItem : coursesList) {
            if (courseItem.getName().equals(course.getCourseName())) {
                courseItem.setCourseNum("");
            }
        }
        String coursesListJson = gson.toJson(coursesList);
        System.out.println("更新后的对应成员的课程表："+coursesListJson);
        List<String> terms = new ArrayList<>();
        List<String> calendars = new ArrayList<>();
        terms.add(course.getTerm());
        calendars.add(coursesListJson);
        calendarService.updateCalendar(member.getUserId(),terms,calendars);
//        移除成员
        return handleResult(memberService.customDelete(member));
    }

    @ApiOperation(value = "结课评分")
    @LogAnnotation(operation = "结课评分")
    @PutMapping("/grade")
    public Result gradeStudent(@RequestBody MemberDTO form) {
        Member member = memberService.gradeStudent(form.convertToMember());
        return Result.success(new MemberDTO().convertFor(member));
    }

    @ApiOperation(value = "学生签到")
    @LogAnnotation(operation = "学生签到", exclude = {LogType.URL})
    @PostMapping("/attendance")
    public Result attendance(int userId, String courseId, int code) {
        Integer signCodeObj = redisService.getCacheObject("signCode"+courseId);
        Long timeMinuteObj = redisService.getCacheObject("timeMinute"+courseId);
        Long timeStream = redisService.getCacheObject("timeStream"+courseId);
        if(redisService.getCacheObject("startAttendance"+courseId)==null){
            return handleResult(null).setResultCode(ResultCode.ERROR).setMessage("签到已处于关闭状态！");
        }
        if(timeMinuteObj ==null){//等效于第一条判断，除非startAttendance时间设置不同，该判断生效
            return handleResult(null).setResultCode(ResultCode.ERROR).setMessage("签到已过时！");
        }
//        已签到的学生，提示”签到码错误“。   若要：已签到的学生即使签到码错误，也提示”已签到“，则注释该判断
        if (redisService.getCacheObject("signUserAttendance"+userId+courseId)!=null && code!=signCodeObj.intValue()) {
            return handleResult(null).setResultCode(ResultCode.ERROR).setMessage("签到码错误！");
        }
        if (redisService.getCacheObject("signUserAttendance"+userId+courseId)!=null) {
            return handleResult(null).setResultCode(ResultCode.ERROR).setMessage("已签到！");
        }
        int signCode = signCodeObj.intValue();
        if(code==signCode){
            Member member = memberService.selectMember(new Member().setUserId(userId).setCourseId(courseId));
            if(member.getArrive()==null){
                member.setArrive(1);
            }else{
                member.setArrive(member.getArrive()+1);
            }
            int ud = memberService.updateMember(member);
            if(ud>0){
                Long surPlusTime = timeStream.longValue()+timeMinuteObj.intValue()*60*1000-System.currentTimeMillis();
                redisService.setCacheObject("signUserAttendance"+userId+courseId,true,surPlusTime,TimeUnit.MILLISECONDS);
                return handleResult(memberService.selectMember(member));
            }
        }
        return handleResult(null).setResultCode(ResultCode.ERROR).setMessage("签到码错误");
    }

    @ApiOperation(value = "学生经验值")
    @LogAnnotation(operation = "学生经验值,同时更新资源总经验值", exclude = {LogType.URL})
    @PostMapping("/expirence")
    public Result expirence(int userId, String courseId,String resId) {
        Resource resource = resourceMapper.selectOne(new Resource().setResId(resId));
//        System.out.println("resourceSSSSSSSSSSSSS"+resource.toString());
        Member member = memberService.selectMember(new Member().setUserId(userId).setCourseId(courseId));
//        System.out.println("dddddddddddddddddddd"+member.toString());
        member.setExperience(member.getExperience()+1);
        int ud = memberService.updateMember(member);
        if(ud>0){
            resource.setExperience(resource.getExperience()+1);
            resourceService.updateResource(resource);
            // 唯一键记录当前用户在当前课程中浏览当前文件的唯一状态
            redisService.setCacheObject("learnStatus"+userId+courseId+resId,true);
//            System.out.println("rrrrrrrrrrrrrrrrrrrrrrrrrrr"+memberService.selectMember(member).toString());
            return handleResult(memberService.selectMember(member));
        }
        return handleResult(null).setResultCode(ResultCode.ERROR).setMessage("系统不知道去哪啦~");
    }

//    获取本人
    @ApiOperation(value = "获取本人")
    @LogAnnotation(operation = "获取本人信息", exclude = {LogType.URL})
    @PostMapping("/searchMemberByUserIdCourseId")
    public R<Member> searchMemberByUserIdCourseId(int userId, String courseId) {
        Member member = memberService.selectMember(new Member().setUserId(userId).setCourseId(courseId));
//        System.out.println("mmmmmmmmmmmmmmmmmmm"+member.toString());
        return R.ok(member, "本课程本成员");
    }

    @ApiOperation(value = "资源学习个数实时更新")
    @LogAnnotation(operation = "资源学习个数实时更新", exclude = {LogType.URL})
    @PostMapping("/resourceLearnCount")
    public R<Integer> resourceLearnCount(int userId, String courseId,String resId) {
        // 如果该用户对应该课程对应的资源没有学习过，则更新资源学习个数
        if(redisService.getCacheObject("learnStatus"+userId+courseId+resId)==null){
            if(redisService.getCacheObject("resourceLearnCount"+userId+courseId)==null){
                redisService.setCacheObject("resourceLearnCount"+userId+courseId,0);
            }
            Integer resourceLearnCount = redisService.getCacheObject("resourceLearnCount"+userId+courseId);
            redisService.setCacheObject("resourceLearnCount"+userId+courseId,resourceLearnCount.intValue()+1);
            return R.ok(resourceLearnCount.intValue(), "已学习资源数" + resourceLearnCount.intValue());
        }else{
            return R.fail();
        }
    }
    @ApiOperation(value = "资源学习个数")
    @LogAnnotation(operation = "资源学习个数", exclude = {LogType.URL})
    @GetMapping("/resourcehasLearnCount")
    public R<Integer> resourcehasLearnCount(int userId, String courseId) {
        Integer resourceLearnCount = redisService.getCacheObject("resourceLearnCount"+userId+courseId);
        if(resourceLearnCount==null){
            return R.fail("");
        }
        return R.ok(resourceLearnCount.intValue(), "已学习资源数" + resourceLearnCount.intValue());
    }
}