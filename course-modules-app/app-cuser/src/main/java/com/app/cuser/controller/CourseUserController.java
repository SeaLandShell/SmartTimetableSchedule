package com.app.cuser.controller;

import com.app.cuser.domain.LoginUserToApp;
import com.app.cuser.service.impl.TokenServiceToApp;
import com.course.common.core.domain.R;
import com.course.common.core.utils.StringUtils;
import com.course.common.core.utils.file.FileTypeUtils;
import com.course.common.core.utils.file.MimeTypeUtils;
import com.course.common.core.utils.ip.IpUtils;
import com.course.common.core.utils.poi.ExcelUtil;
import com.course.common.core.web.controller.BaseController;
import com.course.common.core.web.domain.AjaxResult;
import com.course.common.core.web.page.TableDataInfo;
import com.course.common.log.annotation.Log;
import com.course.common.log.enums.BusinessType;
import com.course.common.security.annotation.RequiresPermissions;
import com.app.cuser.domain.CourseUser;
import com.app.cuser.service.ICourseUserService;
import com.course.system.api.domain.SysFile;
import com.course.system.api.RemoteFileService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletResponse;
import java.util.Arrays;
import java.util.List;

/**
 * 智课表用户Controller
 *
 * @author course
 * @date 2024-03-27
 */
@RestController
@RequestMapping("/acuser")
public class CourseUserController extends BaseController
{
    private static final Logger log = LoggerFactory.getLogger(RegisterLoginController.class);
    @Autowired
    private ICourseUserService courseUserService;
    @Autowired
    private RemoteFileService remoteFileService;
    @Autowired
    private TokenServiceToApp tokenServiceToApp;

    /**
     * 查询智课表用户列表
     */

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
    @RequiresPermissions("acuser:acuser:export")
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
    @RequiresPermissions("acuser:acuser:query")
    @GetMapping(value = "/{userId}")
    public AjaxResult getInfo(@PathVariable("userId") Long userId)
    {
        return success(courseUserService.selectCourseUserByUserId(userId));
    }

    @Log(title = "通过学号获取智课表用户", businessType = BusinessType.UPDATE)
    @ResponseBody
    @GetMapping("/stuTuNumber")
    public AjaxResult getUserByStuTuNumber(String stuTuNumber)
    {
        return AjaxResult.success(courseUserService.selectCourseUserByStuTuNumber(stuTuNumber));
    }

    /**
     * 新增智课表用户
     */
    @RequiresPermissions("acuser:acuser:add")
    @Log(title = "智课表用户", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody CourseUser courseUser)
    {
        return toAjax(courseUserService.insertCourseUser(courseUser));
    }

    /**
     * 修改智课表用户
     */
//    @RequiresPermissions("acuser:acuser:edit")
    @Log(title = "智课表用户", businessType = BusinessType.UPDATE)
    @ResponseBody
    @PutMapping("/edit")
    public R<CourseUser> edit(@RequestBody CourseUser courseUser)
    {
        if(toAjax(courseUserService.updateCourseUserByObject(courseUser)).equals(success())){
            CourseUser user= courseUserService.selectCourseUserByPhoneNumber(courseUser.getPhonenumber());
            log.info("修改用户："+user.toString());
            return R.ok(user,"服务端修改成功");
        }
        return R.fail(courseUser,"服务端修改失败,data为移动端对象");
    }

    /**
     * 删除智课表用户
     */
    @RequiresPermissions("acuser:acuser:remove")
    @Log(title = "智课表用户", businessType = BusinessType.DELETE)
	@DeleteMapping("/{userIds}")
    public AjaxResult remove(@PathVariable Long[] userIds)
    {
        return toAjax(courseUserService.deleteCourseUserByUserIds(userIds));
    }

    @Log(title = "用户头像", businessType = BusinessType.UPDATE)
    @PostMapping("/avatar")
    public R<CourseUser> avatar(@RequestParam("file") MultipartFile file,String phone)
    {
        if (!file.isEmpty())
        {
            LoginUserToApp loginUser=new LoginUserToApp();
            CourseUser user=courseUserService.selectCourseUserByPhoneNumber(phone);
            loginUser.setCourseUser(user);
            String extension = FileTypeUtils.getExtension(file);
            if (!StringUtils.equalsAnyIgnoreCase(extension, MimeTypeUtils.IMAGE_EXTENSION))
            {
                log.info("文件格式不正确，请上传");
                return R.fail(user,"文件格式不正确，请上传" + Arrays.toString(MimeTypeUtils.IMAGE_EXTENSION) + "格式");
            }
            R<SysFile> fileResult = remoteFileService.upload(file);
            if (StringUtils.isNull(fileResult) || StringUtils.isNull(fileResult.getData()))
            {
                log.info("文件服务异常，请联系管理员");
                return R.fail(user,"文件服务异常，请联系管理员");
            }
            String serverIp = IpUtils.getHostIp();
            String url = fileResult.getData().getUrl();
            url = url.replace("127.0.0.1", serverIp);
            // 更新缓存用户头像
            if (courseUserService.updateUserAvatar(user.getPhonenumber(), url))
            {
                user.setAvatar(url);
                tokenServiceToApp.setLoginUser(loginUser);
                log.info(user.toString());
                return R.ok(user,"文件上传成功");
            }
        }
        log.info("上传图片异常，请联系管理员");
        return R.fail(new CourseUser(),"上传图片异常，请联系管理员");
    }
}
