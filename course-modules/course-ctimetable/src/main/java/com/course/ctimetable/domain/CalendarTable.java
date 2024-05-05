package com.course.ctimetable.domain;

import com.course.common.core.annotation.Excel;
import com.course.common.core.web.domain.BaseEntity;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;

/**
 * 课表对象 calendar_table
 * 
 * @author course
 * @date 2024-05-03
 */
public class CalendarTable extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** $column.columnComment */
    private Long uuid;

    /** $column.columnComment */
    @Excel(name = "${comment}", readConverterExp = "$column.readConverterExp()")
    private Long userid;

    /** $column.columnComment */
    @Excel(name = "${comment}", readConverterExp = "$column.readConverterExp()")
    private String term;

    /** $column.columnComment */
    @Excel(name = "${comment}", readConverterExp = "$column.readConverterExp()")
    private String calendar;

    public void setUuid(Long uuid) 
    {
        this.uuid = uuid;
    }

    public Long getUuid() 
    {
        return uuid;
    }
    public void setUserid(Long userid) 
    {
        this.userid = userid;
    }

    public Long getUserid() 
    {
        return userid;
    }
    public void setTerm(String term) 
    {
        this.term = term;
    }

    public String getTerm() 
    {
        return term;
    }
    public void setCalendar(String calendar) 
    {
        this.calendar = calendar;
    }

    public String getCalendar() 
    {
        return calendar;
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this, ToStringStyle.MULTI_LINE_STYLE)
            .append("uuid", getUuid())
            .append("userid", getUserid())
            .append("term", getTerm())
            .append("calendar", getCalendar())
            .toString();
    }
}
