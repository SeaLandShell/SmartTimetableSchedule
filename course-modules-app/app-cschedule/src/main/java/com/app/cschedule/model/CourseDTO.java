package com.app.cschedule.model; // 定义包名

import com.app.cschedule.common.util.FileUrlUtils; // 导入文件URL工具类
import com.app.cschedule.entity.Course; // 导入课程实体类
import com.app.cschedule.entity.Member; // 导入成员实体类
import com.app.cschedule.entity.Notice; // 导入通知实体类
import com.app.cschedule.entity.Resource; // 导入资源实体类
import com.google.common.base.Converter; // 导入Google Guava中的Converter类
import lombok.Data; // 导入Lombok中的Data注解
import org.springframework.beans.BeanUtils; // 导入Spring Framework中的BeanUtils类

import java.util.List; // 导入List类

@Data // 使用Lombok的Data注解，自动生成getter、setter等方法
public class CourseDTO { // 定义课程数据传输对象类
    private String courseId; // 课程ID
    private String courseNum; // 课程编号
    private String courseName; // 课程名称
    private String coursePic; // 课程图片
    private String clazzName; // 班级名称
    private String synopsis; // 简介
    private String term; // 学期
    private Integer arrivesNum; // 到课人数
    private Integer resourcesNum; // 资源数量
    private Integer experiencesNum; // 经验数量
    private boolean appraise; // 评价
    private Integer teacherId; // 教师ID
    private String teacherName; // 教师姓名
    private List<Member> members; // 成员列表
    private List<Resource> resources; // 资源列表
    private List<Notice> notices; // 通知列表

    // 需要获取服务器绝对地址
    public String getCoursePic() { // 获取课程图片的服务器绝对地址方法
        return FileUrlUtils.toServerUrl(coursePic); // 调用FileUrlUtils工具类将图片URL转换为服务器绝对地址
    }

    public Course convertToCourse(){ // 将CourseDTO转换为Course对象的方法
        CourseConverter courseConverter = new CourseConverter(); // 创建CourseConverter对象
        Course course = courseConverter.convert(this); // 调用CourseConverter的convert方法转换为Course对象
        return course; // 返回转换后的Course对象
    }

    public CourseDTO convertFor(Course course){ // 将Course对象转换为CourseDTO的方法
        CourseConverter courseConverter = new CourseConverter(); // 创建CourseConverter对象
        CourseDTO courseDto = courseConverter.reverse().convert(course); // 调用CourseConverter的reverse和convert方法转换为CourseDTO对象
        return courseDto; // 返回转换后的CourseDTO对象
    }

    private static class CourseConverter extends Converter<CourseDTO, Course> { // 定义内部静态类CourseConverter继承Converter<CourseDTO, Course>
        @Override
        protected Course doForward(CourseDTO courseDto) { // 实现doForward方法，将CourseDTO转换为Course
            Course course = new Course(); // 创建Course对象
            BeanUtils.copyProperties(courseDto, course); // 使用BeanUtils将属性复制到Course对象
            return course; // 返回转换后的Course对象
        }

        @Override
        protected CourseDTO doBackward(Course course) { // 实现doBackward方法，将Course转换为CourseDTO
            CourseDTO courseDto = new CourseDTO(); // 创建CourseDTO对象
            BeanUtils.copyProperties(course, courseDto); // 使用BeanUtils将属性复制到CourseDTO对象
            return courseDto; // 返回转换后的CourseDTO对象
        }
    }
}