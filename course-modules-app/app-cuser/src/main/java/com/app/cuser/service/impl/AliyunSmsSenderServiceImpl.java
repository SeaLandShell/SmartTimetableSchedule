package com.app.cuser.service.impl;

import com.aliyuncs.DefaultAcsClient;
import com.aliyuncs.IAcsClient;
import com.aliyuncs.dysmsapi.model.v20170525.QuerySendDetailsRequest;
import com.aliyuncs.dysmsapi.model.v20170525.QuerySendDetailsResponse;
import com.aliyuncs.dysmsapi.model.v20170525.SendSmsRequest;
import com.aliyuncs.dysmsapi.model.v20170525.SendSmsResponse;
import com.aliyuncs.exceptions.ClientException;
import com.aliyuncs.profile.DefaultProfile;
import com.aliyuncs.profile.IClientProfile;
import com.app.cuser.service.AliyunSmsSenderService;
import com.app.cuser.util.AliyunSMSConfig;
import com.app.cuser.util.Sms;
import com.app.cuser.util.SmsQuery;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.text.SimpleDateFormat;
import java.util.Date;

/**
 * @Author: LX 17839193044@162.com
 * @Description: 发送短信封装服务实现类
 * @Date: 2019/4/18 15:36
 * @Version: V1.0
 */
@Slf4j
@Service
public class AliyunSmsSenderServiceImpl implements AliyunSmsSenderService {

    @Resource
    private AliyunSMSConfig smsConfig;

    /**
     * @param phoneNumbers:      手机号
     * @param templateParamJson: 模板参数json {"sellerName":"123456","orderSn":"123456"}
     * @param templateCode:      阿里云短信模板code
     * @Author: LX 17839193044@162.com
     * @Description: 对接阿里云短信服务实现短信发送
     * 发送验证码类的短信时，每个号码每分钟最多发送一次，每个小时最多发送5次。其它类短信频控请参考阿里云
     * @Date: 2019/4/18 16:35
     * @Version: V1.0
     */
    @Override
    public SendSmsResponse  sendSms(String phoneNumbers, String templateParamJson, String templateCode) {

        // 封装短信发送对象
        Sms sms = new Sms();
        sms.setPhoneNumbers(phoneNumbers);
        sms.setTemplateParam(templateParamJson);
        sms.setTemplateCode(templateCode);

        // 获取短信发送服务机
        IAcsClient acsClient = getClient();

        //获取短信请求
        SendSmsRequest request = getSmsRequest(sms);
        SendSmsResponse sendSmsResponse = new SendSmsResponse();//见外部全局变量

        try {
            sendSmsResponse = acsClient.getAcsResponse(request);
        } catch (ClientException e) {
            log.error("发送短信发生错误。错误代码是 [{}]，错误消息是 [{}]，错误请求ID是 [{}]，错误Msg是 [{}]，错误类型是 [{}]",
                    e.getErrCode(),
                    e.getMessage(),
                    e.getRequestId(),
                    e.getErrMsg(),
                    e.getErrorType());
        }
        return sendSmsResponse;
    }

    /**
     * @param bizId:       短信对象的对应的bizId
     * @param phoneNumber: 手机号
     * @param pageSize:    分页大小
     * @param currentPage: 当前页码
     * @Author: LX 17839193044@162.com
     * @Description: 查询发送短信的内容
     * @Date: 2019/4/18 16:52
     * @Version: V1.0
     */
    @Override
    public QuerySendDetailsResponse querySendDetails(String bizId, String phoneNumber, Long pageSize, Long currentPage) {
        // 查询实体封装
        SmsQuery smsQuery = new SmsQuery();
        smsQuery.setBizId(bizId);
        smsQuery.setPhoneNumber(phoneNumber);
        smsQuery.setCurrentPage(currentPage);
        smsQuery.setPageSize(pageSize);
        smsQuery.setSendDate(new Date());

        // 获取短信发送服务机
        IAcsClient acsClient = getClient();
        QuerySendDetailsRequest request = getSmsQueryRequest(smsQuery);  //见外部全局变量
        QuerySendDetailsResponse querySendDetailsResponse = null;
        try {
            querySendDetailsResponse = acsClient.getAcsResponse(request);
        } catch (ClientException e) {
            log.error("查询发送短信发生错误。错误代码是 [{}]，错误消息是 [{}]，错误请求ID是 [{}]，错误Msg是 [{}]，错误类型是 [{}]",
                    e.getErrCode(),
                    e.getMessage(),
                    e.getRequestId(),
                    e.getErrMsg(),
                    e.getErrorType());
        }
        return querySendDetailsResponse;
    }

    /**
     * @param smsQuery:
     * @Author: LX 17839193044@162.com
     * @Description: 封装查询阿里云短信请求对象
     * @Date: 2019/4/18 16:51
     * @Version: V1.0
     */
    private QuerySendDetailsRequest getSmsQueryRequest(SmsQuery smsQuery) {
        QuerySendDetailsRequest request = new QuerySendDetailsRequest();
        request.setPhoneNumber(smsQuery.getPhoneNumber());
        request.setBizId(smsQuery.getBizId());
        SimpleDateFormat ft = new SimpleDateFormat(smsConfig.getDateFormat());
        request.setSendDate(ft.format(smsQuery.getSendDate()));
        request.setPageSize(smsQuery.getPageSize());
        request.setCurrentPage(smsQuery.getCurrentPage());
        return request;
    }


    /**
     * @param sms: 短信发送实体
     * @Author: LX 17839193044@162.com
     * @Description: 获取短信请求
     * @Date: 2019/4/18 16:40
     * @Version: V1.0
     */
    private SendSmsRequest getSmsRequest(Sms sms) {
        SendSmsRequest request = new SendSmsRequest();
        request.setPhoneNumbers(sms.getPhoneNumbers());
        request.setSignName(smsConfig.getSignName());
        request.setTemplateCode(sms.getTemplateCode());
        request.setTemplateParam(sms.getTemplateParam());
        request.setOutId(sms.getOutId());
        return request;
    }

    /**
     * @Author: LX 17839193044@162.com
     * @Description: 获取短信发送服务机
     * @Date: 2019/4/18 16:38
     * @Version: V1.0
     */
    private IAcsClient getClient() {

        IClientProfile profile = DefaultProfile.getProfile(smsConfig.getRegionId(),
                smsConfig.getAccessKeyId(),
                smsConfig.getAccessKeySecret());

        try {
            DefaultProfile.addEndpoint(smsConfig.getEndpointName(),
                    smsConfig.getRegionId(),
                    smsConfig.getProduct(),
                    smsConfig.getDomain());
        } catch (ClientException e) {
            log.error("获取短信发送服务机发生错误。错误代码是 [{}]，错误消息是 [{}]，错误请求ID是 [{}]，错误Msg是 [{}]，错误类型是 [{}]",
                    e.getErrCode(),
                    e.getMessage(),
                    e.getRequestId(),
                    e.getErrMsg(),
                    e.getErrorType());
        }
        return new DefaultAcsClient(profile);
    }
}

