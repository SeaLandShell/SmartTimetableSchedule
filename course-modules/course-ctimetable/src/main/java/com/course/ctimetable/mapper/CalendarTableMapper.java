package com.course.ctimetable.mapper;

import java.util.List;
import com.course.ctimetable.domain.CalendarTable;

/**
 * 课表Mapper接口
 * 
 * @author course
 * @date 2024-05-03
 */
public interface CalendarTableMapper 
{
    /**
     * 查询课表
     * 
     * @param uuid 课表主键
     * @return 课表
     */
    public CalendarTable selectCalendarTableByUuid(Long uuid);

    /**
     * 查询课表列表
     * 
     * @param calendarTable 课表
     * @return 课表集合
     */
    public List<CalendarTable> selectCalendarTableList(CalendarTable calendarTable);

    /**
     * 新增课表
     * 
     * @param calendarTable 课表
     * @return 结果
     */
    public int insertCalendarTable(CalendarTable calendarTable);

    /**
     * 修改课表
     * 
     * @param calendarTable 课表
     * @return 结果
     */
    public int updateCalendarTable(CalendarTable calendarTable);

    /**
     * 删除课表
     * 
     * @param uuid 课表主键
     * @return 结果
     */
    public int deleteCalendarTableByUuid(Long uuid);

    /**
     * 批量删除课表
     * 
     * @param uuids 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteCalendarTableByUuids(Long[] uuids);
}
