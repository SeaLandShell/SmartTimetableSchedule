package com.app.cschedule.service;

import com.app.cschedule.common.support.IService;
import com.app.cschedule.entity.Notice;

public interface NoticeService extends IService<Notice> {

    /**
     * 添加班级通知
     */
    Notice addNotice(Notice notice);

}
