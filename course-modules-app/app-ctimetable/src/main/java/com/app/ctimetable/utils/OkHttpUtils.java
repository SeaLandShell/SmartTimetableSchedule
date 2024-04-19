package com.app.ctimetable.utils;


import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.Response;

import java.io.*;
import java.util.Objects;
import java.util.Optional;
import java.util.concurrent.TimeUnit;

public class OkHttpUtils {
    private static final byte[] EMPTY_BYTES = new byte[0];

    /**
     * 静态内部类单例模式
     * 需要时加载
     * <p>
     * 只有第一次调用getInstance方法时，
     * 虚拟机才加载 Inner 并初始化okHttpClient，
     * 只有一个线程可以获得对象的初始化锁，其他线程无法进行初始化，
     * 保证对象的唯一性。目前此方式是所有单例模式中最推荐的模式。
     */
    private static class Inner {
        private static OkHttpClient okHttpClient = new OkHttpClient.Builder()
                .connectTimeout(5, TimeUnit.SECONDS)
                .readTimeout(5, TimeUnit.SECONDS)
                .writeTimeout(5, TimeUnit.SECONDS)
                .followRedirects(true)
                .build();
    }

    public static OkHttpClient getOkHttpClient() {
        return Inner.okHttpClient;
    }

    public static void setFollowRedirects(boolean followRedirects) { // 定义设置是否跟随重定向的静态方法，接受一个布尔值参数followRedirects

        if (Inner.okHttpClient.followRedirects() != followRedirects) { // 如果当前OkHttpClient的跟随重定向状态与传入的参数followRedirects不一致
            Inner.okHttpClient = Inner.okHttpClient.newBuilder() // 创建一个新的OkHttpClient.Builder
                    .followRedirects(followRedirects) // 设置新的跟随重定向状态
                    .build(); // 构建新的OkHttpClient实例并赋值给Inner.okHttpClient
        }
    }


    /**
     * 下载文件到本地
     *
     * @param url  网址
     * @param path 文件夹地址
     * @param name 文件名
     * @return 是否成功
     */
    public static boolean downloadToLocal(String url, String path, String name) {
        return downloadToLocal(createRequest(url), path, name);
    }

    /**
     * 下载文件到本地
     *
     * @param path 文件夹地址
     * @param name 文件名
     * @return 是否下载成功
     */
    public static boolean downloadToLocal(Request request, String path, String name) { // 定义一个静态方法downloadToLocal，用于下载文件到本地
        BufferedInputStream bis = null; // 声明一个缓冲输入流bis，初始值为null
        BufferedOutputStream bos = null; // 声明一个缓冲输出流bos，初始值为null
        try (Response response = getOkHttpClient().newCall(request).execute()) { // 使用try-with-resources语句，发送请求并获取响应对象response
            if (response.code() == 200) { // 如果响应码为200（表示请求成功）
                if (response.body() == null) { // 如果响应体为空
                    return false; // 返回false表示下载失败
                }

                File file = new File(path); // 创建一个File对象表示下载路径
                if (!file.exists()) { // 如果文件不存在
                    if (!file.mkdirs()) { // 创建目录结构
                        System.out.println(path + "路径创建失败"); // 输出路径创建失败信息
                    }
                } else { // 如果文件存在
                    if (!file.isDirectory()) { // 如果不是一个目录
                        return false; // 返回false表示下载失败
                    }
                }

                bos = new BufferedOutputStream( // 初始化缓冲输出流bos，将下载文件写入到本地
                        new FileOutputStream(new File(file, name))); // 创建文件输出流，指定写入的文件名
                bis = new BufferedInputStream(Objects.requireNonNull(response.body()).byteStream()); // 初始化缓冲输入流bis，读取响应体的字节流

                byte[] buffer = new byte[1024]; // 创建一个大小为1024的字节数组作为缓冲区
                int len; // 声明一个整型变量len，用于记录每次读取的字节数
                while ((len = bis.read(buffer, 0, 1024)) != -1) { // 循环读取字节流到缓冲区
                    bos.write(buffer, 0, len); // 将缓冲区的数据写入到输出流
                }
                bos.flush(); // 刷新缓冲输出流

                return true; // 返回true表示下载成功
            }
        } catch (IOException | NullPointerException e) { // 捕获IO异常和空指针异常
            e.printStackTrace(); // 打印异常堆栈信息
        } finally { // finally块始终会被执行，用于关闭流资源
            try {
                if (bis != null) { // 如果输入流不为null
                    bis.close(); // 关闭输入流
                }
                if (bos != null) { // 如果输出流不为null
                    bos.close(); // 关闭输出流
                }
            } catch (IOException e) { // 捕获IO异常
                e.printStackTrace(); // 打印异常堆栈信息
            }

        }
        return false; // 返回false表示下载失败
    }


    /**
     * 下载文本内容
     *
     * @param url 网址
     * @return 下载文本
     */
    public static String downloadText(String url) {
        return downloadText(createRequest(url));
    }

    /**
     * 下载文本内容
     *
     * @param request
     * @return
     */
    public static String downloadText(Request request) {
        return downloadText(request, "UTF-8");
    }

    /**
     * 下载文本内容
     *
     * @param url
     * @return
     */
    public static String downloadText(String url, String encoding) {
        return downloadText(createRequest(url), encoding);
    }

    /**
     * 下载文本内容
     *
     * @param request
     * @param encoding
     * @return
     */
    public static String downloadText(Request request, String encoding) {
        try {
            return new String(downloadRaw(request), encoding);
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
            return "";
        }
    }

    /**
     * 下载字节码
     *
     * @param url
     * @return
     */
    public static byte[] downloadRaw(String url) {
        return downloadRaw(createRequest(url));
    }

    /**
     * 下载字节码
     *
     * @param request
     * @return 返回下载内容
     */
    public static byte[] downloadRaw(Request request) {
        try (Response response = getOkHttpClient().newCall(request).execute()) {
            if (response.code() == 200 && response.body() != null) {
                return Optional.ofNullable(response.body())
                        .map(body -> {
                            try {
                                return body.bytes();
                            } catch (IOException e) {
                                e.printStackTrace();
                                return null;
                            }
                        })
                        .orElse(EMPTY_BYTES);
            }
        } catch (IOException | NullPointerException e) {
            e.printStackTrace();
        }
        return EMPTY_BYTES;
    }

    /**
     * 生成request
     *
     * @param url 网址
     * @return
     */
    public static Request createRequest(String url) {
        return new Request.Builder()
                .url(url)
                .build();
    }

    public static Request createRequest(String url, String cookies) {
        return new Request.Builder()
                .url(url)
                .addHeader("cookie", cookies)
                .build();
    }
}
