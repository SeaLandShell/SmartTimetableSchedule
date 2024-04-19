package com.app.ctimetable.utils;

// 导入必要的类
import org.jetbrains.annotations.Nullable;
import java.io.File;

// 文件工具类
public class FileUtils {
    // 私有构造方法，避免实例化
    private FileUtils() {
    }

    // 创建文件父目录
    public static boolean createFileParentDir(String filePath) {
        // 调用createDir方法，传入filePath的父目录路径
        return createDir(new File(filePath).getParent());
    }

    // 创建目录
    public static boolean createDir(String dirPath) {
        // 创建一个File对象
        File file = new File(dirPath);
        // 如果目录已存在，则直接返回true；否则尝试创建目录并返回结果
        return file.exists() || file.mkdirs();
    }

    // 拼接目录和文件名
    public static String concatDirAndFile(String dirPath, String name) {
        // 使用File.separator拼接目录和文件名
        return dirPath + File.separator + name;
    }

    // 获取文件扩展名
    public static String getExtension(@Nullable String name) {
        // 检查文件名是否为空
        if (TextUtils.isEmpty(name)) {
            return "";
        }
        // 获取最后一个"."的位置
        int index = name.lastIndexOf('.');
        // 如果没有找到"."，返回空字符串；否则返回扩展名
        if (index == -1) {
            return "";
        } else {
            return name.substring(index + 1);
        }
    }
}