package com.app.zfjwxt.controller;

import com.app.zfjwxt.entity.ScoreBean;
import com.app.zfjwxt.service.HttpService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/zfcrawler")
public class ScoreController {
    private HttpService httpService;

    @Autowired
    public ScoreController(HttpService httpService) {
        this.httpService = httpService;
    }

    @GetMapping("DefaultScoreList")
    public List<ScoreBean> getDefaultScoreList() {
        // 请登录教务系统，查看成绩查询功能时候开放
        return httpService.queryStuGrade(null, null);
    }

    @GetMapping("ScoreList")
    public List<ScoreBean> getScoreList(@RequestParam("xn") String xn, @RequestParam("xq") String xq) {
        return httpService.queryStuGrade2(xn, xq);
    }
}
