package com.course.ctimetable.controller;

import java.util.List;
import javax.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.course.common.log.annotation.Log;
import com.course.common.log.enums.BusinessType;
import com.course.common.security.annotation.RequiresPermissions;
import com.course.ctimetable.domain.CalendarTable;
import com.course.ctimetable.service.ICalendarTableService;
import com.course.common.core.web.controller.BaseController;
import com.course.common.core.web.domain.AjaxResult;
import com.course.common.core.utils.poi.ExcelUtil;
import com.course.common.core.web.page.TableDataInfo;

/**
 * 课表Controller
 * 
 * @author course
 * @date 2024-05-03
 */
@RestController
@RequestMapping("/ctimetable")
public class CalendarTableController extends BaseController
{
    @Autowired
    private ICalendarTableService calendarTableService;

    /**
     * 查询课表列表
     */
    @RequiresPermissions("course-ctimetable:ctimetable:list")
    @GetMapping("/list")
    public TableDataInfo list(CalendarTable calendarTable)
    {
        startPage();
        List<CalendarTable> list = calendarTableService.selectCalendarTableList(calendarTable);
        return getDataTable(list);
    }

    /**
     * 导出课表列表
     */
    @RequiresPermissions("course-ctimetable:ctimetable:export")
    @Log(title = "课表", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, CalendarTable calendarTable)
    {
        List<CalendarTable> list = calendarTableService.selectCalendarTableList(calendarTable);
        ExcelUtil<CalendarTable> util = new ExcelUtil<CalendarTable>(CalendarTable.class);
        util.exportExcel(response, list, "课表数据");
    }

    /**
     * 获取课表详细信息
     */
    @RequiresPermissions("course-ctimetable:ctimetable:query")
    @GetMapping(value = "/{uuid}")
    public AjaxResult getInfo(@PathVariable("uuid") Long uuid)
    {
        return success(calendarTableService.selectCalendarTableByUuid(uuid));
    }

    /**
     * 新增课表
     */
    @RequiresPermissions("course-ctimetable:ctimetable:add")
    @Log(title = "课表", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody CalendarTable calendarTable)
    {
        return toAjax(calendarTableService.insertCalendarTable(calendarTable));
    }

    /**
     * 修改课表
     */
    @RequiresPermissions("course-ctimetable:ctimetable:edit")
    @Log(title = "课表", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody CalendarTable calendarTable)
    {
        return toAjax(calendarTableService.updateCalendarTable(calendarTable));
    }

    /**
     * 删除课表
     */
    @RequiresPermissions("course-ctimetable:ctimetable:remove")
    @Log(title = "课表", businessType = BusinessType.DELETE)
	@DeleteMapping("/{uuids}")
    public AjaxResult remove(@PathVariable Long[] uuids)
    {
        return toAjax(calendarTableService.deleteCalendarTableByUuids(uuids));
    }
}
