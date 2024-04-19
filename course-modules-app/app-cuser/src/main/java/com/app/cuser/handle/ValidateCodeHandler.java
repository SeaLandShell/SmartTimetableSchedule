package com.app.cuser.handle;

import com.app.cuser.service.ValidateCodeService;
import com.course.common.core.exception.CaptchaException;
import com.course.common.core.web.domain.AjaxResult;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Component;
import reactor.core.publisher.Mono;
import org.springframework.web.reactive.function.server.ServerResponse;
import org.springframework.web.reactive.function.server.HandlerFunction;
import org.springframework.web.reactive.function.server.ServerRequest;
import org.springframework.web.reactive.function.BodyInserters;

import java.io.IOException;

/**
 * 验证码获取
 *
 * @author course
 */
@Component
public class ValidateCodeHandler implements HandlerFunction<ServerResponse>
{
    @Autowired
    private ValidateCodeService validateCodeService;

    @Override
    public Mono<ServerResponse> handle(ServerRequest serverRequest)
    {
        AjaxResult ajax;
        try
        {
            ajax = validateCodeService.createCaptcha();
        }
        catch (CaptchaException | IOException e)
        {
            return Mono.error(e);
        }
        return ServerResponse.status(HttpStatus.OK).body(BodyInserters.fromValue(ajax));
    }
}
