package com.app.cuser.util;

import lombok.Data;
import lombok.ToString;

/**
 * @Author: LX 17839193044@162.com
 * @Description: 发送短信实体
 * @Date: 15:42 2019/4/18
 * @Version: V1.0
 */
@Data
@ToString
public class Sms {

    /**
     * 手机号
     */
    private String phoneNumbers;

    /**
     * 模板参数 格式："{\"code\":\"123456\"}"
     */
    private String templateParam;//短信模板变量对应的实际值。支持传入多个参数，示例：{"name":"张三","number":"1390000****"}。(非必须)

    private String outId;//外部流水扩展字段。

    /**
     * 阿里云模板管理code
     */
    private String templateCode;//您可以登录短信服务控制台，选择国内消息或国际/港澳台消息，在模板管理页面查看模板CODE。
}
