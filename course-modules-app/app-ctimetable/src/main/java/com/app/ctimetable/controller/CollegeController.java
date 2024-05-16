package com.app.ctimetable.controller;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import com.app.ctimetable.entity.Course;
import com.app.ctimetable.model.ResponseWrap;
import com.app.ctimetable.model.college.RandomImg;
import com.app.ctimetable.service.CalendarService;
import com.app.ctimetable.service.colleges.College;
import com.app.ctimetable.service.colleges.CollegeFactory;
import com.app.ctimetable.utils.RedisUtil;
import com.app.ctimetable.utils.TextUtils;
import org.jetbrains.annotations.NotNull;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.*;

import java.util.*;

/**
 * 教务系统接口
 */
@RestController
@RequestMapping("/college")
public class CollegeController {

    private final Logger logger = LoggerFactory.getLogger(getClass());
    private final CalendarService calendarService;
    private final RedisUtil redisUtil;
    List<String> termType = new LinkedList<>();

    @Autowired
    public CollegeController(CalendarService calendarService, RedisUtil redisUtil) {
        this.calendarService = calendarService;
        this.redisUtil = redisUtil;
    }

    /**
     * 获取验证码长度
     *
     * @param collegeName
     * @return
     */
    @GetMapping("/random-code-length")
    public ResponseWrap<Integer> getRandomCodeLength(@RequestParam("collegeName") String collegeName) {
        ResponseWrap<Integer> resp = new ResponseWrap<>();
        College college = CollegeFactory.createCollege(collegeName);
        if (college == null) {
            return resp.setStatus(1)
                    .setMsg("暂不支持" + collegeName);
        } else {
            return resp.setStatus(0)
                    .setData(college.getRandomCodeMaxLength());
        }

    }

    /**
     * 获取验证码
     *
     * @return
     */
    @GetMapping("/random-img-base64")
    public ResponseWrap<RandomImg> getRandomImgBase64(@RequestParam("collegeName") String collegeName, @RequestParam("userID") int userID) {
        College college = CollegeFactory.createCollege(collegeName);
        if (college == null) {
            return ResponseWrap.error("暂不支持" + collegeName);
        }
        ResponseWrap<RandomImg> responseWrap = new ResponseWrap<>();
        byte[] img = new byte[0];
        String base64 = Base64.getMimeEncoder()
                .encodeToString(college.getRandomCodeImg(String.valueOf(img)));
        responseWrap.setData(new RandomImg(base64));
        responseWrap.setStatus(0);
        if (TextUtils.isEmpty(base64)) {
            logger.error("没有获取到验证码");
            responseWrap.setStatus(1);
            responseWrap.setMsg("没有获取到验证码");
        } else {
            responseWrap.setStatus(0);
        }

        return responseWrap;
    }

    @PostMapping("/addCalendar")
    public ResponseWrap<Boolean> addCalendar(@RequestBody Map<String, Object> requestBody){
        int userID = (int) requestBody.get("userID");
        List<String> terms = (List<String>) requestBody.get("terms");
        List<String> courses = (List<String>) requestBody.get("courses");
        ResponseWrap<Boolean> responseWrap = new ResponseWrap<>();
        int size = calendarService.updateCalendar(userID, terms, courses);
        if (size <= 0) {
            responseWrap.setData(false).setMsg("该课表已存在");
        }else {
            responseWrap.setData(true).setMsg("导入课程表成功").setStatus(0);
        }
        return responseWrap;
    }

    /**
     * 获取学期选项
     *
     * @return
     */
    @GetMapping("/term-options")
    public ResponseWrap<List<String>> getTermOptions(int userID) {
        ResponseWrap<List<String>> resp = new ResponseWrap<>();
        List<String> termOptions = calendarService.getTerms(userID);
        if (termOptions.size() <= 0) {
            resp.setStatus(1)
                    .setMsg("请先登录教务系统！");
        } else {
            resp.setStatus(0)
                    .setData(termOptions);
        }
        return resp;
    }

    /**
     * 获取课程表
     *
     * @param term 学期
     * @return
     */
    @GetMapping("/timetable")
    public ResponseWrap<List<Course>> getCourses(@RequestParam("term") String term,
                                                 @RequestParam("userID") int userID
    ) {
        ResponseWrap<List<Course>> resp = new ResponseWrap<>();
        System.out.println(calendarService.getCalendar(userID, term));
        return resp.setStatus(0)
                .setData(new Gson().fromJson(calendarService.getCalendar(userID, term), new TypeToken<List<Course>>() {
                }.getType()));
    }
}
