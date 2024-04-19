package com.app.cschedule.service.impl; // 声明包名

import lombok.extern.slf4j.Slf4j; // 导入日志注解
import org.springframework.beans.factory.annotation.Autowired; // 导入自动装配注解
import org.springframework.beans.factory.annotation.Value; // 导入数值注解
import org.springframework.core.io.FileSystemResource; // 导入文件系统资源类
import org.springframework.mail.SimpleMailMessage; // 导入简单邮件消息类
import org.springframework.mail.javamail.JavaMailSender; // 导入邮件发送器类
import org.springframework.mail.javamail.MimeMessageHelper; // 导入MIME消息帮助类
import org.springframework.stereotype.Service; // 导入服务注解

import javax.mail.MessagingException; // 导入邮件异常类
import javax.mail.internet.MimeMessage; // 导入MIME消息类
import java.io.File; // 导入文件类

@Service // 声明为服务类
@Slf4j // 使用日志注解
public class EmailService { // 定义EmailService类
    @Autowired // 自动装配邮件发送器
    private JavaMailSender mailSender; // 邮件发送器

    @Value("${spring.mail.from.addr}") // 从配置文件中注入常量
    private String from; // 发件人地址

    /**
     * 发送文本邮件
     */
    public void sendTextMail(String toAddr, String title, String content) { // 定义发送文本邮件方法，参数为收件人地址、标题、内容
        // 创建纯文本邮件对象
        SimpleMailMessage message = new SimpleMailMessage();
        message.setFrom(from); // 设置发件人
        message.setTo(toAddr); // 设置收件人
        message.setSubject(title); // 设置标题
        message.setText(content); // 设置内容
        mailSender.send(message); // 发送邮件
        log.info("Text邮件已经发送。"); // 记录日志
    }

    /**
     * 发送html邮件
     */
    public void sendHtmlMail(String toAddr, String title, String content) { // 定义发送HTML邮件方法，参数为收件人地址、标题、内容
        // 创建HTML邮件对象
        MimeMessage message = mailSender.createMimeMessage();

        try {
            MimeMessageHelper helper = new MimeMessageHelper(message, true); // 创建MIME消息帮助类
            helper.setFrom(from); // 设置发件人
            helper.setTo(toAddr); // 设置收件人
            helper.setSubject(title); // 设置标题
            helper.setText(content, true); // 设置内容为HTML格式

            mailSender.send(message); // 发送邮件
            log.info("html邮件发送成功"); // 记录日志
        } catch (MessagingException e) { // 捕获邮件异常
            log.error("发送html邮件时发生异常！", e); // 记录异常日志
        }
    }

    /**
     * 发送带附件的邮件
     */
    public void sendAttachmentsMail(String toAddr, String title, String content, String filePath) { // 定义发送带附件的邮件方法，参数为收件人地址、标题、内容、附件路径
        MimeMessage message = mailSender.createMimeMessage(); // 创建MIME消息对象

        try {
            MimeMessageHelper helper = new MimeMessageHelper(message, true); // 创建MIME消息帮助类
            helper.setFrom(from); // 设置发件人
            helper.setTo(toAddr); // 设置收件人
            helper.setSubject(title); // 设置标题
            helper.setText(content, true); // 设置内容为HTML格式

            FileSystemResource file = new FileSystemResource(new File(filePath)); // 创建文件系统资源对象
            String fileName = filePath.substring(filePath.lastIndexOf(File.separator)); // 获取文件名
            helper.addAttachment(fileName, file); // 添加附件

            mailSender.send(message); // 发送邮件
            log.info("带附件的邮件已经发送。"); // 记录日志
        } catch (MessagingException e) { // 捕获邮件异常
            log.error("发送带附件的邮件时发生异常！", e); // 记录异常日志
        }
    }

    /**
     * 发送正文中有静态资源（图片）的邮件
     */
    public void sendInlineResourceMail(String toAddr, String title, String content, String rscPath, String rscId) { // 定义发送带静态资源的邮件方法，参数为收件人地址、标题、内容、资源路径、资源ID
        MimeMessage message = mailSender.createMimeMessage(); // 创建MIME消息对象

        try {
            MimeMessageHelper helper = new MimeMessageHelper(message, true); // 创建MIME消息帮助类
            helper.setFrom(from); // 设置发件人
            helper.setTo(toAddr); // 设置收件人
            helper.setSubject(title); // 设置标题
            helper.setText(content, true); // 设置内容为HTML格式

            FileSystemResource res = new FileSystemResource(new File(rscPath)); // 创建静态资源对象
            helper.addInline(rscId, res); // 添加静态资源

            mailSender.send(message); // 发送邮件
            log.info("嵌入静态资源的邮件已经发送。"); // 记录日志
        } catch (MessagingException e) { // 捕获邮件异常
            log.error("发送嵌入静态资源的邮件时发生异常！", e); // 记录异常日志
        }
    }
}