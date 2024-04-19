package com.app.cschedule.common.typehandler; // 定义包名为 com.app.cschedule.common.typehandler

import org.apache.ibatis.type.JdbcType; // 导入 JdbcType 类
import org.apache.ibatis.type.TypeHandler; // 导入 TypeHandler 接口

import java.sql.CallableStatement; // 导入 CallableStatement 类
import java.sql.PreparedStatement; // 导入 PreparedStatement 类
import java.sql.ResultSet; // 导入 ResultSet 类
import java.sql.SQLException; // 导入 SQLException 类

/**
 * 自定义 TypeHandler 类 BooleanAndIntConverter
 *
 * - 实现 TypeHandler<Boolean> 接口，指定泛型为 Boolean
 */
public class BooleanAndIntConverter implements TypeHandler<Boolean> { // 定义 BooleanAndIntConverter 类并实现 TypeHandler<Boolean> 接口
    @Override
    public void setParameter(PreparedStatement ps, int i, Boolean aBoolean, JdbcType jdbcType) throws SQLException {
        // 设置参数方法，根据 Boolean 值设置 PreparedStatement 中的参数为对应的整数值
        if(aBoolean) { // 如果 aBoolean 为 true
            ps.setInt(i, 1); // 将参数设置为 1
        } else { // 如果 aBoolean 为 false
            ps.setInt(i, 0); // 将参数设置为 0
        }
    }

    @Override
    public Boolean getResult(ResultSet rs, String s) throws SQLException {
        // 从 ResultSet 中获取结果方法，将整数值转换为 Boolean 类型返回
        return rs.getInt(s) == 1; // 返回 ResultSet 中指定列的整数值是否等于 1
    }

    @Override
    public Boolean getResult(ResultSet rs, int i) throws SQLException {
        // 从 ResultSet 中获取结果方法，将整数值转换为 Boolean 类型返回
        return rs.getInt(i) == 1; // 返回 ResultSet 中指定索引列的整数值是否等于 1
    }

    @Override
    public Boolean getResult(CallableStatement cs, int i) throws SQLException {
        // 从 CallableStatement 中获取结果方法，将整数值转换为 Boolean 类型返回
        return cs.getInt(i) == 1; // 返回 CallableStatement 中指定索引位置的整数值是否等于 1
    }
}