package com.app.ctimetable.service.colleges.impl;

import com.app.ctimetable.entity.Course; // 导入课程实体类
import com.app.ctimetable.service.colleges.College; // 导入学院服务类
import com.app.ctimetable.utils.OkHttpUtils; // 导入OkHttp工具类
import com.app.ctimetable.utils.TextUtils; // 导入文本工具类
import com.google.gson.Gson; // 导入Gson库
import com.google.gson.annotations.SerializedName; // 导入Gson的SerializedName注解
import com.google.gson.reflect.TypeToken; // 导入Gson的TypeToken类
import okhttp3.FormBody; // 导入OkHttp的FormBody类
import okhttp3.Request; // 导入OkHttp的Request类
import okhttp3.Response; // 导入OkHttp的Response类
import org.jsoup.Jsoup; // 导入Jsoup库
import org.jsoup.nodes.Document; // 导入Jsoup的Document类
import org.jsoup.nodes.Element; // 导入Jsoup的Element类
import org.jsoup.select.Elements; // 导入Jsoup的Elements类
import org.slf4j.Logger; // 导入Slf4j的Logger类
import org.slf4j.LoggerFactory; // 导入Slf4j的LoggerFactory类
import org.springframework.stereotype.Component; // 导入Spring的Component注解

import java.io.IOException; // 导入IOException类
import java.util.ArrayList; // 导入ArrayList类
import java.util.LinkedList; // 导入LinkedList类
import java.util.List; // 导入List类
import java.util.stream.Collectors; // 导入流式操作Collectors类


@Component
//@Scope(value = WebApplicationContext.SCOPE_SESSION, proxyMode = ScopedProxyMode.INTERFACES)
public class BUUCollege implements College {
    private final Logger logger = LoggerFactory.getLogger(getClass());
    public static final String NAME = "北京联合大学";

    private static final String BASE_URL = "https://wvpn.buu.edu.cn/" +
            "https/77726476706e69737468656265737421fae0598869327d45300d8db9d6562d/?" +
            "wechat_login=true&code=NynfM5J-HGMsnJ0GqUmq8MKP6E6BYodPQ10C5R8700Q&state=STATE&appid=wx7a6cf6f1a6305344";
    // 加密
    private static final String SESS_URL = BASE_URL + "/Logon.do?method=logon&flag=sess";
    // 登陆
    private static final String LOGIN_URL = BASE_URL + "/Logon.do?method=logon";
    // 验证码
    private static final String RANDOM_CODE_URL = BASE_URL + "/verifycode.servlet";
    // 首页
    private static final String INDEX_URL = BASE_URL + "/jsxsd/framework/xsMain.jsp";
    // 打印课程表
    private static final String TIMETABLE_EXCEL_URL = BASE_URL + "/jsxsd/xskb/printXsgrkb.do?xnxq01id=%s&zc=";
    // 课程表json
    private static final String TIMETABLE_JSON_URL = BASE_URL + "/jsxsd/kbxx/getKbxx.do";
    // 我的课表
    private static final String TERMS_URL = BASE_URL + "/jsxsd/xskb/xskb_list.do?Ves632DSdyV=NEW_XSD_WDKB";

    private static final List<Course> EMPTY_COURSE_LIST = new ArrayList<>(0);

    @Override
    public String getCollegeName() {
        return NAME;
    }
    @Override
    public String getBase64CodeForWeCom(){

        return "";
    }

