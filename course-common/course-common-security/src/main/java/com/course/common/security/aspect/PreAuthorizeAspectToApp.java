package com.course.common.security.aspect;

import com.course.common.security.annotation.*;
import com.course.common.security.auth.AuthUtil;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Pointcut;
import org.aspectj.lang.reflect.MethodSignature;
import org.springframework.stereotype.Component;

import java.lang.reflect.Method;

/**
 * 基于 Spring Aop 的注解鉴权
 * 
 * @author kong
 */
@Aspect
@Component
public class PreAuthorizeAspectToApp
{
    /**
     * 构建
     */
    public PreAuthorizeAspectToApp()
    {
    }

    /**
     * 定义AOP签名 (切入所有使用鉴权注解的方法)
     */
    public static final String POINTCUT_SIGN = " @annotation(com.course.common.security.annotation.RequiresLoginToApp) || "
            + "@annotation(com.course.common.security.annotation.RequiresPermissionsToApp) || "
            + "@annotation(com.course.common.security.annotation.RequiresRolesToApp)";

    /**
     * 声明AOP签名
     */
    @Pointcut(POINTCUT_SIGN)
    public void pointcut()
    {
    }

    /**
     * 环绕切入
     * 
     * @param joinPoint 切面对象
     * @return 底层方法执行后的返回值
     * @throws Throwable 底层方法抛出的异常
     */
    @Around("pointcut()")
    public Object around(ProceedingJoinPoint joinPoint) throws Throwable
    {
        // 注解鉴权
        MethodSignature signature = (MethodSignature) joinPoint.getSignature();
        checkMethodAnnotation(signature.getMethod());
        try
        {
            // 执行原有逻辑
            Object obj = joinPoint.proceed();
            return obj;
        }
        catch (Throwable e)
        {
            throw e;
        }
    }

    /**
     * 对一个Method对象进行注解检查
     */
    public void checkMethodAnnotation(Method method)
    {
        // 校验 @RequiresLogin 注解
        RequiresLoginToApp requiresLogin = method.getAnnotation(RequiresLoginToApp.class);
        if (requiresLogin != null)
        {
            AuthUtil.checkLoginToApp();
        }

        // 校验 @RequiresRoles 注解
        RequiresRolesToApp requiresRoles = method.getAnnotation(RequiresRolesToApp.class);
        if (requiresRoles != null)
        {
            AuthUtil.checkRoleToApp(requiresRoles);
        }

        // 校验 @RequiresPermissions 注解
        RequiresPermissionsToApp requiresPermissions = method.getAnnotation(RequiresPermissionsToApp.class);
        if (requiresPermissions != null)
        {
            AuthUtil.checkPermiToApp(requiresPermissions);
        }
    }
}
