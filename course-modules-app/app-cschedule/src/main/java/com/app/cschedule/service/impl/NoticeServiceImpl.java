package com.app.cschedule.service.impl;

import com.app.cschedule.common.support.BaseService;
import com.app.cschedule.mapper.NoticeMapper;
import com.app.cschedule.entity.Notice;
import com.app.cschedule.service.NoticeService;
import org.apache.commons.lang3.RandomStringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Date;

@Service
public class NoticeServiceImpl extends BaseService<Notice> implements NoticeService {
    @Autowired
    private NoticeMapper noticeMapper;

    @Override
    public Notice addNotice(Notice notice) {
        notice.setNoticeId(RandomStringUtils.randomAlphanumeric(20));
        notice.setReleaseTime(new Date());
        noticeMapper.insert(notice);
        return notice;
    }
}
