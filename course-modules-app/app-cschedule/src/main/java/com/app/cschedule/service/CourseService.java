package com.app.cschedule.service;

import com.app.cschedule.common.support.IService;
import com.app.cschedule.entity.Course;
import com.app.cschedule.model.CourseDTO;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

public interface CourseService extends IService<Course> {

    /**
     * 获取用户所有课程
     * @param id 用户exId
     */
    List<Course> getAllCourses(String id);

    /**
     * 获取课程详情 包括课程里的资源等
     * @param id 课程号
     */
    CourseDTO getCourseDetail(String id);

    /**
     * 按班号搜索课程
     * @param clazzNum
     */
    Course searchCourse(String clazzNum);

    Course searchCourseByCourseId(String courseId);


    /**
     * 创建课程
     */
    Course createCourse(Course course);

    /**
     * 删除课程
     */
    boolean deleteCourse(String id);

    /**
     * 开启关闭结课评分功能
     * @param id 课程号
     */
    boolean toggleAppraise(String id);

    /**
     * 上传课程封面
     * @param id 课程号
     * @param file 图片
     * @return 图片地址
     */
    String uploadPic(String id, MultipartFile file);
}
