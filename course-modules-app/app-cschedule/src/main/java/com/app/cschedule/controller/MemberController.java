package com.app.cschedule.controller;

import com.app.cschedule.common.annotation.LogAnnotation;
import com.app.cschedule.common.result.Result;
import com.app.cschedule.common.support.BaseController;
import com.app.cschedule.entity.Member;
import com.app.cschedule.model.MemberDTO;
import com.app.cschedule.service.MemberService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@Api(tags = "班级成员管理")
@RestController
@RequestMapping("/members")
public class MemberController extends BaseController {
    @Autowired
    private MemberService memberService;

    @ApiOperation(value = "加入课程")
    @LogAnnotation(operation = "加入课程")
    @PostMapping
    public Result addMember(@RequestBody Member form) {
        if(memberService.addMember(form)>0){
            return handleResult(memberService.selectMember(form));
        }
        return handleResult(form).setMessage("当前已在课程内或其他异常原因！");
    }

    @ApiOperation(value = "退出课程/删除成员")
    @LogAnnotation(operation = "退出课程/删除成员")
    @DeleteMapping("/{id}")
    public Result deleteMember(@PathVariable Long id) {
        return handleResult(memberService.deleteById(id));
    }

    @ApiOperation(value = "结课评分")
    @LogAnnotation(operation = "结课评分")
    @PutMapping("/grade")
    public Result gradeStudent(@RequestBody MemberDTO form) {
        Member member = memberService.gradeStudent(form.convertToMember());
        return Result.success(new MemberDTO().convertFor(member));
    }
}