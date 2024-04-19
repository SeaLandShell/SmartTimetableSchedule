package com.app.ctimetable.controller;

import com.app.ctimetable.annotations.PassAuth;
import com.app.ctimetable.model.ResponseWrap;
import com.app.ctimetable.service.colleges.CollegeFactory;
import org.slf4j.LoggerFactory;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;


/**
 * 学校列表
 */
@CrossOrigin
@RestController
public class CollegeListController {
    /**
     * 获取学校列表
     *
     * @return
     */
    @GetMapping("/collegeList")
    public ResponseWrap<List<String>> getCollegeList() {
        LoggerFactory.getLogger(getClass()).info("学校是："+CollegeFactory.getCollegeNameList());
        return new ResponseWrap<List<String>>()
                .setStatus(0)
                .setMsg("目前匹配的学校就这些！")
                .setData(CollegeFactory.getCollegeNameList());
    }
}
