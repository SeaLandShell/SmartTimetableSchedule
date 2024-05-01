package com.app.cuser.controller;

import com.app.cuser.domain.Program;
import com.app.cuser.mapper.ProgramMapper;
import com.course.common.core.domain.R;
import com.course.common.core.web.controller.BaseController;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import org.apache.commons.lang3.RandomStringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Api(tags = "日程管理")
@RestController
@RequestMapping("/program")
public class ProgramController  extends BaseController {
    @Autowired
    ProgramMapper programMapper;


    @ApiOperation(value = "添加日程")
    @PostMapping
    public R<Integer> addProgram(Integer userId,String title) {
//        System.out.println(userId.intValue()+title);
        return R.ok(programMapper.addProgram(RandomStringUtils.randomAlphanumeric(20),userId,title));
    }

    @ApiOperation(value = "查找日程")
    @GetMapping("/{userId}")
    public R<List<Program>> searchProgram(@PathVariable Integer userId) {
//        System.out.println(userId.intValue()+title);
        for (Program pp : programMapper.getProgramsByUserId(userId)){
            System.out.println(pp.toString());
        }
        return R.ok(programMapper.getProgramsByUserId(userId));
    }


}
