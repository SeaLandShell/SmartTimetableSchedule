package com.app.cuser.service;

import com.app.cuser.domain.CourseUser;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 智课表用户Service接口
 * 
 * @author course
 * @date 2024-03-27
 */
public interface ICourseUserService 
{
    public CourseUser selectCourseUserByUsername(String username);
    public CourseUser selectCourseUserByPhoneNumber(String phone);
    public int getUserCountByPhoneNumber(String phone);

    /**
     * 查询智课表用户
     * 
     * @param userId 智课表用户主键
     * @return 智课表用户
     */
    public CourseUser selectCourseUserByUserId(Long userId);

    /**
     * 查询智课表用户列表
     * 
     * @param courseUser 智课表用户
     * @return 智课表用户集合
     */
    public List<CourseUser> selectCourseUserList(CourseUser courseUser);

    /**
     * 新增智课表用户
     * 
     * @param courseUser 智课表用户
     * @return 结果
     */
    public int insertCourseUser(CourseUser courseUser);

    /**
     * 修改智课表用户
     * 
     * @param courseUser 智课表用户
     * @return 结果
     */
    public int updateCourseUser(CourseUser courseUser);
    public int updateCourseUserByObject(CourseUser courseUser);

    /**
     * 批量删除智课表用户
     * 
     * @param userIds 需要删除的智课表用户主键集合
     * @return 结果
     */
    public int deleteCourseUserByUserIds(Long[] userIds);

    /**
     * 删除智课表用户信息
     * 
     * @param userId 智课表用户主键
     * @return 结果
     */
    public int deleteCourseUserByUserId(Long userId);

    public boolean updateUserAvatar(String userName, String avatar);

}
