package com.app.zfjwxt.utils;

import com.app.zfjwxt.entity.CourseBean;
import com.app.zfjwxt.entity.ScoreBean;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;
import org.springframework.util.StringUtils;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class ParseUtil {
    public static String parseWeComImgSrc(String html) {
        Document document = Jsoup.parse(html);
        Elements img = document.getElementsByClass("qrcode");
        if (!img.isEmpty()) {
            String src = img.attr("src");
            return src;
        }
        return "获取src错误！";
    }
    public static List<ScoreBean> parseScoreHtml(String html) { // 定义方法，解析成绩HTML并返回ScoreBean列表
        List<ScoreBean> scoreList = new ArrayList<>(); // 初始化成绩列表
        // 解析HTML
        Document document = Jsoup.parse(html); // 使用Jsoup解析HTML文档
        Elements dateListRows = document.getElementsByClass("datelist").select("tr"); // 获取class为datelist的元素下的所有tr元素
        for (Element dateListRow : dateListRows) { // 遍历每个tr元素
            if (dateListRow.className().equals("datelisthead")) { // 如果tr元素的class为datelisthead，则跳过
                continue;
            }
            Elements dateListTds = dateListRow.select("td"); // 获取当前tr元素下的所有td元素
            ScoreBean scoreBean = new ScoreBean(); // 创建一个ScoreBean对象
            for (int j = 0; j < dateListTds.size(); j++) { // 遍历td元素列表
                String text = dateListTds.get(j).text(); // 获取td元素的文本内容
                switch (j) { // 根据td元素的索引进行不同的处理
                    case 0:
                        scoreBean.setXn(text); // 设置学年
                        break;
                    case 1:
                        scoreBean.setXq(text); // 设置学期
                        break;
                    case 2:
                        scoreBean.setCode(text); // 设置课程代码
                        break;
                    case 3:
                        scoreBean.setName(text); // 设置课程名称
                        break;
                    case 4:
                        scoreBean.setType(text); // 设置课程类型
                        break;
                    case 6:
                        scoreBean.setCredit(text); // 设置学分
                        break;
                    case 10:
                        scoreBean.setScore(text); // 设置成绩
                        break;
                    case 11:
                        scoreBean.setRetestScore(text); // 设置补考成绩
                        break;
                    case 12:
                        scoreBean.setIsRebuild(text); // 设置是否重修
                        break;
                    case 13:
                        scoreBean.setCollege(text); // 设置学院
                        break;
                    case 14:
                        scoreBean.setRemark(text); // 设置备注
                        break;
                    case 15:
                        scoreBean.setRetestRemark(text); // 设置补考备注
                        break;
                }
            }
            scoreList.add(scoreBean); // 将ScoreBean对象添加到成绩列表中
        }
        return scoreList; // 返回成绩列表
    }

    public static List<ScoreBean> parseScoreHtml2(String html) {
        List<ScoreBean> scoreList = new ArrayList<>();
        // 解析HTML
        Document document = Jsoup.parse(html);
        Elements dateListRows = document.getElementsByClass("datelist").select("tr");
        for (Element dateListRow : dateListRows) {
            if (dateListRow.className().equals("datelisthead")) {
                continue;
            }
            Elements dateListTds = dateListRow.select("td");
            ScoreBean scoreBean = new ScoreBean();
            for (int j = 0; j < dateListTds.size(); j++) {
                String text = dateListTds.get(j).text();
                switch (j) {
                    case 0:
                        scoreBean.setXn(text);
                        break;
                    case 1:
                        scoreBean.setXq(text);
                        break;
                    case 2:
                        scoreBean.setCode(text);
                        break;
                    case 3:
                        scoreBean.setName(text);
                        break;
                    case 4:
                        scoreBean.setType(text);
                        break;
                    case 6:
                        scoreBean.setCredit(text);
                        break;
                    case 12:
                        scoreBean.setScore(text);
                        break;
                    case 14:
                        text = !text.equals(" ") ? text : "无";
                        scoreBean.setRetestScore(text);
                        break;
                    case 16:
                        text = !text.equals(" ") ? text : "无";
                        scoreBean.setCollege(text);
                        break;
                    case 17:
                        text = !text.equals(" ") ? text : "无";
                        scoreBean.setRemark(text);
                        break;
                    case 18:
                        text = !text.isEmpty() ? text : "否";
                        scoreBean.setIsRebuild(text);
                        break;
                }
            }
            scoreList.add(scoreBean);
        }
        return scoreList;
    }

    public static ArrayList<CourseBean> parseCourseTableHtml(String html) {
        ArrayList<String> courseListHtml = getCourseListHtml(html);
        ArrayList<String> courseList = getCourseList(courseListHtml);
        ArrayList<CourseBean> cours = parseCourseList(courseList);
        return cours;
    }

    public static ArrayList<String> getCourseListHtml(String html) { // 定义方法，从HTML中获取课程列表并返回字符串列表
        // 解析HTML
        Document document = Jsoup.parse(html); // 使用Jsoup解析HTML文档
        Elements courseRows = document.getElementById("Table1").select("tr:nth-child(2n-1"); // 获取id为Table1的元素下奇数行tr元素
        ArrayList<String> courseHtmlList = new ArrayList<>(); // 创建一个字符串列表用于存储课程HTML
        for (int i = 1; i < courseRows.size(); i++) { // 遍历课程行
            Elements dateListTdsString = courseRows.get(i).select("td[rowspan=2]"); // 获取当前行下具有rowspan=2属性的td元素
            for (int j = 0; j < dateListTdsString.size(); j++) { // 遍历td元素列表
                String courseHtml = dateListTdsString.get(j).toString(); // 将td元素转换为字符串并添加到课程HTML列表中
                courseHtmlList.add(courseHtml);
            }
        }
        return courseHtmlList; // 返回课程HTML列表
    }

    public static ArrayList<String> getCourseList(ArrayList<String> courseListHtml) {
        // 删除调课信息
        String regex_font = "\\s<font.*?>(.*?)</font>";
        // 删除所有html标签，但保留标签内内容
        String regex_html = "<[^>]+(>*)";
        // 删除期末考试时间信息
        String regex_exam = "\\s(\\d{4})年(\\d{2})月(\\d{2})日(\\S+)\\s*(\\S*)";
        ArrayList<String> courseList = new ArrayList<>();
        for (String courseHtml : courseListHtml) {
            String courses = courseHtml.replaceAll("<br><br>", "  ").replaceAll("<br>", " ")
                    .replaceAll(regex_font, "").replaceAll(regex_html, "").replaceAll(regex_exam, "");
            courseList.addAll(Arrays.asList(courses.split("\\s{2}")));
        }
        return courseList;
    }

    public static ArrayList<CourseBean> parseCourseList(ArrayList<String> courseList) { // 定义方法，解析课程列表并返回CourseBean列表
        String regex_course = "(\\S+)\\s+(\\S+)\\s+(\\S{2})(\\S+)\\{第(\\d+)-(\\d+)周(\\S*)}\\s+(\\S+)\\s*(\\S*)"; // 定义正则表达式，用于匹配课程信息
        Pattern pattern1 = Pattern.compile(regex_course); // 编译正则表达式为Pattern对象
        ArrayList<CourseBean> cours = new ArrayList<>(); // 创建一个CourseBean列表用于存储课程信息
        String number = null; // 课程节数
        String day = null; // 星期几
        for (String str : courseList) { // 遍历课程列表
            CourseBean courseBean = new CourseBean(); // 创建一个CourseBean对象
            str = str.replaceAll("\\|", ""); // 替换课程信息中的竖线字符
            Matcher matcher = pattern1.matcher(str); // 使用正则表达式匹配课程信息
            if (matcher.find()) { // 如果匹配成功
                for (int i = 1; i <= matcher.groupCount(); i++) { // 遍历匹配的组
                    String text = matcher.group(i); // 获取当前组的文本内容
                    switch (i) { // 根据组的索引进行处理
                        case 1:
                            courseBean.setName(text); // 设置课程名称
                            break;
                        case 2:
                            courseBean.setType(text); // 设置课程性质
                            break;
                        case 3:
                            day = text; // 设置星期几
                            break;
                        case 4:
                            number = text; // 设置第几节
                            break;
                        case 5:
                            courseBean.setStartWeek(Integer.parseInt(text)); // 设置开课周
                            break;
                        case 6:
                            courseBean.setEndWeek(Integer.parseInt(text)); // 设置结课周
                            break;
                        case 7:
                            if (StringUtils.isEmpty(text)) {
                                courseBean.setWeekState(CourseBean.ALL_WEEK); // 设置周状态为全周
                            } else if (text.equals("单周")) {
                                courseBean.setWeekState(CourseBean.SINGLE_WEEK); // 设置周状态为单周
                            } else if (text.equals("双周")) {
                                courseBean.setWeekState(CourseBean.DOUBLE_WEEK); // 设置周状态为双周
                            }
                        case 8:
                            courseBean.setTeacher(text); // 设置任课老师
                            break;
                        case 9:
                            text = StringUtils.isEmpty(text) ? "暂无安排" : text; // 如果教室地点为空，则设置为"暂无安排"
                            courseBean.setClassRoom(text); // 设置教室地点
                            break;
                    }
                }
                courseBean.setSchoolTime(number, day); // 设置上课时间

                cours.add(courseBean); // 将CourseBean对象添加到列表中
                System.out.println(courseBean.toString()); // 打印课程信息
            }
        }
        return cours; // 返回课程信息列表
    }
}
