package com.app.cuser.service;

import com.course.common.core.exception.CaptchaException;
import com.course.common.core.web.domain.AjaxResult;

import java.io.IOException;

/**
 * 验证码处理
 *
 * @author course
 */
public interface ValidateCodeService
{
    /**
     * 生成验证码
     */
    public AjaxResult createCaptcha() throws IOException, CaptchaException;

    /**
     * 校验验证码
     */
    public void checkCaptcha(String key, String value) throws CaptchaException;
    public AjaxResult checkCaptchaToApp(String key, String value) throws CaptchaException;
}
