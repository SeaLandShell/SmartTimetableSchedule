package com.app.cschedule.common.support.builder;

import com.app.cschedule.common.support.BaseMapper;
import com.google.common.base.CaseFormat;
import org.apache.ibatis.builder.annotation.ProviderContext;
import java.lang.reflect.Field;

/**
 * 用于构建插入 SQL 语句的工具类。
 *
 * 注意：如果表中存在 gmt_create、gmt_modified 字段，则插入该字段；如果表中无该字段，则不管。
 */
public class InsertSqlBuilder {

    /**
     * 构建插入数据的 SQL 语句。
     *
     * @param context MyBatis 提供的 ProviderContext 对象
     * @param obj 要插入的对象
     * @return 插入数据的 SQL 语句
     */
    public String buildInsert(ProviderContext context, Object obj) throws IllegalAccessException, InstantiationException {
        // 获取表名
        final String table = context.getMapperType().getAnnotation(BaseMapper.Meta.class).table();
        // 获取对象的所有字段
        Field[] fields = obj.getClass().getDeclaredFields();

        // 生成 SQL
        StringBuilder sql = new StringBuilder("INSERT INTO ").append(table).append("(");
        StringBuilder values = new StringBuilder(" VALUES(");

        // 遍历字段，添加存在值的字段和值
        for (Field field : fields) {
            field.setAccessible(true);
            // 将字段名转换为下划线命名方式
            String fieldName = CaseFormat.LOWER_CAMEL.to(CaseFormat.LOWER_UNDERSCORE, field.getName());
            // 如果字段的值不为 null，则添加到 SQL 语句中
            if (field.get(obj) != null) {
                sql.append(fieldName).append(",");
                values.append("#{").append(field.getName()).append("},");
            }
        }

        // 在 SQL 语句末尾添加封闭符号
        if (sql.charAt(sql.length() - 1) == ',') {
            sql.deleteCharAt(sql.length() - 1); // 删除最后一个逗号
            values.deleteCharAt(values.length() - 1); // 删除最后一个逗号
        }

        // 添加 VALUES 关键字并合并 SQL 语句
        return sql.append(") ").append(values).append(");").toString();
    }
}
