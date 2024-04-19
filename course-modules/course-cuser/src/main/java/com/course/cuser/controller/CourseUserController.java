package com.course.cuser.controller;

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
import com.course.cuser.domain.CourseUser;
import com.course.cuser.service.ICourseUserService;
import com.course.common.core.web.controller.BaseController;
import com.course.common.core.web.domain.AjaxResult;
import com.course.common.core.utils.poi.ExcelUtil;
import com.course.common.core.web.page.TableDataInfo;

/**
 * 智课表用户Controller
 * 
 * @author course
 * @date 2024-03-27
 */
@RestController
@RequestMapping("/cuser")
public class CourseUserController extends BaseController
{
    @Autowired
    private ICourseUserService courseUserService;

    /**
     * 查询智课表用户列表
     */
    @RequiresPermissions("cuser:cuser:list")
    @GetMapping("/list")
    public TableDataInfo list(CourseUser courseUser)
    {
        startPage();
        List<CourseUser> list = courseUserService.selectCourseUserList(courseUser);
        return getDataTable(list);
    }

    /**
     * 导出智课表用户列表
     */
    @RequiresPermissions("cuser:cuser:export")
    @Log(title = "智课表用户", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, CourseUser courseUser)
    {
        List<CourseUser> list = courseUserService.selectCourseUserList(courseUser);
        ExcelUtil<CourseUser> util = new ExcelUtil<CourseUser>(CourseUser.class);
        util.exportExcel(response, list, "智课表用户数据");
    }

    /**
     * 获取智课表用户详细信息
     */
    @RequiresPermissions("cuser:cuser:query")
    @GetMapping(value = "/{userId}")
    public AjaxResult getInfo(@PathVariable("userId") Long userId)
    {
        return success(courseUserService.selectCourseUserByUserId(userId));
    }

    /**
     * 新增智课表用户
     */
    @RequiresPermissions("cuser:cuser:add")
    @Log(title = "智课表用户", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody CourseUser courseUser)
    {
        return toAjax(courseUserService.insertCourseUser(courseUser));
    }

    /**
     * 修改智课表用户
     */
    @RequiresPermissions("cuser:cuser:edit")
    @Log(title = "智课表用户", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody CourseUser courseUser)
    {
        return toAjax(courseUserService.updateCourseUser(courseUser));
    }

    /**
     * 删除智课表用户
     */
    @RequiresPermissions("cuser:cuser:remove")
    @Log(title = "智课表用户", businessType = BusinessType.DELETE)
	@DeleteMapping("/{userIds}")
    public AjaxResult remove(@PathVariable Long[] userIds)
    {
        return toAjax(courseUserService.deleteCourseUserByUserIds(userIds));
    }
}
