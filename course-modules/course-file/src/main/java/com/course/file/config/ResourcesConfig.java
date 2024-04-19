package com.course.file.config; // 声明这个 Java 文件所在的包路径

import java.io.File; // 导入 Java 的 File 类
import org.springframework.beans.factory.annotation.Value; // 导入 Spring 的 Value 注解
import org.springframework.context.annotation.Configuration; // 导入 Spring 的 Configuration 注解
import org.springframework.web.servlet.config.annotation.CorsRegistry; // 导入 Spring 的 CorsRegistry 类
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry; // 导入 Spring 的 ResourceHandlerRegistry 类
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer; // 导入 Spring 的 WebMvcConfigurer 接口

/**
 * 通用映射配置
 *
 * @author course
 */
@Configuration // 声明这是一个配置类，Spring 会在启动时加载并处理这个类
public class ResourcesConfig implements WebMvcConfigurer // 实现 WebMvcConfigurer 接口
{
    /**
     * 上传文件存储在本地的根路径
     */
    @Value("${file.path}") // 使用 Value 注解，从配置文件中读取名为 "file.path" 的属性值并注入到 localFilePath 字段中
    private String localFilePath; // 声明一个私有属性 localFilePath，用于存储本地上传文件的根路径

    /**
     * 资源映射路径 前缀
     */
    @Value("${file.prefix}") // 使用 Value 注解，从配置文件中读取名为 "file.prefix" 的属性值并注入到 localFilePrefix 字段中
    public String localFilePrefix; // 声明一个公共属性 localFilePrefix，用于存储资源映射路径的前缀

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) // 实现 WebMvcConfigurer 接口的方法，用于配置资源处理器
    {
        /** 本地文件上传路径 */ // 注释说明本地文件上传路径
        registry.addResourceHandler(localFilePrefix + "/**") // 添加资源处理器，指定资源映射路径前缀
                .addResourceLocations("file:" + localFilePath + File.separator); // 设置资源的本地存储路径
    }

    /**
     * 开启跨域
     */
    @Override
    public void addCorsMappings(CorsRegistry registry) { // 实现 WebMvcConfigurer 接口的方法，用于配置跨域访问
        // 设置允许跨域的路由
        registry.addMapping(localFilePrefix  + "/**") // 添加跨域映射路径
                // 设置允许跨域请求的域名
                .allowedOrigins("*") // 允许所有域名跨域访问
                // 设置允许的方法
                .allowedMethods("GET"); // 允许 GET 方法跨域访问
    }
}