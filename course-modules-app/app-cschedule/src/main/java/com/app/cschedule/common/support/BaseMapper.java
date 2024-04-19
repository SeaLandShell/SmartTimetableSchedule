package com.app.cschedule.common.support;

import com.app.cschedule.common.support.builder.DeleteSqlBuilder;
import com.app.cschedule.common.support.builder.InsertSqlBuilder;
import com.app.cschedule.common.support.builder.SelectSqlBuilder;
import com.app.cschedule.common.support.builder.UpdateSqlBuilder;
import org.apache.ibatis.annotations.*;
import org.springframework.stereotype.Repository;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;
import java.util.List;

/**
 * 使用时注意：
 * 实体类字段必须为包装类型，否则参数是实体类时可能出现错误
 * 思考优化
 *
 * @author ankoye@qq.com
 */
public interface BaseMapper<T> {
    @SelectProvider(type = SelectSqlBuilder.class, method= "buildSelectById") // 使用SelectSqlBuilder类中的buildSelectById方法作为查询语句提供者
    T selectById(Object id); // 根据id查询记录

    @SelectProvider(type = SelectSqlBuilder.class, method= "buildSelectByExId") // 使用SelectSqlBuilder类中的buildSelectByExId方法作为查询语句提供者
    T selectByExId(Object exId); // 根据exId查询记录

    @SelectProvider(type = SelectSqlBuilder.class, method= "buildSelectList") // 使用SelectSqlBuilder类中的buildSelectList方法作为查询语句提供者
    T selectOne(T t); // 查询单条记录

    @SelectProvider(type = SelectSqlBuilder.class, method= "buildSelectList") // 使用SelectSqlBuilder类中的buildSelectList方法作为查询语句提供者
    List<T> selectList(T t); // 查询记录列表

    @SelectProvider(type = SelectSqlBuilder.class, method = "buildSelectAll") // 使用SelectSqlBuilder类中的buildSelectAll方法作为查询语句提供者
    List<T> selectAll(); // 查询所有记录

    @InsertProvider(type = InsertSqlBuilder.class, method = "buildInsert") // 使用InsertSqlBuilder类中的buildInsert方法作为插入语句提供者
    int insert(T t); // 插入记录

    @UpdateProvider(type = UpdateSqlBuilder.class, method = "buildUpdateById") // 使用UpdateSqlBuilder类中的buildUpdateById方法作为更新语句提供者
    int updateById(T t); // 根据id更新记录

    @UpdateProvider(type = UpdateSqlBuilder.class, method = "buildUpdateByExId") // 使用UpdateSqlBuilder类中的buildUpdateByExId方法作为更新语句提供者
    int updateByExId(T t); // 根据exId更新记录

    @DeleteProvider(type = DeleteSqlBuilder.class, method = "buildDelete") // 使用DeleteSqlBuilder类中的buildDelete方法作为删除语句提供者
    int delete(T t); // 删除记录

    @DeleteProvider(type = DeleteSqlBuilder.class, method = "buildDeleteByExId") // 使用DeleteSqlBuilder类中的buildDeleteByExId方法作为删除语句提供者
    int deleteByExId(Object exId); // 根据exId删除记录

    @DeleteProvider(type = DeleteSqlBuilder.class, method = "buildDeleteById") // 使用DeleteSqlBuilder类中的buildDeleteById方法作为删除语句提供者
    int deleteById(Object id); // 根据id删除记录

    /**
     * 元注解
     * table - 表名
     * id    - 表id
     */
    @Retention(RetentionPolicy.RUNTIME)
    @Target(ElementType.TYPE)
    @interface Meta {
        String table(); // 定义表名
        String exId() default ""; // 定义exId，默认为空字符串
    }
}