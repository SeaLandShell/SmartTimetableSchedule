package com.app.cuser.controller;

import com.app.cuser.domain.CourseUser;
import com.app.cuser.domain.LoginUserToApp;
import com.app.cuser.service.ICourseUserService;
import com.app.cuser.service.ValidateCodeService;
import com.app.cuser.service.impl.TokenServiceToApp;
import com.course.common.core.constant.Constants;
import com.course.common.core.domain.R;
import com.course.common.core.exception.ServiceException;
import com.course.common.core.web.controller.BaseController;
import com.course.common.core.web.domain.AjaxResult;
import com.course.common.log.annotation.Log;
import com.course.common.log.enums.BusinessType;
import com.course.common.security.utils.SecurityUtils;
import com.course.system.api.domain.SysUser;
import io.swagger.annotations.ApiResponse;
import io.swagger.annotations.ApiResponses;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import java.util.Objects;
import java.util.concurrent.TimeUnit;

@RestController
@RequestMapping("/acuser")
public class RegisterLoginController extends BaseController {
    @Autowired
    private ICourseUserService courseUserService;
    @Autowired
    private ValidateCodeService validateCodeService;
    @Autowired
    private TokenServiceToApp tokenServiceToApp;
    private static final Logger log = LoggerFactory.getLogger(RegisterLoginController.class);

    /**
     * 注册智课表用户
     */
    @Log(title = "智课表用户", businessType = BusinessType.INSERT)
    @PostMapping("/register")
    public AjaxResult add(String username,String phone,String password,String userType)
    {
        int usernamecount=courseUserService.getUserCountByPhoneNumber(phone);
        CourseUser courseUser=new CourseUser();
        courseUser.setUserName(username);
        courseUser.setPhonenumber(phone);
        courseUser.setPassword(SecurityUtils.encryptPassword(password));
        courseUser.setUserType(userType);
        if(usernamecount>0){
            return error("手机号已存在",courseUser);
        }
        if(toAjax(courseUserService.insertCourseUser(courseUser)).equals(success())){
            return success("注册成功",courseUser);
        }
        return error("未知错误原因",courseUser);
    }

    @Log(title = "智课表用户", businessType = BusinessType.OTHER)
    @ResponseBody
    @ApiResponses({ @ApiResponse(code = 200, message = "返回R<CourseUser>") })
    @PostMapping("/login")
    public R<CourseUser> login(String phone, String password, String code, String uuid)
    {
        int usernamecount=courseUserService.getUserCountByPhoneNumber(phone);
        AjaxResult ajax=validateCodeService.checkCaptchaToApp(code,uuid);
        String rep_msg= (String) ajax.get(AjaxResult.MSG_TAG);
        if(rep_msg!="验证码验证成功"){
            return R.fail(new CourseUser(phone),rep_msg);
        }
        if(usernamecount==0){
            return R.fail(new CourseUser(phone),"手机号不存在");
        }
        CourseUser user=courseUserService.selectCourseUserByPhoneNumber(phone);
        if (!matches(user, password))
        {
            return R.fail(new CourseUser(user.getPhonenumber()),"密码错误");
        }
        LoginUserToApp userInfo=new LoginUserToApp();
        userInfo.setCourseUser(user);
//        log.info(courseUserService.selectCourseUserByPhoneNumber(phone).toString());
        return R.ok(tokenServiceToApp.createToken(userInfo),user,"登录成功");
    }
    public boolean matches(CourseUser user, String rawPassword)
    {
        return SecurityUtils.matchesPassword(rawPassword, user.getPassword());
    }

    @Log(title = "智课表用户", businessType = BusinessType.UPDATE)
    @PostMapping("/updatePassword")
    public AjaxResult updatePassword(String phone,String password)
    {
        int usernamecount=courseUserService.getUserCountByPhoneNumber(phone);
        if(usernamecount==0){
            return error("手机号不存在",new Object());
        }else{
            CourseUser user=courseUserService.selectCourseUserByPhoneNumber(phone);
            user.setPassword(password);
            if(toAjax(courseUserService.updateCourseUser(user)).equals(success())){
                return success("更改成功",user);
            }
        }
        return error("未知错误",new Object());
    }
}
