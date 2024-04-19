package com.app.cschedule.common.util; // 声明包名

import com.course.common.core.utils.StringUtils; // 导入StringUtils工具类
import javax.servlet.http.HttpServletRequest; // 导入HttpServletRequest类

public class IpUtils { // 定义IpUtils类

    /**
     * 获取IP地址
     * <p>
     * 使用Nginx等反向代理软件， 则不能通过request.getRemoteAddr()获取IP地址
     * 如果使用了多级反向代理的话，X-Forwarded-For的值并不止一个，而是一串IP地址，
     * X-Forwarded-For中第一个非unknown的有效IP字符串，则为真实IP地址
     */
    public static String getIpAddr(HttpServletRequest request) { // 获取IP地址的方法，传入HttpServletRequest对象作为参数
        String ip = null, unknown = "unknown", seperator = ","; // 定义变量ip、unknown、seperator
        int maxLength = 15; // 定义最大长度为15

        try { // 捕获可能发生的异常
            ip = request.getHeader("x-forwarded-for"); // 获取请求头中的x-forwarded-for字段
            if (StringUtils.isEmpty(ip) || unknown.equalsIgnoreCase(ip)) { // 如果ip为空或者值为unknown
                ip = request.getHeader("Proxy-Client-IP"); // 获取请求头中的Proxy-Client-IP字段
            }
            if (StringUtils.isEmpty(ip) || ip.length() == 0 || unknown.equalsIgnoreCase(ip)) { // 如果ip为空或者长度为0或者值为unknown
                ip = request.getHeader("WL-Proxy-Client-IP"); // 获取请求头中的WL-Proxy-Client-IP字段
            }
            if (StringUtils.isEmpty(ip) || unknown.equalsIgnoreCase(ip)) { // 如果ip为空或者值为unknown
                ip = request.getHeader("HTTP_CLIENT_IP"); // 获取请求头中的HTTP_CLIENT_IP字段
            }
            if (StringUtils.isEmpty(ip) || unknown.equalsIgnoreCase(ip)) { // 如果ip为空或者值为unknown
                ip = request.getHeader("HTTP_X_FORWARDED_FOR"); // 获取请求头中的HTTP_X_FORWARDED_FOR字段
            }
            if (StringUtils.isEmpty(ip) || unknown.equalsIgnoreCase(ip)) { // 如果ip为空或者值为unknown
                ip = request.getRemoteAddr(); // 获取远程地址
            }
        } catch (Exception e) { // 捕获异常
            e.printStackTrace(); // 打印异常信息
        }

        // 使用代理，则获取第一个IP地址
        if (StringUtils.isEmpty(ip) && ip.length() > maxLength) { // 如果ip为空且长度大于最大长度
            int idx = ip.indexOf(seperator); // 获取分隔符的位置
            if (idx > 0) { // 如果分隔符位置大于0
                ip = ip.substring(0, idx); // 截取第一个IP地址
            }
        }

        return ip; // 返回IP地址
    }
}