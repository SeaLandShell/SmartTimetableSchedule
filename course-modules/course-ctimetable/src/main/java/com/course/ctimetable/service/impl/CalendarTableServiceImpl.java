package com.course.ctimetable.service.impl;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.course.ctimetable.mapper.CalendarTableMapper;
import com.course.ctimetable.domain.CalendarTable;
import com.course.ctimetable.service.ICalendarTableService;

/**
 * 课表Service业务层处理
 * 
 * @author course
 * @date 2024-05-03
 */
@Service
public class CalendarTableServiceImpl implements ICalendarTableService 
{
    @Autowired
    private CalendarTableMapper calendarTableMapper;

    /**
     * 查询课表
     * 
     * @param uuid 课表主键
     * @return 课表
     */
    @Override
    public CalendarTable selectCalendarTableByUuid(Long uuid)
    {
        return calendarTableMapper.selectCalendarTableByUuid(uuid);
    }

    /**
     * 查询课表列表
     * 
     * @param calendarTable 课表
     * @return 课表
     */
    @Override
    public List<CalendarTable> selectCalendarTableList(CalendarTable calendarTable)
    {
        return calendarTableMapper.selectCalendarTableList(calendarTable);
    }

    /**
     * 新增课表
     * 
     * @param calendarTable 课表
     * @return 结果
     */
    @Override
    public int insertCalendarTable(CalendarTable calendarTable)
    {
        return calendarTableMapper.insertCalendarTable(calendarTable);
    }

    /**
     * 修改课表
     * 
     * @param calendarTable 课表
     * @return 结果
     */
    @Override
    public int updateCalendarTable(CalendarTable calendarTable)
    {
        return calendarTableMapper.updateCalendarTable(calendarTable);
    }

    /**
     * 批量删除课表
     * 
     * @param uuids 需要删除的课表主键
     * @return 结果
     */
    @Override
    public int deleteCalendarTableByUuids(Long[] uuids)
    {
        return calendarTableMapper.deleteCalendarTableByUuids(uuids);
    }

    /**
     * 删除课表信息
     * 
     * @param uuid 课表主键
     * @return 结果
     */
    @Override
    public int deleteCalendarTableByUuid(Long uuid)
    {
        return calendarTableMapper.deleteCalendarTableByUuid(uuid);
    }
}
