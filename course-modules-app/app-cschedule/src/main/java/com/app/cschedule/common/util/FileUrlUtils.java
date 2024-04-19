/**
 * 该类定义了用于处理文件 URL 的工具方法
 * 主要包括将 URL 转换为服务器 URL 和下载 URL
 */
package com.app.cschedule.common.util;

import org.springframework.web.servlet.support.ServletUriComponentsBuilder;

public class FileUrlUtils {

    // 下载链接前缀
    public static final String DOWN_LINK_PR = "files/download/";

    /**
     * 将 URL 转换为服务器 URL
     * @param url 需要转换的 URL
     * @return 服务器 URL
     */
    public static String toServerUrl(String url) {
        // 如果 URL 为 null，则返回 null
        if(url == null) return null;
        // 如果 URL 已经是服务器 URL，则直接返回
        if(isServerUrl(url)) return url;
        // 使用 ServletUriComponentsBuilder 从当前上下文路径构建 URL
        return ServletUriComponentsBuilder.fromCurrentContextPath().path(url).toUriString();
    }

    /**
     * 将 URL 转换为下载 URL
     * @param url 需要转换的 URL
     * @return 下载 URL
     */
    public static String toDownloadUrl(String url) {
        // 如果 URL 为 null，则返回 null
        if(url == null) return null;
        // 如果 URL 已经是服务器 URL，则直接返回
        if(isServerUrl(url)) return url;
        // 使用 ServletUriComponentsBuilder 从当前上下文路径构建下载 URL
        return ServletUriComponentsBuilder.fromCurrentContextPath().path(DOWN_LINK_PR+url).toUriString();
    }

    /**
     * 判断是否为服务器 URL
     * @param url 需要判断的 URL
     * @return 是否为服务器 URL
     */
    private static boolean isServerUrl(String url) {
        // 判断 URL 是否以 "http://" 或 "https://" 开头
        return url.startsWith("http://") || url.startsWith("https://");
    }
}