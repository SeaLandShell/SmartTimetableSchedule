package com.course.cuser.service.impl;

import java.util.List;
import com.course.common.core.utils.DateUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.course.cuser.mapper.CourseUserMapper;
import com.course.cuser.domain.CourseUser;
import com.course.cuser.service.ICourseUserService;

/**
 * 智课表用户Service业务层处理
 * 
 * @author course
 * @date 2024-03-27
 */
@Service
public class CourseUserServiceImpl implements ICourseUserService 
{
    @Autowired
    private CourseUserMapper courseUserMapper;

    /**
     * 查询智课表用户
     * 
     * @param userId 智课表用户主键
     * @return 智课表用户
     */
    @Override
    public CourseUser selectCourseUserByUserId(Long userId)
    {
        return courseUserMapper.selectCourseUserByUserId(userId);
    }

    /**
     * 查询智课表用户列表
     * 
     * @param courseUser 智课表用户
     * @return 智课表用户
     */
    @Override
    public List<CourseUser> selectCourseUserList(CourseUser courseUser)
    {
        return courseUserMapper.selectCourseUserList(courseUser);
    }

    /**
     * 新增智课表用户
     * 
     * @param courseUser 智课表用户
     * @return 结果
     */
    @Override
    public int insertCourseUser(CourseUser courseUser)
    {
        courseUser.setCreateTime(DateUtils.getNowDate());
        return courseUserMapper.insertCourseUser(courseUser);
    }

    /**
     * 修改智课表用户
     * 
     * @param courseUser 智课表用户
     * @return 结果
     */
    @Override
    public int updateCourseUser(CourseUser courseUser)
    {
        courseUser.setUpdateTime(DateUtils.getNowDate());
        return courseUserMapper.updateCourseUser(courseUser);
    }

    /**
     * 批量删除智课表用户
     * 
     * @param userIds 需要删除的智课表用户主键
     * @return 结果
     */
    @Override
    public int deleteCourseUserByUserIds(Long[] userIds)
    {
        return courseUserMapper.deleteCourseUserByUserIds(userIds);
    }

    /**
     * 删除智课表用户信息
     * 
     * @param userId 智课表用户主键
     * @return 结果
     */
    @Override
    public int deleteCourseUserByUserId(Long userId)
    {
        return courseUserMapper.deleteCourseUserByUserId(userId);
    }
}
