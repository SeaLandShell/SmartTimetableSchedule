package com.app.cuser.mapper;

import com.app.cuser.domain.Program;
import io.swagger.models.auth.In;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import java.util.List;

@Mapper
public interface ProgramMapper {
    @Select("select * from calendar where user_id = #{userId}")
    List<Program> getProgramsByUserId(@Param("userId") Integer userId);

    @Insert("INSERT INTO calendar (calendar_id, user_id, title) VALUES (#{calendarId}, #{userId}, #{title})")
    int addProgram(@Param("calendarId") String calendarId, @Param("userId") Integer userId, @Param("title") String title);
}
