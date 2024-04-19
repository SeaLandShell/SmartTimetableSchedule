package com.app.cuser.controller;

import com.alibaba.fastjson.JSON;
import com.aliyuncs.dysmsapi.model.v20170525.QuerySendDetailsResponse;
import com.aliyuncs.dysmsapi.model.v20170525.SendSmsResponse;
import com.app.cuser.domain.CourseUser;
import com.app.cuser.service.impl.AliyunSmsSenderServiceImpl;
import com.app.cuser.service.impl.CourseUserServiceImpl;
import com.course.common.core.web.controller.BaseController;
import com.course.common.core.web.domain.AjaxResult;
import io.swagger.v3.oas.annotations.Parameter;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.HashMap;
import java.util.Map;
import java.util.Random;

/**
 * @Author: LX 17839193044@162.com
 * @Description: 测试发送短信controller
 * @Date: 14:00 2019/4/18
 * @Version: V1.0
 */
@RestController
public class sendMessageController extends BaseController {
    @Autowired
    private CourseUserServiceImpl courseUserService;
    @Autowired
    private AliyunSmsSenderServiceImpl aliyunSmsSenderServiceImpl;
    private SendSmsResponse sendSmsResponse;

    /**
     * @Author: wxw qaz110258357@163.com
     * @Description: 短信发送
     * @Date: 2022/2/3 16:08
     * @Version: V1.0
     */
    @GetMapping("/sms")
    public AjaxResult sms(@Parameter(description = "get verifycode") String phone) {
//        User user = userService.getUserByUsername(username);
//        此部分由重置密码或注册账号的逻辑部分进行把关
//        if (user == null) {
//            status.setInfo("账号不存在");
//            return status;
////                return "账号错误";
//        }
        // 生成4位随机数字的验证码
        /*
        String netVerifycode= String.format("%04d", new Random().nextInt(9999));
        Map<String, String> map = new HashMap<>();
        map.put("code", netVerifycode);
        sendSmsResponse = aliyunSmsSenderServiceImpl.sendSms(phone,
                JSON.toJSONString(map),
                "SMS_269035264");
        //status.setInfo(JSON.toJSONString(sendSmsResponse));
        if(sendSmsResponse.getMessage().equals("OK")){
            return success(netVerifycode);
        }else {
            return error("验证码发送失败");
        }
        */
        return success("5251");
    }

    /**
     * @Author: LX 17839193044@162.com
     * @Description: 短信查询
     * @Date: 2019/4/18 16:08
     * @Version: V1.0
     */
    @GetMapping("/getSms")
    public AjaxResult query(@Parameter(description = "Query verification code") String phone) {
        CourseUser user = courseUserService.selectCourseUserByPhoneNumber(phone);
        if (user == null) {
            return error("账号不存在");
//                return "账号错误";
        }
        QuerySendDetailsResponse querySendDetailsResponse = aliyunSmsSenderServiceImpl.querySendDetails(sendSmsResponse.getBizId(),
                user.getUserName(), 10L, 1L);
        return success(querySendDetailsResponse.getMessage());
    }
}
