package com.app.zfjwxt.utils;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import javax.imageio.ImageIO;
import java.awt.*;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Component
public class JavaOCR {
    @Value("${crawler.javaOCR.trainSetDir}")
    private String trainSetDir;
    @Value("${crawler.javaOCR.trainResultDir}")
    private String trainResultDir;
    @Value("${crawler.javaOCR.trainTestDir}")
    private String trainTestDir;

    public  int whiteOrBlack(int colorRgb) { // 定义一个方法，用于判断颜色是白色还是黑色
        Color color = new Color(colorRgb); // 创建一个Color对象，传入颜色的RGB值
        if (color.getRed() + color.getBlue() + color.getGreen() > 153) { // 判断颜色的RGB值之和是否大于153
            return 1; // 如果大于153，返回1，代表白色
        } else
            return 0; // 如果小于等于153，返回0，代表黑色
    }


    public  int isBlack(int colorInt) { // 定义一个方法，用于判断颜色是否为黑色
        Color color = new Color(colorInt); // 创建一个Color对象，传入颜色的整数表示
        if (color.getRed() + color.getGreen() + color.getBlue() <= 100) { // 判断颜色的RGB值之和是否小于等于100
            return 1; // 如果小于等于100，返回1，代表黑色
        }
        return 0; // 如果大于100，返回0，代表非黑色
    }

    public  int isWhite(int colorInt) {
        Color color = new Color(colorInt);
        if (color.getRed() + color.getGreen() + color.getBlue() > 600) {
            return 1;
        }
        return 0;
    }

    public  int isBlue(int colorInt) {
        Color color = new Color(colorInt);
        int rgb = color.getRed() + color.getGreen() + color.getBlue();
        if (rgb == 153) {
            return 1;
        }
        return 0;
    }

    /**
     * 对验证码图片进行预处理，提高识别度,BufferedImage对象的左上角坐标为 (0, 0)，单位为px
     *
     * @param bi 原始验证码图片
     * @return 预处理过的验证码图片
     */
    public BufferedImage getImgBinary(BufferedImage bi) throws IOException {
        // 先裁剪掉验证码左边的空白
        bi = bi.getSubimage(3, 1, bi.getWidth() - 3, bi.getHeight() - 5); // 裁剪掉左边3像素，上边1像素，右边3像素，下边5像素的空白部分
        // 直接裁剪左边50px的验证码，相当于裁剪验证码右边的空白
        bi = bi.getSubimage(0, 0, 50, bi.getHeight()); // 裁剪左边50像素的部分，保留高度不变
        int width = bi.getWidth(); // 获取裁剪后图片的宽度
        int height = bi.getHeight(); // 获取裁剪后图片的高度
        // 图片黑白处理
        for (int i = 0; i < width; i++) { // 循环遍历每一列像素
            for (int j = 0; j < height; j++) { // 循环遍历每一行像素
                // 如果不是纯色的验证码，可以用大于、小于某一范围之类的判断，而不是用等于
                int rgb = bi.getRGB(i, j); // 获取像素点的RGB值
                if (isBlue(rgb) == 1) { // 判断像素点是否为蓝色
                    bi.setRGB(i, j, Color.BLACK.getRGB()); // 将蓝色像素点设置为黑色
                } else {
                    bi.setRGB(i, j, Color.WHITE.getRGB()); // 将非蓝色像素点设置为白色
                }
            }
        }
        return bi; // 返回处理后的图片
    }

    /**
     * 进行图片裁剪，将每张验证码进行横向四等分
     *
     * @param image 要裁剪的验证码图片
     * @return 裁剪后的验证码图片子集
     */
    public List<BufferedImage> getCharSplit(BufferedImage image) {
        List<BufferedImage> subImageList = new ArrayList<>(); // 创建存放子图片的列表
        int width = image.getWidth() / 4; // 计算每个字符的宽度
        int height = image.getHeight(); // 获取图片的高度
        subImageList.add(image.getSubimage(0, 0, width, height)); // 将第一个字符的子图片添加到列表中
        subImageList.add(image.getSubimage(width, 0, width, height)); // 将第二个字符的子图片添加到列表中
        subImageList.add(image.getSubimage(width * 2, 0, width, height)); // 将第三个字符的子图片添加到列表中
        subImageList.add(image.getSubimage(width * 3, 0, width, height)); // 将第四个字符的子图片添加到列表中
        return subImageList; // 返回包含每个字符子图片的列表
    }

