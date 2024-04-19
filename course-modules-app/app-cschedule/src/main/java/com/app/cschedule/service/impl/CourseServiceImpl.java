package com.app.cschedule.service.impl; // 声明包名为com.app.cschedule.service.impl

import com.app.cschedule.common.support.BaseService; // 导入BaseService类
import com.app.cschedule.common.util.FileUtils; // 导入FileUtils工具类
import com.app.cschedule.mapper.CourseMapper; // 导入CourseMapper接口
import com.app.cschedule.mapper.MemberMapper; // 导入MemberMapper接口
import com.app.cschedule.mapper.NoticeMapper; // 导入NoticeMapper接口
import com.app.cschedule.mapper.ResourceMapper; // 导入ResourceMapper接口
import com.app.cschedule.entity.Course; // 导入Course类
import com.app.cschedule.entity.Member; // 导入Member类
import com.app.cschedule.entity.Notice; // 导入Notice类
import com.app.cschedule.entity.Resource; // 导入Resource类
import com.app.cschedule.model.CourseDTO; // 导入CourseDTO类
import com.app.cschedule.service.CourseService; // 导入CourseService接口
import org.apache.commons.lang3.RandomStringUtils; // 导入RandomStringUtils类
import org.springframework.beans.factory.annotation.Autowired; // 导入@Autowired注解
import org.springframework.stereotype.Service; // 导入@Service注解
import org.springframework.transaction.annotation.Transactional; // 导入@Transactional注解
import org.springframework.web.multipart.MultipartFile; // 导入MultipartFile类

import java.text.DateFormat; // 导入DateFormat类
import java.text.SimpleDateFormat; // 导入SimpleDateFormat类
import java.util.Date; // 导入Date类
import java.util.List; // 导入List类

@Service // 声明为Spring的Service类
public class CourseServiceImpl extends BaseService<Course> implements CourseService { // 定义CourseServiceImpl类，继承BaseService<Course>类，实现CourseService接口

    @Autowired // 自动注入
    private CourseMapper courseMapper; // 声明CourseMapper类型的私有变量courseMapper
    @Autowired // 自动注入
    private MemberMapper memberMapper; // 声明MemberMapper类型的私有变量memberMapper
    @Autowired // 自动注入
    private NoticeMapper noticeMapper; // 声明NoticeMapper类型的私有变量noticeMapper
    @Autowired // 自动注入
    private ResourceMapper resourceMapper; // 声明ResourceMapper类型的私有变量resourceMapper

    @Override // 重写父类或接口的方法
    public List<Course> getAllCourses(String userId) { // 定义getAllCourses方法，参数为userId
        List<Course> joinList = courseMapper.joinList(userId); // 调用courseMapper的joinList方法，传入userId参数，将结果赋给joinList
        joinList.addAll(courseMapper.createList(userId)); // 将courseMapper的createList方法结果添加到joinList中
        return joinList; // 返回joinList
    }

    @Override // 重写父类或接口的方法
    public CourseDTO getCourseDetail(String clazzId) { // 定义getCourseDetail方法，参数为clazzId
        return courseMapper.getCourseDetail(clazzId); // 调用courseMapper的getCourseDetail方法，传入clazzId参数，返回结果
    }

    @Override // 重写父类或接口的方法
    public Course searchCourse(String courseNum) { // 定义searchCourse方法，参数为courseNum
        return courseMapper.selectOne(new Course().setCourseNum(courseNum)); // 调用courseMapper的selectOne方法，传入设置了courseNum的Course对象，返回结果
    }

    @Override // 重写父类或接口的方法
    public Course createCourse(Course course) { // 定义createCourse方法，参数为course
        String cId = RandomStringUtils.randomAlphanumeric(20); // 生成长度为20的随机字母数字字符串作为cId
        course.setCourseId(cId); // 设置course的courseId为cId
        course.setCourseNum(RandomStringUtils.randomNumeric(6)); // 生成长度为6的随机数字字符串作为courseNum
        course.setCoursePic("public/pic_default.jpeg"); // 设置course的coursePic为默认图片路径
        courseMapper.insert(course); // 插入course到数据库
        return courseMapper.selectByExId(cId); // 返回根据cId查询的Course对象
    }

    @Override // 重写父类或接口的方法
    @Transactional(rollbackFor = Exception.class) // 声明事务管理，遇到异常回滚
    public boolean deleteCourse(String id) { // 定义deleteCourse方法，参数为id
        memberMapper.delete(new Member().setCourseId(id)); // 删除关联的Member记录
        resourceMapper.delete(new Resource().setCourseId(id)); // 删除关联的Resource记录
        noticeMapper.delete(new Notice().setCourseId(id)); // 删除关联的Notice记录
        courseMapper.deleteByExId(id); // 根据id删除Course记录
        return true; // 返回true
    }

    @Override // 重写父类或接口的方法
    public boolean toggleAppraise(String id) { // 定义toggleAppraise方法，参数为id
        Course course = courseMapper.selectByExId(id); // 根据id查询Course对象
        // 更新数据库
        Course tmp = new Course(); // 创建临时Course对象tmp
        tmp.setCourseId(id); // 设置tmp的courseId为id
        tmp.setAppraise(!course.getAppraise()); // 取反设置tmp的Appraise属性
        courseMapper.updateByExId(tmp); // 根据id更新Course记录
        return tmp.getAppraise(); // 返回更新后的Appraise属性值
    }

    @Override // 重写父类或接口的方法
    public String uploadPic(String id, MultipartFile file) { // 定义uploadPic方法，参数为id和MultipartFile类型的file
        DateFormat format = new SimpleDateFormat("yyyyMMddHHmmss"); // 创建日期格式化对象
        String fileName = "pic_" + format.format(new Date()) + ".jpeg"; // 根据当前日期生成文件名
        String path = FileUtils.storeFile(file, fileName, FileUtils.getUserPath(id)); // 调用FileUtils的storeFile方法存储文件，获取文件路径
        // 存入数据库
        Course course = new Course(); // 创建Course对象
        course.setCourseId(id); // 设置course的courseId为id
        course.setCoursePic(path); // 设置course的coursePic为文件路径
        courseMapper.updateByExId(course); // 更新数据库中的Course记录
        return path; // 返回文件路径
    }
}