    @Override
    public boolean login(String account, String pw, String RandomCode, String cookie) {
        String encoded = encode(account, pw, cookie);
        //String data = "view=0&useDogCode=&encoded=" + encoded + "&RANDOMCODE=" + RandomCode;

        FormBody form = new FormBody.Builder()
                .add("view", "0")
                .add("useDogCode", "")
                .add("encoded", encoded)
                .add("RANDOMCODE", RandomCode)
                .build();

        Request request = new Request.Builder()
                .url(LOGIN_URL)
                .addHeader("Cookie", cookie)
                .post(form)
                .build();
        try {
            String result = OkHttpUtils.downloadText(request);
            if (!TextUtils.isEmpty(result)) {
                Document doc = Jsoup.parse(result);
                return doc.title().equals("学生个人中心");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public boolean isLogin(String cookie) {
        String result = OkHttpUtils.downloadText(createRequestWithCookie(INDEX_URL, cookie));
        if (!TextUtils.isEmpty(result)) {
            Document doc = Jsoup.parse(result);
            return doc.title().equals("学生个人中心");
        }
        return false;
    }

    private String encode(String account, String pw, String cookie) {
        String result = OkHttpUtils.downloadText(createRequestWithCookie(SESS_URL, cookie));
        if (TextUtils.isEmpty(result))
            return "";
        String[] strings = result.split("#");
        String scode = strings[0];
        String sxh = strings[1];
        String code = account + "%%%" + pw;
        StringBuilder encoded = new StringBuilder();
        for (int i = 0; i < code.length(); i++) {
            if (i < 50) {
                encoded.append(code.charAt(i));
                int value = Integer.parseInt(String.valueOf(sxh.charAt(i)));
                encoded.append(scode, 0, value);
                scode = scode.substring(value);
            } else {
                encoded.append(code.substring(i));
                i = code.length();
            }
        }
        return encoded.toString();
    }

    @Override
    public List<Course> getCourses(String term, String cookie) {
        FormBody form = new FormBody.Builder()
                .add("xnxq01id", term)
                .add("zc", "")
                .build();
        Request request = new Request.Builder()
                .url(TIMETABLE_JSON_URL)
                .addHeader("Cookie", cookie)
                .post(form)
                .build();
        String json = OkHttpUtils.downloadText(request);
        if (TextUtils.isEmpty(json)) {
            return EMPTY_COURSE_LIST;
        }
        List<TimetableItem> list = new Gson().fromJson(json, new TypeToken<List<TimetableItem>>() {
        }.getType());

        if (list == null) {
            return EMPTY_COURSE_LIST;
        }

        List<Course> courseList = new ArrayList<>(list.size());
        for (TimetableItem item : list) {
            if (item.lesson > 6) {
                continue;
            }
            for (String content : item.title.split("\n\n")) {
                //课程名称：大学英语（一）\n上课教师：黄莹讲师（高校）\n周次：5-19(周)\n星期：星期一\n节次：0102节\n上课地点：外语网络楼449\n
                String[] lines = content.split("\n");
                if (lines.length != 6) {
                    continue;
                }
                Course course = new Course();
                course.setName(getValue(lines[0]));
                course.setTeacher(getValue(lines[1]));
                course.setClassRoom(getValue(lines[5]));
                course.setClassStart((item.lesson - 1) * 2 + 1);
                String str = getValue(lines[4]);// 0102节
                str = str.substring(0, str.length() - 1);//0102
                try {
                    int min = Integer.parseInt(str.substring(0, 2));
                    int max = Integer.parseInt(str.substring(str.length() - 2));
                    course.setClassLength(max - min + 1);
                } catch (NumberFormatException e) {
                    e.printStackTrace();
                    course.setClassLength(2);
                }

                int week = item.DayOfWeek - 1;
                if (week == 0) {
                    week = 7;
                }
                course.setDayOfWeek(week);

                course.setWeekOfTerm(getWeekOfTermFromString(getValue(lines[2])));
                courseList.add(course);
            }
        }
        return courseList;
    }

    private String getValue(String line) {
        return line.substring(line.indexOf('：') + 1).trim();
    }

    private int getWeekOfTermFromString(String text) {
        //Log.d("excel",text);
        String[] s1 = text.trim().split("\\(");
        String[] s11 = s1[0].split(",");

        int weekOfTerm = 0;
        for (String s : s11) {
            if (s == null || s.isEmpty())
                continue;
            if (s.contains("-")) {
                int space = 2;
                if (text.contains("(周)")) {
                    space = 1;
                }
                String[] s2 = s.split("-");
                if (s2.length != 2) {
                    return 0;
                }
                int min = Integer.parseInt(s2[0]);
                int max = Integer.parseInt(s2[1]);
                if (text.contains("单") && min % 2 == 0) {
                    min++;
                } else if (text.contains("双") && min % 2 == 1) {
                    min++;
                }

                for (int n = min; n <= max; n += space) {
                    weekOfTerm += 1 << (25 - n);
                }
            } else {
                weekOfTerm += 1 << (25 - Integer.parseInt(s));
            }
        }
        return weekOfTerm;
    }

    /*        "jc": 1,
         "title": "课程名称：大学英语（一）\n上课教师：黄莹讲师（高校）\n周次：5-19(周)\n星期：星期一\n节次：0102节\n上课地点：外语网络楼449\n",
         "xq": 2,
         "kcmc": "大学英语（..."

         */
    private static class TimetableItem {
        /**
         * 第几节课
         * 值[1,7]
         * 7表示备注
         */
        @SerializedName("jc")
        private int lesson;
        /**
         * 星期几
         * 数值1-7
         * 1表示周日，依次类推
         */
        @SerializedName("xq")
        private int DayOfWeek;
        private String title;
        private String kcmc;
    }

    @Override
    public byte[] getRandomCodeImg(String cookie) {
        return OkHttpUtils.downloadRaw(createRequestWithCookie(RANDOM_CODE_URL, cookie));
    }

    @Override
    public List<String> getTermOptions(String cookie) {
        List<String> termOptions = new LinkedList<>();
        try {
            String result = OkHttpUtils.downloadText(createRequestWithCookie(TERMS_URL, cookie));
            if (!TextUtils.isEmpty(result)) {
                Document doc = Jsoup.parse(result);
                Element e = doc.select("#xnxq01id").first();
                Elements es = e.children();
                for (Element element : es) {
                    termOptions.add(element.text().trim());
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return termOptions;
    }

    @Override
    public boolean getFollowRedirects() {
        return true;
    }

    @Override
    public int getRandomCodeMaxLength() {
        return 4;
    }

    @Override
    public String getCookie() {
        try (Response response = OkHttpUtils.getOkHttpClient()
                .newCall(OkHttpUtils.createRequest(BASE_URL))
                .execute()) {
            List<String> list = response.headers("Set-Cookie").stream().map(cookie -> {
                if (TextUtils.isEmpty(cookie)) {
                    return "";
                }
                int index = cookie.indexOf(';');
                return index != -1 ? cookie.substring(0, index) : cookie;
            }).collect(Collectors.toList());
            response.close();

            return String.join("; ", list);
        } catch (IOException e) {
            e.printStackTrace();
        }
        return "";
    }
}
