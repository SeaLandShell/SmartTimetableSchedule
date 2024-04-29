package com.app.cschedule.service.impl;

import com.app.cschedule.common.exception.ServiceException;
import com.app.cschedule.common.support.BaseService;
import com.app.cschedule.mapper.MemberMapper;
import com.app.cschedule.entity.Member;
import com.app.cschedule.service.MemberService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class MemberServiceImpl extends BaseService<Member> implements MemberService {
    @Autowired
    private MemberMapper memberMapper;

    @Override
    public int addMember(Member member) {
        if (memberMapper.selectOne(member) != null) {
            return 0;
        }
        return memberMapper.insert(member);
    }
    @Override
    public int updateMember(Member member){
        return  memberMapper.updateMember(member);
    }

    @Override
    public int customDelete(Member member){
        return memberMapper.customDelete(member);
    }
    @Override
    public Member selectMember(Member member){
        return memberMapper.selectOne(member);
    }

    @Override
    public Member gradeStudent(Member member) {
        memberMapper.grade(member);
        return memberMapper.selectOne(member);
    }
}