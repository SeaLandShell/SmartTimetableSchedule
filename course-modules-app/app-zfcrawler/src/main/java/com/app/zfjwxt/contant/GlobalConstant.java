package com.app.zfjwxt.contant;

/**
 * 常量接口类：所有常量的定义
 */
public interface GlobalConstant {
    public static final String BASE_URL = "https://wvpn.buu.edu.cn/https/77726476706e69737468656265737421fae0598869327d45300d8db9d6562d/?wechat_login=true&code=NynfM5J-HGMsnJ0GqUmq8MKP6E6BYodPQ10C5R8700Q&state=STATE&appid=wx7a6cf6f1a6305344";//    public static final String BASE_URL = "jwxt.buu.edu.cn";
    public static final String INDEX_URL = BASE_URL; // 教务系统首页
    public static final String LOGIN_URL = BASE_URL+"/default2.aspx";//教务系统登录请求地址
    public static final String MAIN_URL = BASE_URL+"/xs_main.aspx?xh=";//教务系统主页，菜单页
    public static final String SECRETCODE_URL = BASE_URL+"/CheckCode.aspx?vpn-1";//验证码请求地址
    public static final String USERNUMBER_NULL = "用户名不能为空！！";
    public static final String USERNUMBER_ERROR = "用户名不存在或未按照要求参加教学活动！！";
    public static final String CHECKCODE_NULL = "验证码不能为空，如看不清请刷新！！";// 验证码为空
    public static final String CHECKCODE_ERROR = "验证码不正确！！";// 验证码不正确
    public static final String PASSWORD_NULL = "密码不能为空！！";// 密码为空
    public static final String PASSWORD_ERROR = "密码错误";// 密码错误
}
