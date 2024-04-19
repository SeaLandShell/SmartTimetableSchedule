package com.app.ctimetable.utils;

import com.app.ctimetable.entity.Course; // 导入课程实体类
import jxl.Cell; // 导入 jxl 库中的 Cell 类
import jxl.Range; // 导入 jxl 库中的 Range 类
import jxl.Sheet; // 导入 jxl 库中的 Sheet 类
import jxl.Workbook; // 导入 jxl 库中的 Workbook 类
import jxl.read.biff.BiffException; // 导入 jxl 库中的异常类
import java.io.File; // 导入 Java IO 中的 File 类
import java.io.FileInputStream; // 导入 Java IO 中的 FileInputStream 类
import java.io.IOException; // 导入 Java IO 中的 IOException 类
import java.io.InputStream; // 导入 Java IO 中的 InputStream 类
import java.util.ArrayList; // 导入 Java 集合框架中的 ArrayList 类
import java.util.List; // 导入 Java 集合框架中的 List 类

public class ExcelUtils {
    // 定义一个接口，用于处理结果
    public interface HandleResult {
        Course handle(String courseStr, int row, int col);
    }

    /**
     * 处理 Excel 表格
     *
     * @param path         String Excel 文件路径
     * @param startRow     int 课程表（不算表头）开始行数（从1开始）
     * @param startCol     int 课程表（不算表头）开始列数（从1开始）
     * @param handleResult HandleResult 处理结果的回调接口
     * @return List<Course> 返回课程列表
     * <p>
     * 只读取6行7列
     */
    public static List<Course> handleExcel(String path, int startRow, int startCol, HandleResult handleResult) {
        // 声明输入流对象
        InputStream inputStream = null;
        // 创建课程列表
        List<Course> courseList = new ArrayList<>();
        // 声明工作簿对象
        Workbook excel = null;
        try {
            // 根据路径创建文件对象
            File file = new File(path);

            // 检查文件是否存在
            if (file.exists()) {
                // 如果文件存在，则创建文件输入流对象
                inputStream = new FileInputStream(file);
            } else {
                // 如果文件不存在，则直接返回空的课程列表
                return courseList;
            }
            // 通过文件输入流创建工作簿对象
            excel = Workbook.getWorkbook(inputStream);
            // 获取工作表对象
            Sheet rs = excel.getSheet(0);
            // 定义行数
            int rowCount = 6;
            // 定义权重
            int weight = 2;

            // 获取合并单元格范围
            Range[] ranges = rs.getMergedCells();

            // 检查开始列和行是否超出工作表范围
            if (startCol + 7 - 1 > rs.getColumns() || startRow + rowCount - 1 > rs.getRows()) {
                // 如果超出范围，则直接返回空的课程列表
                return courseList;
            }

            // 调整开始列和行，因为 rs.getCell 以零开始
            startCol -= 2;
            startRow -= 2;

            // 遍历工作表中的每个单元格
            for (int i = 1; i <= 7; i++) {
                for (int j = 1; j <= rowCount; j++) {
                    // 获取单元格对象
                    Cell cell = rs.getCell(startCol + i, startRow + j);
                    // 获取单元格内容并处理
                    String str = handleCell(cell.getContents());

                    // 初始化行长度为1
                    int row_length = 1;
                    // 遍历合并单元格范围，找到当前单元格的行长度
                    for (Range range : ranges) {
                        if (range.getTopLeft() == cell) {
                            row_length = range.getBottomRight().getRow() - cell.getRow() + 1;
                            break;
                        }
                    }

                    // 如果单元格内容不为空
                    if (!str.isEmpty()) {
                        // 按换行符分割字符串
                        String[] strings = str.split("\n\n");

                        // 遍历分割后的字符串数组
                        for (String s : strings) {
                            // 调用处理结果接口的方法，处理单元格内容，并生成课程对象
                            Course course = handleResult.handle(s, j, i);
                            // 如果课程对象不为空
                            if (course != null) {
                                // 设置课程长度并添加到课程列表中
                                course.setClassLength(weight * row_length);
                                courseList.add(course);
                            }
                        }
                    }
                }
            }
            // 返回课程列表
            return courseList;
        } catch (BiffException | IOException e) {
            // 捕获异常，并打印异常信息
            e.printStackTrace();
            // 返回空
            return null;
        } finally {
            try {
                // 关闭工作簿和输入流
                if (excel != null)
                    excel.close();
                if (inputStream != null)
                    inputStream.close();
            } catch (IOException e) {
                // 捕获异常，并打印异常信息
                e.printStackTrace();
            }
        }
    }


