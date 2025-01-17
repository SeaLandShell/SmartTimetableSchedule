package com.app.cschedule.mapper;

import com.app.cschedule.entity.Log;
import org.apache.ibatis.annotations.Insert;
import org.springframework.stereotype.Repository;

@Repository
public interface LogMapper {
    @Insert("INSERT INTO " +
            "t_log(user_id, module, operation, method, params, time, ip, create_time) " +
            "values(#{userId}, #{module}, #{operation}, #{method}, #{params}, #{time}, #{ip}, #{createTime, jdbcType=TIMESTAMP})")
    int save(Log log);
}
