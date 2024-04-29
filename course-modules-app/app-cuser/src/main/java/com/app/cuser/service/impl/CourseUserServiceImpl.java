package com.app.cuser.service.impl;

import com.course.common.core.utils.DateUtils;
import com.app.cuser.domain.CourseUser;
import com.app.cuser.mapper.CourseUserMapper;
import com.app.cuser.service.ICourseUserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

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

    @Override
    public CourseUser selectCourseUserByUsername(String username){
        return courseUserMapper.selectCourseUserByUsername(username);
    }

    @Override
    public CourseUser selectCourseUserByPhoneNumber(String phone){
        return courseUserMapper.selectCourseUserByPhoneNumber(phone);
    }
    @Override
    public int getUserCountByPhoneNumber(String phone){
        return courseUserMapper.getUserCountByPhoneNumber(phone);
    }

    @Override
    public CourseUser selectCourseUserByStuTuNumber(String stuTuNumber){
        return courseUserMapper.selectCourseUserByStuTuNumber(stuTuNumber);
    }

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
    @Override
    public int updateCourseUserByObject(CourseUser courseUser)
    {
        courseUser.setUpdateTime(DateUtils.getNowDate());
        return courseUserMapper.updateCourseUserByObject(courseUser);
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

    @Override
    public boolean updateUserAvatar(String userName, String avatar)
    {
        return courseUserMapper.updateUserAvatar(userName, avatar) > 0;
    }
}
