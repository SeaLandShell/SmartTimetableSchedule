package com.app.zfjwxt.controller;

import com.app.zfjwxt.entity.CourseBean;
import com.app.zfjwxt.service.HttpService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/zfcrawler")
public class CourseController {
    private HttpService httpService;

    @Autowired
    public CourseController(HttpService httpService) {
        this.httpService = httpService;
    }

    @GetMapping("DefaultCourseList")
    public List<CourseBean> getDefaultCourseList() {
        return httpService.queryStuCourseList(null, null);
    }

    @GetMapping("CourseList")
    public List<CourseBean> getScoreList(@RequestParam("xn") String xn, @RequestParam("xq") String xq) {
        return httpService.queryStuCourseList(xn, xq);
    }
}