    /**
     * 进行验证码识别训练
     *
     * @throws IOException 抛IO异常
     */
    public void trainOcr() throws IOException {
        int index = 0; // 初始化索引
        File dir = new File(trainSetDir); // 创建文件目录对象
        for (File f : dir.listFiles()) { // 遍历目录下的文件
            List<BufferedImage> list = getCharSplit(getImgBinary(ImageIO.read(f))); // 获取处理后的字符子图片列表
            if (list.size() == 4) { // 如果子图片列表长度为4
                for (int i = 0; i < list.size(); i++) { // 遍历子图片列表
                    ImageIO.write(list.get(i), "png", new File(trainResultDir
                            + f.getName().charAt(i) + "-" + (index++) + ".png")); // 将子图片写入训练结果目录
                }
            }
        }
        System.out.println("训练成功，共载入训练集" + dir.listFiles().length + "张图片"); // 打印训练成功信息及载入图片数量
    }

    /**
     * 读取训练集结果目录下的所有训练图片
     *
     * @return 训练集结果目录下的所有训练图片
     * @throws IOException
     */
    public Map<BufferedImage, String> loadTrainOcr() {
        Map<BufferedImage, String> map = new HashMap<>();
        // 读取训练集结果目录
        File trainResultFileDir = new File(trainResultDir);
        // 获取目录中的所有图片
        for (File file : trainResultFileDir.listFiles()) {
            // 读取到内存中的BufferedImage为key,文件名的第一个字符为value
            try {
                map.put(ImageIO.read(file), file.getName().charAt(0) + "");
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
        return map;
    }

    /**
     * @param image 裁剪后的验证码图片子集
     * @param map   训练集
     * @return 验证码图片子集的识别结果
     */
    private String charOcr(BufferedImage image, Map<BufferedImage, String> map) { // 定义字符识别方法，传入待识别图片和模板映射
        String string = ""; // 初始化识别结果字符串
        int width = image.getWidth(); // 获取图片宽度
        int height = image.getHeight(); // 获取图片高度
        int min = width * height; // 初始化最小差异值

        for (BufferedImage subImage : map.keySet()) { // 遍历模板映射中的子图片
            int count = 0; // 初始化差异计数器
            if (Math.abs(subImage.getWidth() - width) > 2) // 如果子图片宽度与待识别图片宽度差异大于2，则跳过
                continue;
            int widthmin = width < subImage.getWidth() ? width : subImage.getWidth(); // 取较小的宽度
            int heightmin = height < subImage.getHeight() ? height : subImage.getHeight(); // 取较小的高度
            loop: // 定义标签
            for (int i = 0; i < widthmin; i++) { // 遍历宽度
                for (int j = 0; j < heightmin; j++) { // 遍历高度
                    if (isBlack(subImage.getRGB(i, j)) != isBlack(image.getRGB(i, j))) { // 判断像素点是否相同
                        count++; // 差异计数加一
                    }
                    if (count >= min) // 如果差异计数大于等于最小差异值
                        break loop; // 跳出循环标签
                }
            }
            if (count < min) { // 如果差异计数小于最小差异值
                min = count; // 更新最小差异值
                string = map.get(subImage); // 获取对应映射的字符
            }
        }
        return string; // 返回识别结果字符串
    }

    /**
     * @param imgBinary 待识别的验证码
     * @param map       训练集
     * @return 验证码的识别结果
     */
    public String getOcrResult(BufferedImage imgBinary, Map<BufferedImage, String> map) {
        StringBuilder result = new StringBuilder();
        List<BufferedImage> splitList = getCharSplit(imgBinary);
        for (BufferedImage img : splitList) {
            result.append(charOcr(img, map));
        }
        return result.toString();
    }

    public String getTrainTestDir() {
        return trainTestDir;
    }
}
