/**
 * 文件处理工具类
 *
 * @author course
 */
package com.course.common.core.utils.file; // 声明包路径为com.course.common.core.utils.file

import java.io.File; // 导入java.io.File类
import java.io.FileInputStream; // 导入java.io.FileInputStream类
import java.io.FileNotFoundException; // 导入java.io.FileNotFoundException类
import java.io.IOException; // 导入java.io.IOException类
import java.io.OutputStream; // 导入java.io.OutputStream类
import java.io.UnsupportedEncodingException; // 导入java.io.UnsupportedEncodingException类
import java.net.URLEncoder; // 导入java.net.URLEncoder类
import java.nio.charset.StandardCharsets; // 导入java.nio.charset.StandardCharsets类
import javax.servlet.http.HttpServletRequest; // 导入javax.servlet.http.HttpServletRequest类
import javax.servlet.http.HttpServletResponse; // 导入javax.servlet.http.HttpServletResponse类

import com.course.common.core.utils.StringUtils; // 导入com.course.common.core.utils.StringUtils类
import org.apache.commons.lang3.ArrayUtils; // 导入org.apache.commons.lang3.ArrayUtils类

/**
 * 文件处理工具类
 *
 * @author course
 */
public class FileUtils // 声明公共类FileUtils
{
    /** 字符常量：斜杠 {@code '/'} */
    public static final char SLASH = '/'; // 声明公共静态常量SLASH，值为斜杠'/'字符

    /** 字符常量：反斜杠 {@code '\\'} */
    public static final char BACKSLASH = '\\'; // 声明公共静态常量BACKSLASH，值为反斜杠'\\'字符

    public static String FILENAME_PATTERN = "[a-zA-Z0-9_\\-\\|\\.\\u4e00-\\u9fa5]+"; // 声明公共静态字符串常量FILENAME_PATTERN，值为文件名模式匹配的正则表达式
//    [a-zA-Z0-9_\-]：匹配字母、数字、下划线和连字符。
//      |：表示逻辑或。
//      \.：匹配句点。
//      \u4e00-\u9fa5：匹配中文字符范围。
    /**
     * 输出指定文件的byte数组
     *
     * @param filePath 文件路径
     * @param os 输出流
     * @return
     * @throws IOException
     */
    public static void writeBytes(String filePath, OutputStream os) throws IOException // 声明公共静态void方法writeBytes，接受字符串filePath和输出流os作为参数，可能抛出IOException异常
    {
        FileInputStream fis = null; // 声明FileInputStream对象fis，初始化为null
        try // 捕获可能抛出的异常
        {
            File file = new File(filePath); // 创建File对象file，传入filePath作为参数
            if (!file.exists()) // 如果文件不存在
            {
                throw new FileNotFoundException(filePath); // 抛出FileNotFoundException异常
            }
            fis = new FileInputStream(file); // 实例化FileInputStream对象fis，传入file作为参数
            byte[] b = new byte[1024]; // 创建字节数组b，大小为1024
            int length; // 声明整型变量length
            while ((length = fis.read(b)) > 0) // 循环读取文件内容到字节数组b，直到读取完毕
            {
                os.write(b, 0, length); // 将字节数组b的内容写入输出流os
            }
        }
        catch (IOException e) // 捕获IOException异常
        {
            throw e; // 抛出异常
        }
        finally // 无论是否发生异常，都执行以下代码
        {
            if (os != null) // 如果输出流不为null
            {
                try // 捕获可能抛出的异常
                {
                    os.close(); // 关闭输出流
                }
                catch (IOException e1) // 捕获IOException异常
                {
                    e1.printStackTrace(); // 打印异常堆栈信息
                }
            }
            if (fis != null) // 如果FileInputStream对象不为null
            {
                try // 捕获可能抛出的异常
                {
                    fis.close(); // 关闭FileInputStream对象
                }
                catch (IOException e1) // 捕获IOException异常
                {
                    e1.printStackTrace(); // 打印异常堆栈信息
                }
            }
        }
    }

    /**
     * 删除文件
     *
     * @param filePath 文件
     * @return
     */
    public static boolean deleteFile(String filePath) // 声明公共静态boolean方法deleteFile，接受字符串filePath作为参数
    {
        boolean flag = false; // 声明布尔变量flag，初始化为false
        File file = new File(filePath); // 创建File对象file，传入filePath作为参数
        // 路径为文件且不为空则进行删除
        if (file.isFile() && file.exists()) // 如果是文件且存在
        {
            flag = file.delete(); // 删除文件，并将结果赋给flag
        }
        return flag; // 返回flag
    }

    /**
     * 文件名称验证
     *
     * @param filename 文件名称
     * @return true 正常 false 非法
     */
    public static boolean isValidFilename(String filename) // 声明公共静态boolean方法isValidFilename，接受字符串filename作为参数
    {
        return filename.matches(FILENAME_PATTERN); // 返回filename是否匹配FILENAME_PATTERN的结果
    }


