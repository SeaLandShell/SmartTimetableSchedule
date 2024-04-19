package com.course.cuser.mapper;

import java.util.List;
import com.course.cuser.domain.CourseUser;

/**
 * 智课表用户Mapper接口
 * 
 * @author course
 * @date 2024-03-27
 */
public interface CourseUserMapper 
{
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

    /**
     * 删除智课表用户
     * 
     * @param userId 智课表用户主键
     * @return 结果
     */
    public int deleteCourseUserByUserId(Long userId);

    /**
     * 批量删除智课表用户
     * 
     * @param userIds 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteCourseUserByUserIds(Long[] userIds);
}
