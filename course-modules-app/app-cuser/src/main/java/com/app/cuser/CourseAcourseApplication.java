package com.app.cuser;

import com.course.common.security.annotation.EnableCustomConfigToApp;
import com.course.common.security.annotation.EnableRyFeignClients;
import com.course.common.swagger.annotation.EnableCustomSwagger2;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

/**
 * 系统模块
 * 
 * @author Course
 */
@EnableCustomConfigToApp
@EnableCustomSwagger2
@EnableRyFeignClients
@SpringBootApplication
public class CourseAcourseApplication
{
    public static void main(String[] args)
    {
        SpringApplication.run(CourseAcourseApplication.class, args);
        System.out.println("(♥◠‿◠)ﾉﾞ  智课表用户模块启动成功   ლ(´ڡ`ლ)ﾞ  \n" +
                " .-------.       ____     __        \n" +
                " |  _ _   \\      \\   \\   /  /    \n" +
                " | ( ' )  |       \\  _. /  '       \n" +
                " |(_ o _) /        _( )_ .'         \n" +
                " | (_,_).' __  ___(_ o _)'          \n" +
                " |  |\\ \\  |  ||   |(_,_)'         \n" +
                " |  | \\ `'   /|   `-'  /           \n" +
                " |  |  \\    /  \\      /           \n" +
                " ''-'   `'-'    `-..-'              ");
    }
}
