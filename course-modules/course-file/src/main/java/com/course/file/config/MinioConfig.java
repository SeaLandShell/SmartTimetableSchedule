package com.course.file.config; // 声明这个 Java 文件所在的包路径

import org.springframework.boot.context.properties.ConfigurationProperties; // 导入 Spring Boot 的 ConfigurationProperties 注解
import org.springframework.context.annotation.Bean; // 导入 Spring 的 Bean 注解
import org.springframework.context.annotation.Configuration; // 导入 Spring 的 Configuration 注解
import io.minio.MinioClient; // 导入 MinioClient 类

/**
 * Minio 配置信息
 *
 * @author course
 */
@Configuration // 声明这是一个配置类，Spring 会在启动时加载并处理这个类
@ConfigurationProperties(prefix = "minio") // 使用 ConfigurationProperties 注解，指定配置属性的前缀为 "minio"
public class MinioConfig
{
    /**
     * 服务地址
     */
    private String url; // 声明一个私有属性 url，用于存储 Minio 服务的地址

    /**
     * 用户名
     */
    private String accessKey; // 声明一个私有属性 accessKey，用于存储 Minio 服务的用户名

    /**
     * 密码
     */
    private String secretKey; // 声明一个私有属性 secretKey，用于存储 Minio 服务的密码

    /**
     * 存储桶名称
     */
    private String bucketName; // 声明一个私有属性 bucketName，用于存储 Minio 存储桶的名称

    public String getUrl() // 定义一个公共方法，用于获取服务地址
    {
        return url;
    }

    public void setUrl(String url) // 定义一个公共方法，用于设置服务地址
    {
        this.url = url;
    }

    public String getAccessKey() // 定义一个公共方法，用于获取用户名
    {
        return accessKey;
    }

    public void setAccessKey(String accessKey) // 定义一个公共方法，用于设置用户名
    {
        this.accessKey = accessKey;
    }

    public String getSecretKey() // 定义一个公共方法，用于获取密码
    {
        return secretKey;
    }

    public void setSecretKey(String secretKey) // 定义一个公共方法，用于设置密码
    {
        this.secretKey = secretKey;
    }

    public String getBucketName() // 定义一个公共方法，用于获取存储桶名称
    {
        return bucketName;
    }

    public void setBucketName(String bucketName) // 定义一个公共方法，用于设置存储桶名称
    {
        this.bucketName = bucketName;
    }

    @Bean // 声明这是一个 Bean 方法，Spring 会将其返回的对象注册为一个 Bean
    public MinioClient getMinioClient() // 定义一个公共方法，用于获取 MinioClient 实例
    {
        return MinioClient.builder().endpoint(url).credentials(accessKey, secretKey).build(); // 创建并返回一个 MinioClient 实例，设置服务地址、用户名和密码
    }
}