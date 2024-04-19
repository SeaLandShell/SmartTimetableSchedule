package com.app.cuser.util;

import lombok.Data;
import lombok.ToString;

import java.util.Date;

/**
 * @Author: LX 17839193044@162.com
 * @Description: 短信查询实体
 * @Date: 15:51 2019/4/18
 * @Version: V1.0
 */
@Data
@ToString
public class SmsQuery {
    private String bizId;
    private String phoneNumber;
    private Date sendDate;
    private Long pageSize;
    private Long currentPage;
}