    // 处理 Excel 文件，默认从第2行、第2列开始读取
    public static List<Course> handleExcel(String path, int startRow, int startCol) {
        // 调用 handleExcel 方法，并传入自定义的 HandleResult 函数接口实现
        return handleExcel(path, startRow, startCol, (courseStr, row, col) -> {
            // 从课程字符串解析课程信息
            Course course = getCourseFromString(courseStr);
            // 如果解析结果为空，则返回空
            if (course == null)
                return null;
            // 设置课程的周几和开始节数
            course.setDayOfWeek(col);
            course.setClassStart(row * 2 - 1);
            // 返回处理后的课程对象
            return course;
        });
    }

    // 处理 Excel 文件，默认从第2行、第2列开始读取
    public static List<Course> handleExcel(String path) {
        return handleExcel(path, 2, 2);
    }

    /**
     * 从表格中的内容提取课程信息
     *
     * @param str String 表格中的内容
     * @return Course 返回课程实体对象
     */
    public static Course getCourseFromString(String str) {
        // 使用换行符分割课程字符串，得到课程的各个内容
        String[] contents = str.split("\n");
        // 如果课程字符串的行数小于 4 行，则返回空，因为课程信息不完整
        if (contents.length < 4)
            return null;
        // 创建一个 Course 对象，用于存储解析后的课程信息
        Course course = new Course();
        // 设置课程的名称为第一行内容
        course.setName(contents[0]);
        // 设置课程的教师为第二行内容
        course.setTeacher(contents[2]);
        // 调用 getWeekOfTermFromString 方法解析第三行内容，并设置课程的学期周数
        course.setWeekOfTerm(getWeekOfTermFromString(contents[1]));
        // 设置课程的教室为第四行内容
        course.setClassRoom(contents[3]);
        // 返回解析后的课程对象
        return course;
    }

    // 解析周数字符串，返回一个整数表示周数
    // 定义一个静态方法，用于从字符串中获取学期的周数信息
    private static int getWeekOfTermFromString(String str) {
        // 使用正则表达式将字符串按照"["进行分割，存储到数组s1中
        String[] s1 = str.split("\\[");
        // 将s1数组的第一个元素再按照逗号进行分割，存储到数组s11中
        String[] s11 = s1[0].split(",");
        // 初始化周数为0
        int weekOfTerm = 0;
        // 遍历s11数组中的每个元素
        for (String s : s11) {
            // 如果元素为空或者为null，则继续下一次循环
            if (s == null || s.isEmpty())
                continue;
            // 如果元素包含"-"，表示有范围
            if (s.contains("-")) {
                // 初始化步长为2
                int space = 2;
                // 如果s1数组的第二个元素为"周]"，则步长设置为1
                if (s1[1].equals("周]")) {
                    space = 1;
                }
                // 将包含"-"的元素再按照"-"进行分割，存储到数组s2中
                String[] s2 = s.split("-");
                // 如果s2数组的长度不为2，输出错误信息并返回0
                if (s2.length != 2) {
                    System.out.println("error");
                    return 0;
                }
                // 将s2数组的第一个元素转换为整数，存储到p
                int p = Integer.parseInt(s2[0]);
                // 将s2数组的第二个元素转换为整数，存储到q
                int q = Integer.parseInt(s2[1]);
                // 遍历p到q之间的数字，步长为space，计算对应的周数并累加到weekOfTerm中
                for (int n = p; n <= q; n += space) {
                    weekOfTerm += 1 << (25 - n);
                }
            } else {
                // 如果元素不包含"-"，直接将其转换为整数，计算对应的周数并累加到weekOfTerm中
                weekOfTerm += 1 << (25 - Integer.parseInt(s));
            }
        }
        // 返回计算得到的总周数
        return weekOfTerm;
    }

    /**
     * 去除字符串的首尾回车和空格
     *
     * @param str String 待处理的字符串
     * @return String 处理后的字符串
     */
    private static String handleCell(String str) {
        str = str.replaceAll("^\n|\n$", ""); // 去除首尾换行符
        str = str.trim(); // 去除首尾空格
        return str;
    }
}
