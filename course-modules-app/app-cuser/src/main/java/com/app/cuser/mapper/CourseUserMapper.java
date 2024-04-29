package com.app.cuser.mapper;

import java.util.List;
import com.app.cuser.domain.CourseUser;
import org.apache.ibatis.annotations.*;

/**
 * 智课表用户Mapper接口
 *
 * @author course
 * @date 2024-03-27
 */
@Mapper
public interface CourseUserMapper
{
    @Select("SELECT count(*) FROM course_user WHERE phonenumber = #{phone}")
    int getUserCountByPhoneNumber(@Param("phone") String phone);


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

    @Select("SELECT user_id AS userId, dept_id AS deptId, user_name AS userName, nick_name AS nickName, " +
            "password AS password, user_type AS userType, email AS email, phonenumber AS phonenumber, " +
            "stu_tu_number AS stuTuNumber, sex AS sex, avatar AS avatar, birthday AS birthday, " +
            "status AS status, del_flag AS delFlag, login_ip AS loginIp, login_date AS loginDate, " +
            "create_by AS createBy, create_time AS createTime, update_by AS updateBy, update_time AS updateTime, " +
            "remark AS remark " +
            "FROM course_user WHERE user_name = #{username}")
    CourseUser selectCourseUserByUsername(@Param("username") String username);

    @Select("SELECT user_id AS userId, dept_id AS deptId, user_name AS userName, nick_name AS nickName, " +
            "password AS password, user_type AS userType, email AS email, phonenumber AS phonenumber, " +
            "stu_tu_number AS stuTuNumber, sex AS sex, avatar AS avatar, birthday AS birthday, " +
            "status AS status, del_flag AS delFlag, login_ip AS loginIp, login_date AS loginDate, " +
            "create_by AS createBy, create_time AS createTime, update_by AS updateBy, update_time AS updateTime, " +
            "remark AS remark " +
            "FROM course_user WHERE stu_tu_number = #{stuTuNumber}")
    CourseUser selectCourseUserByStuTuNumber(@Param("stuTuNumber") String stuTuNumber);

    @Select("SELECT * FROM course_user WHERE phonenumber = #{phone}")
    @Results(id = "CourseUserResultOne", value = {
            @Result(property = "userId", column = "user_id"),
            @Result(property = "deptId", column = "dept_id"),
            @Result(property = "userName", column = "user_name"),
            @Result(property = "nickName", column = "nick_name"),
            @Result(property = "password", column = "password"),
            @Result(property = "userType", column = "user_type"),
            @Result(property = "email", column = "email"),
            @Result(property = "phonenumber", column = "phonenumber"),
            @Result(property = "stuTuNumber", column = "stu_tu_number"),
            @Result(property = "sex", column = "sex"),
            @Result(property = "avatar", column = "avatar"),
            @Result(property = "birthday", column = "birthday"),
            @Result(property = "status", column = "status"),
            @Result(property = "delFlag", column = "del_flag"),
            @Result(property = "loginIp", column = "login_ip"),
            @Result(property = "loginDate", column = "login_date"),
            @Result(property = "createBy", column = "create_by"),
            @Result(property = "createTime", column = "create_time"),
            @Result(property = "updateBy", column = "update_by"),
            @Result(property = "updateTime", column = "update_time"),
            @Result(property = "remark", column = "remark")
    })
    CourseUser selectCourseUserByPhoneNumber(@Param("phone") String phone);

    @Update("UPDATE course_user SET avatar = #{avatar} WHERE phonenumber = #{phonenumber}")
    int updateUserAvatar(@Param("phonenumber") String phonenumber, @Param("avatar") String avatar);

}
