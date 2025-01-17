/**
 * 文件内容类型工具类
 * 该类用于根据文件扩展名获取文件的内容类型
 */
package com.app.cschedule.common.util;

public class FileContentTypeUtils {

    /**
     * 根据文件扩展名获取文件的内容类型
     * @param FilenameExtension 文件扩展名
     * @return 文件内容类型
     */
    public static String contentType(String FilenameExtension) {
        if (FilenameExtension.equals(".BMP") || FilenameExtension.equals(".bmp")
                || FilenameExtension.toUpperCase().equals(".BMP")) {
            return "image/bmp";
        }
        if (FilenameExtension.equals(".GIF") || FilenameExtension.equals(".gif")
                || FilenameExtension.toUpperCase().equals(".GIF")) {
            return "image/gif";
        }
        if (FilenameExtension.equals(".JPEG") || FilenameExtension.equals(".jpeg") || FilenameExtension.equals(".JPG")
                || FilenameExtension.equals(".jpg") || FilenameExtension.equals(".PNG")
                || FilenameExtension.equals(".png") || FilenameExtension.toUpperCase().equals(".JPEG")
                || FilenameExtension.toUpperCase().equals(".JPG") || FilenameExtension.toUpperCase().equals(".PNG")) {
            return "image/jpeg";
        }
        if (FilenameExtension.equals(".HTML") || FilenameExtension.equals(".html")) {
            return "text/html";
        }
        if (FilenameExtension.equals(".TXT") || FilenameExtension.equals(".txt")
                || FilenameExtension.toUpperCase().equals(".TXT")) {
            return "text/plain";
        }
        if (FilenameExtension.equals(".VSD") || FilenameExtension.equals(".vsd")
                || FilenameExtension.toUpperCase().equals(".VSD")) {
            return "application/vnd.visio";
        }
        if (FilenameExtension.equals(".PPTX") || FilenameExtension.equals(".pptx") || FilenameExtension.equals(".PPT")
                || FilenameExtension.equals(".ppt") || FilenameExtension.toUpperCase().equals(".PPTX")
                || FilenameExtension.toUpperCase().equals(".PPT")) {
            return "application/vnd.ms-powerpoint";
        }
        if (FilenameExtension.equals(".DOCX") || FilenameExtension.equals(".docx") || FilenameExtension.equals(".DOC")
                || FilenameExtension.equals(".doc") || FilenameExtension.toUpperCase().equals(".DOCX")
                || FilenameExtension.toUpperCase().equals(".DOC")) {
            return "application/msword";
        }
        if (FilenameExtension.equals(".XML") || FilenameExtension.equals(".xml")
                || FilenameExtension.toUpperCase().equals(".XML")) {
            return "text/xml";
        }
        if (FilenameExtension.equals(".pdf") || FilenameExtension.equals(".PDF")
                || FilenameExtension.toUpperCase().equals(".PDF")) {
            return "application/pdf";
        }
        return null;
    }

    /**
     * 获取图片类型
     * @param contentType 文件内容类型
     * @return 图片类型
     */
    public static String getImgType(String contentType) {
        if(isImage(contentType)) {
            return contentType.substring("image".length()+1);
        }
        return null;
    }

    /**
     * 判断是否为图片
     * @param contentType 文件内容类型
     * @return 是否为图片
     */
    public static boolean isImage(String contentType) {
        return contentType.startsWith("image");
    }

    /**
     * 获取文件类型
     * @param fileName 文件名
     * @return 文件类型
     */
    public static String getFileType(String fileName) {
        return fileName.substring(fileName.lastIndexOf("."));
    }

}