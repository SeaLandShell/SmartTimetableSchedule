package com.app.ctimetable.controller;

import com.app.ctimetable.utils.Utils;
import com.google.gson.Gson;
import com.google.gson.JsonSyntaxException;
import com.google.gson.reflect.TypeToken;
import com.app.ctimetable.annotations.PassAuth;
import com.app.ctimetable.entity.Course;
import com.app.ctimetable.model.ResponseWrap;
import com.app.ctimetable.model.ShareModel;
import com.app.ctimetable.service.CalendarService;
import com.app.ctimetable.utils.ListUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 获取课程表
 */
@RestController
@RequestMapping("/calendar")
public class CalendarController {
    private final Logger logger = LoggerFactory.getLogger(getClass());

    private final CalendarService calendarService;

    @Autowired
    public CalendarController(CalendarService calendarService) {
        this.calendarService = calendarService;
    }

    /**
     * 获取课程表
     *
     * @param term 学期
     * @return 课程表
     */
    @GetMapping("/getCalendar")
    public ResponseWrap<String> getCalendar(@RequestParam("userID") int userID, String term) {
        ResponseWrap<String> responseWrap = new ResponseWrap<>();
        responseWrap
                .setStatus(0).setData(calendarService.getCalendar(userID, term));
        return responseWrap;
    }


    /**
     * 分享课程表
     *
     * @param calendar 课程表json列表
     * @return
     */
    @PostMapping("/shareCalendar")
    @ResponseBody
    public ResponseWrap<ShareModel> sharedCalendar(int userID,
                                                   @RequestParam("calendar") String calendar) {
        ResponseWrap<ShareModel> responseWrap = new ResponseWrap<>();
        try {
            List<Course> list = new Gson().fromJson(calendar, new TypeToken<List<Course>>() {
            }.getType());
            if (ListUtils.isEmpty(list)) {
                return responseWrap.setStatus(1).setMsg("课程表为空");
            }
        } catch (JsonSyntaxException e) {
            logger.error(e.getMessage(), e);
            return responseWrap.setStatus(1).setMsg("课程表格式错误");
        }
        String key = calendarService.shareCalendar(userID, calendar);
        if (key.isEmpty()) {
            responseWrap.setStatus(1).setMsg("发生错误, 请重试");
        } else {
            String address = Utils.getIpAddress();
            responseWrap.setStatus(0).setMsg("分享成功!").setData(
                    new ShareModel(
                            key,
                            "http://" + address + ":8081" + "/ctimetable/calendar/getSharedCalendar?key=" + key,
                            "http://" + address + "/quick-access/" + key));
        }
        return responseWrap;
    }

    /**
     * 获取分享的课程表
     *
     * @param key 课程表的key
     * @return
     */
    @PassAuth
    @GetMapping("/getSharedCalendar")
    @ResponseBody
    public ResponseWrap<List<Course>> getSharedCalendar(String key) {

        ResponseWrap<List<Course>> responseWrap = new ResponseWrap<>();
        String calendar = calendarService.getSharedCalendar(key);
        if (calendar == null) {
            responseWrap.setStatus(1)
                    .setMsg("该课程表不存在");
        } else {
            responseWrap.setStatus(0)
                    .setMsg("获取课程成功")
                    .setData(new Gson().fromJson(calendar, new TypeToken<List<Course>>() {
                    }.getType()));
        }
        return responseWrap;
    }
}
