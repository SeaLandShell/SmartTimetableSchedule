package com.app.zfjwxt.controller;

import com.app.zfjwxt.entity.HttpBean;
import com.app.zfjwxt.entity.User;
import com.app.zfjwxt.service.HttpService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

@RestController
@RequestMapping("/zfcrawler")
public class LoginController {
    private static final Logger log = LoggerFactory.getLogger(LoginController.class);
    private HttpService httpService;

    @Autowired
    public LoginController(HttpService httpService) {
        this.httpService = httpService;
    }
    @GetMapping("/codeImgWeComLogin")
    public String sendCodeImgWeComLogin(){
        // 初始化
        httpService.init();
        return httpService.getBase64WeComImgSrc();
    }
    @PostMapping("/login")
    public String login(User user, HttpServletRequest requeset) {
        log.info("user:"+user.toString());
        String loginResult = httpService.login(user);
        log.info("loginresult:"+loginResult);
        while (loginResult.equals("验证码不正确！！")) {
            System.out.println("开始陷入验证码请求循环！");
            loginResult = httpService.login(user);
        }
        return loginResult;
    }
}
