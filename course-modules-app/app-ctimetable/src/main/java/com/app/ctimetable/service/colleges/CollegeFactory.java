package com.app.ctimetable.service.colleges; // 声明包名com.app.ctimetable.service.colleges

import com.app.ctimetable.utils.TextUtils; // 导入TextUtils类
import org.springframework.beans.BeansException; // 导入BeansException类
import org.springframework.context.ApplicationContext; // 导入ApplicationContext类
import org.springframework.context.ApplicationContextAware; // 导入ApplicationContextAware接口
import org.springframework.stereotype.Component; // 导入Component注解

import java.util.*; // 导入java.util包

@Component // 标记为Spring组件
public class CollegeFactory implements ApplicationContextAware { // 定义CollegeFactory类并实现ApplicationContextAware接口
    private static final Map<String, College> collegeMap = new HashMap<>(); // 声明一个静态的Map类型的collegeMap，用于存储学校信息
    private static List<String> collegeNameList; // 声明一个静态的List类型的collegeNameList，用于存储学校名称列表

    // 静态方法，用于获取学校名称列表
    public static List<String> getCollegeNameList() {
        if (null == collegeNameList) { // 如果collegeNameList为null
            collegeNameList = new ArrayList<>(collegeMap.keySet()); // 初始化collegeNameList为collegeMap的键集合
            Collections.sort(collegeNameList); // 对学校名称列表进行排序
        }
        return collegeNameList; // 返回学校名称列表
    }

    // 静态方法，用于创建学校对象
    public static College createCollege(String collegeName) {
        return TextUtils.isEmpty(collegeName) ? null : collegeMap.get(collegeName); // 如果学校名称为空，则返回null，否则返回对应的学校对象
    }

    // 实现ApplicationContextAware接口的方法，用于设置ApplicationContext
    @Override
    public void setApplicationContext(ApplicationContext applicationContext) throws BeansException {
        applicationContext.getBeansOfType(College.class).values().forEach(college -> { // 获取所有College类型的bean，并对每个bean执行操作
            collegeMap.put(college.getCollegeName(), college); // 将学校名称和对应的学校对象放入collegeMap中
        });
    }
}




//College接口 (College.java):
//
//定义了学校的基本操作接口，包括获取学校名称、登录、获取课程、获取验证码、获取学期选项等方法。
//这个接口是用来规范不同学校实现的，每个学校都要实现这个接口，并提供自己特定的实现逻辑。
//BUUCollege实现类 (BUUCollege.java):
//
//实现了College接口，具体描述了北京联合大学的登录、获取课程、获取验证码等操作。
//包括了使用OkHttp发送HTTP请求，解析HTML页面获取所需信息等操作。
//提供了对应的URL地址常量和一些辅助方法。
//CollegeFactory工厂类 (CollegeFactory.java):
//
//实现了ApplicationContextAware接口，用于在Spring容器启动时，自动将所有实现了College接口的Bean加入到collegeMap中。
//提供了静态方法用于获取学校名称列表和根据学校名称创建对应的College对象。