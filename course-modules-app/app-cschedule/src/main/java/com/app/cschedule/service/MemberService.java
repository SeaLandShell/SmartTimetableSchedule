package com.app.cschedule.service;

import com.app.cschedule.common.support.IService;
import com.app.cschedule.entity.Member;

public interface MemberService extends IService<Member> {

    /**
     * 添加班级成员
     */
    int addMember(Member member);

    Member selectMember(Member member);

    /**
     * 给学生评分
     */
    Member gradeStudent(Member scoreForm);
}
