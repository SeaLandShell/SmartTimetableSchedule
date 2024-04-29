package com.app.cschedule.common.util;

import com.app.cschedule.common.exception.FileException; // 引入自定义文件异常类
import lombok.extern.slf4j.Slf4j; // 使用Lombok提供的@Slf4j注解，自动生成Logger对象
import org.springframework.beans.factory.annotation.Value; // 引入Spring的@Value注解，用于从配置文件中读取属性值
import org.springframework.core.io.Resource; // 引入Spring的Resource类，用于处理资源
import org.springframework.core.io.UrlResource; // 引入Spring的UrlResource类，用于表示URL资源
import org.springframework.stereotype.Service; // 声明该类是一个Service
import org.springframework.web.multipart.MultipartFile; // 引入Spring的MultipartFile类，用于处理文件上传

import java.io.IOException; // 引入Java的IOException类，用于处理输入输出异常
import java.net.MalformedURLException; // 引入Java的MalformedURLException类，用于处理URL异常
import java.nio.file.Files; // 引入Java的Files类，用于文件操作
import java.nio.file.Path; // 引入Java的Path类，表示文件路径
import java.nio.file.Paths; // 引入Java的Paths类，用于操作路径
import java.nio.file.StandardCopyOption; // 引入Java的StandardCopyOption类，用于文件复制
import java.util.UUID; // 引入Java的UUID类，用于生成唯一标识符

@Service // 声明该类是一个Spring的Service
@Slf4j // 自动生成Logger对象
public class FileUtils {
    public static final String USER_PR = "users/"; // 用户文件夹路径
    public static final String PUBLIC_PR = "public/"; // 公共文件夹路径
    private static Path UPLOAD_PATH; // 文件上传路径

    public FileUtils(@Value("${file.upload-path}") String path) { // 构造方法，从配置文件中获取文件上传路径
        UPLOAD_PATH = Paths.get(path).normalize(); // 标准化文件上传路径
        Path publicPath = Paths.get(path).resolve(PUBLIC_PR).normalize(); // 获取公共文件夹路径
        if (!Files.exists(publicPath)) { // 如果公共文件夹路径不存在
            try {
                Files.createDirectories(publicPath); // 创建公共文件夹路径
            } catch (Exception e) {
                throw new FileException("Could not create the directory where the uploaded files will be stored.", e); // 抛出文件异常
            }
        }
    }

    /**
     * 存储文件到系统
     * @param file 文件
     * @return 文件名
     */
    public static String storeFile(MultipartFile file, Path storePath) { // 存储文件到系统
        // 生成随机文件名
        String oldNamePrefix = file.getOriginalFilename();
        if (oldNamePrefix.contains(".")) {
            oldNamePrefix = oldNamePrefix.substring(0, oldNamePrefix.lastIndexOf("."));
        }
        String fileName = file.getOriginalFilename().replace(oldNamePrefix, UUID.randomUUID().toString()); // 使用UUID生成唯一文件名
        return storeFile(file, fileName, storePath); // 调用重载方法
    }

    public static String storeFile(MultipartFile file, String fileName, Path storePath) { // 存储文件到系统
        try {
            // 检查文件名是否包含无效字符
            if (fileName.contains("..")) {
                throw new FileException("Sorry! Filename contains invalid path sequence " + fileName); // 抛出文件异常
            }
            // 将文件复制到目标位置（替换同名文件）
            Path targetLocation = UPLOAD_PATH.resolve(storePath).resolve(fileName).normalize(); // 目标文件路径
            Files.copy(file.getInputStream(), targetLocation, StandardCopyOption.REPLACE_EXISTING); // 复制文件到目标位置
            String relative = storePath.resolve(fileName).toString().replaceAll("\\\\", "/"); // 相对路径
            log.info("relative: "+relative); // 记录日志
            return relative; // 返回相对路径
        } catch (IOException ex) {
            throw new FileException("Could not store file " + fileName + ". Please try again!", ex); // 抛出文件异常
        }
    }

    /**
     * 删除文件
     * @param filePath 文件相对路径
     * @throws IOException 删除文件时可能抛出的IOException
     */
    public static void deleteFile(String filePath) throws IOException {
        Path fileToDelete = UPLOAD_PATH.resolve(filePath).normalize(); // 文件路径
        Files.deleteIfExists(fileToDelete); // 如果文件存在，则删除文件
    }

    /**
     * 加载文件
     * @param path 文件相对路径
     * @return 文件
     */
    public static Resource loadFileAsResource(String path) { // 加载文件
        try {
            Path filePath = UPLOAD_PATH.resolve(path).normalize(); // 文件路径

            Resource resource = new UrlResource(filePath.toUri()); // 创建资源对象
            if (resource.exists()) { // 如果资源存在
                return resource; // 返回资源
            } else {
                throw new FileException("File not found " + path); // 抛出文件异常
            }
        } catch (MalformedURLException ex) {
            throw new FileException("File not found " + path, ex); // 抛出文件异常
        }
    }

    public static Path getUserPath(String id) { // 获取用户文件夹路径
        Path path = UPLOAD_PATH.resolve(USER_PR).resolve(id); // 用户文件夹路径
        if (!Files.exists(path)) { // 如果用户文件夹路径不存在
            try {
                Files.createDirectories(path); // 创建用户文件夹路径
            } catch (Exception e) {
                throw new FileException("Could not create the directory where the uploaded files will be stored.", e); // 抛出文件异常
            }
        }
        return Paths.get(USER_PR).resolve(id); // 返回用户文件夹路径
    }
}