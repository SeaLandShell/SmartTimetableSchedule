package com.app.cschedule.controller; // 包声明

import com.app.cschedule.common.annotation.LogAnnotation; // 导入LogAnnotation注解
import com.app.cschedule.common.constant.LogType; // 导入LogType常量
import com.app.cschedule.common.util.FileUtils; // 导入FileUtils工具类
import io.swagger.annotations.Api; // 导入Api注解
import io.swagger.annotations.ApiOperation; // 导入ApiOperation注解
import lombok.extern.slf4j.Slf4j; // 导入日志记录注解
import org.springframework.core.io.Resource; // 导入Spring框架的Resource类
import org.springframework.http.HttpHeaders; // 导入HttpHeaders类
import org.springframework.http.MediaType; // 导入MediaType类
import org.springframework.http.ResponseEntity; // 导入ResponseEntity类
import org.springframework.web.bind.annotation.GetMapping; // 导入GetMapping注解
import org.springframework.web.bind.annotation.RequestMapping; // 导入RequestMapping注解
import org.springframework.web.bind.annotation.RestController; // 导入RestController注解

import javax.servlet.http.HttpServletRequest; // 导入HttpServletRequest类
import java.io.IOException; // 导入IOException类

@Slf4j // 使用Slf4j日志记录
@Api(tags = "文件下载") // 使用Api注解，定义接口标签为"文件下载"
@RestController // 声明该类是一个控制器，并返回RESTful风格的数据
@RequestMapping("/files") // 映射请求路径为/files的接口
public class FileController { // 定义FileController类
    // @GetMapping("/download/{path:.+}/{filename:.+}") // 匹配两层路径
    @GetMapping("/download/**") // 匹配多重路径
    @ApiOperation(value = "下载文件") // 使用ApiOperation注解，定义接口操作为"下载文件"
    @LogAnnotation(operation = "下载文件", exclude = {LogType.REQUEST, LogType.RESPONSE}) // 记录下载文件操作日志，排除请求和响应日志
    /**
     * 方法用途：下载文件
     * 参数：HttpServletRequest对象
     */
    public ResponseEntity<Resource> downloadFile(HttpServletRequest request) {
        // 截取请求路径中的文件路径部分
        String resourcePath = request.getServletPath().substring(16);
        // 将文件加载为Resource对象
        Resource resource = FileUtils.loadFileAsResource(resourcePath);

        // 尝试确定文件的内容类型
        String contentType = null;
        try {
            contentType = request.getServletContext().getMimeType(resource.getFile().getAbsolutePath());
        } catch (IOException ex) {
            log.info("Could not determine file type.");
        }

        // 如果无法确定类型，则回退到默认内容类型
        if(contentType == null) {
            contentType = "application/octet-stream";
        }

        // 返回一个成功的ResponseEntity对象
        return ResponseEntity.ok()
                // 设置响应内容类型
                .contentType(MediaType.parseMediaType(contentType))
                // 设置响应头Content-Disposition，指定文件下载方式和文件名
                .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + resource.getFilename() + "\"")
                // 设置响应体为Resource对象
                .body(resource);
    }
}