    /**
     * 检查文件是否可下载
     *
     * @param resource 需要下载的文件
     * @return true 正常 false 非法
     */
    public static boolean checkAllowDownload(String resource)
    {
        // 禁止目录上跳级别
        // 这里使用 StringUtils.contains 方法检查 resource 字符串是否包含 ".."。
        // 如果包含,说明存在目录上跳的风险,返回 false 表示不允许下载。
        if (StringUtils.contains(resource, ".."))
        {
            return false;
        }
        // 判断是否在允许下载的文件规则内
        // 这里使用 ArrayUtils.contains 方法检查 resource 对应的文件类型是否在 MimeTypeUtils.DEFAULT_ALLOWED_EXTENSION 数组中。
        // 如果在,说明是允许下载的文件类型,返回 true。否则返回 false。
        return ArrayUtils.contains(MimeTypeUtils.DEFAULT_ALLOWED_EXTENSION, FileTypeUtils.getFileType(resource));
    }

    /**
     * 下载文件名重新编码
     *
     * @param request 请求对象
     * @param fileName 文件名
     * @return 编码后的文件名
     */
    public static String setFileDownloadHeader(HttpServletRequest request, String fileName) throws UnsupportedEncodingException
    {
        // 获取浏览器的 User-Agent 信息
        final String agent = request.getHeader("USER-AGENT");
        String filename = fileName;
        // 根据不同的浏览器,对文件名进行不同的编码处理
        if (agent.contains("MSIE"))
        {
            // IE 浏览器,使用 URLEncoder.encode 对文件名进行 UTF-8 编码,并将 "+" 替换为空格
            filename = URLEncoder.encode(filename, "utf-8");
            filename = filename.replace("+", " ");
        }
        else if (agent.contains("Firefox"))
        {
            // Firefox 浏览器,使用 new String(fileName.getBytes(), "ISO8859-1") 进行编码
            filename = new String(fileName.getBytes(), "ISO8859-1");
        }
        else if (agent.contains("Chrome"))
        {
            // Google Chrome 浏览器,使用 URLEncoder.encode 对文件名进行 UTF-8 编码
            filename = URLEncoder.encode(filename, "utf-8");
        }
        else
        {
            // 其他浏览器,使用 URLEncoder.encode 对文件名进行 UTF-8 编码
            filename = URLEncoder.encode(filename, "utf-8");
        }
        return filename;
    }

    /**
     * 返回文件名
     *
     * @param filePath 文件
     * @return 文件名
     */
    public static String getName(String filePath)
    {
        // 如果 filePath 为 null,返回 null
        if (null == filePath)
        {
            return null;
        }
        // 获取 filePath 的长度
        int len = filePath.length();
        // 如果长度为 0,返回 filePath
        if (0 == len)
        {
            return filePath;
        }
        // 如果最后一个字符是文件分隔符,去掉最后一个字符
        if (isFileSeparator(filePath.charAt(len - 1)))
        {
            len--;
        }

        // 从后往前查找最后一个文件分隔符的位置
        int begin = 0;
        char c;
        for (int i = len - 1; i > -1; i--)
        {
            c = filePath.charAt(i);
            if (isFileSeparator(c))
            {
                begin = i + 1;
                break;
            }
        }

        // 返回从最后一个文件分隔符后开始到结尾的字符串,即文件名
        return filePath.substring(begin, len);
    }

    /**
     * 是否为Windows或者Linux（Unix）文件分隔符<br>
     * Windows平台下分隔符为\，Linux（Unix）为/
     *
     * @param c 字符
     * @return 是否为Windows或者Linux（Unix）文件分隔符
     */
    public static boolean isFileSeparator(char c)
    {
        // 判断字符 c 是否为文件分隔符 '/' 或 '\'
        return SLASH == c || BACKSLASH == c;
    }

    /**
     * 下载文件名重新编码
     *
     * @param response 响应对象
     * @param realFileName 真实文件名
     * @return
     */
    public static void setAttachmentResponseHeader(HttpServletResponse response, String realFileName) throws UnsupportedEncodingException
    {
        // 对文件名进行百分号编码
        String percentEncodedFileName = percentEncode(realFileName);

        // 构建 Content-Disposition 响应头的值
        StringBuilder contentDispositionValue = new StringBuilder();
        contentDispositionValue.append("attachment; filename=")
                .append(percentEncodedFileName)
                .append(";")
                .append("filename*=")
                .append("utf-8''")
                .append(percentEncodedFileName);

        // 设置 Content-Disposition 和 download-filename 响应头
        response.setHeader("Content-disposition", contentDispositionValue.toString());
        response.setHeader("download-filename", percentEncodedFileName);
    }

    /**
     * 百分号编码工具方法
     *
     * @param s 需要百分号编码的字符串
     * @return 百分号编码后的字符串
     */
    public static String percentEncode(String s) throws UnsupportedEncodingException
    {
        // 使用 URLEncoder.encode 对字符串进行 UTF-8 编码
        String encode = URLEncoder.encode(s, StandardCharsets.UTF_8.toString());
        // 将编码后的 "+" 替换为 "%20"
        return encode.replaceAll("\\+", "%20");
    }
}