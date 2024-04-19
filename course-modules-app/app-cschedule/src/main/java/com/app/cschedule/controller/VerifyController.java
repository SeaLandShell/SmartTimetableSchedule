package com.app.cschedule.controller;

import com.app.cschedule.common.annotation.LogAnnotation;
import com.app.cschedule.common.result.Result;
import com.app.cschedule.common.result.ResultCode;
import com.app.cschedule.service.impl.EmailService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import org.apache.commons.lang3.RandomStringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import springfox.documentation.annotations.ApiIgnore;

import java.util.concurrent.TimeUnit;

@RestController
//@ApiIgnore
@Api(tags = "邮箱管理")
@RequestMapping("/email")
public class VerifyController {
    @Autowired
    private EmailService emailService;
    @Autowired
    private StringRedisTemplate stringRedisTemplate;

    @ApiOperation(value = "注册账号邮件")
    @LogAnnotation(operation = "注册账号邮件")
    @GetMapping("/register/{toAddr}")
    public Result getRegisterEmail(@PathVariable String toAddr) {
//        if(userService.findUserByAccount(toAddr) != null) {
//            return Result.error(ResultCode.USER_HAS_EXISTED);
//        }
        String verifyCode = RandomStringUtils.randomNumeric(6);
        stringRedisTemplate.opsForValue().set(toAddr, verifyCode, 60*5, TimeUnit.SECONDS);
        emailService.sendTextMail(toAddr,"云课堂：注册账号","验证码为：" + verifyCode + "(5分钟有效)");
        return Result.success();
    }

    @ApiIgnore
    @ApiOperation(value = "修改邮箱邮件")
    @LogAnnotation(operation = "修改邮箱邮件")
    @GetMapping("/update/{toAddr}")
    public Result getUpdateEmail(@PathVariable String toAddr) {
//        if(userService.findUserByAccount(toAddr) != null) {
//            return Result.error(ResultCode.USER_HAS_EXISTED);
//        }
        String verifyCode = RandomStringUtils.randomNumeric(6);
        stringRedisTemplate.opsForValue().set(toAddr, verifyCode, 60*5, TimeUnit.SECONDS);
        emailService.sendTextMail(toAddr,"云班课：修改邮箱","验证码为：" + verifyCode + "(5分钟有效)");
        return Result.success();
    }

    @ApiIgnore
    @ApiOperation(value = "重置密码邮件")
    @LogAnnotation(operation = "重置密码邮件")
    @GetMapping("/forget/{toAddr}")
    public Result getForgetEmail(@PathVariable String toAddr) {
//        if(userService.findUserByAccount(toAddr) == null) {
//            return Result.error(ResultCode.USER_NOT_EXIST);
//        }
        String verifyCode = RandomStringUtils.randomNumeric(6);
        stringRedisTemplate.opsForValue().set(toAddr, verifyCode, 60*5, TimeUnit.SECONDS);
        emailService.sendTextMail(toAddr,"云班课：重置密码","验证码为：" + verifyCode + "(5分钟有效)");
        return Result.success();
    }
}