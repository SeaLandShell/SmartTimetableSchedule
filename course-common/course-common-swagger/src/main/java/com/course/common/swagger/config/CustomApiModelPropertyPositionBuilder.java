package com.course.common.swagger.config;
import springfox.documentation.spi.schema.ModelPropertyBuilderPlugin;
import static springfox.documentation.schema.Annotations.findPropertyAnnotation;
import static springfox.documentation.swagger.schema.ApiModelProperties.findApiModePropertyAnnotation;
import java.lang.reflect.Field;
import org.apache.commons.lang3.ArrayUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.stereotype.Component;
import com.fasterxml.jackson.databind.introspect.AnnotatedField;
import com.fasterxml.jackson.databind.introspect.BeanPropertyDefinition;
import com.google.common.base.Optional;
import io.swagger.annotations.ApiModelProperty;
import springfox.documentation.spi.DocumentationType;
import springfox.documentation.spi.schema.ModelPropertyBuilderPlugin;
import springfox.documentation.spi.schema.contexts.ModelPropertyContext;
import springfox.documentation.swagger.common.SwaggerPluginSupport;

@Component
public class CustomApiModelPropertyPositionBuilder implements ModelPropertyBuilderPlugin {
    private Log log = LogFactory.getLog(getClass());

    @Override
    public boolean supports(DocumentationType delimiter) {
        return SwaggerPluginSupport.pluginDoesApply(delimiter);
    }

    @Override
    public void apply(ModelPropertyContext context) {
        java.util.Optional<BeanPropertyDefinition> beanPropertyDefinitionOpt = context.getBeanPropertyDefinition();
        Optional annotation = Optional.absent();
        if (context.getAnnotatedElement().isPresent())
            annotation = (Optional) annotation.or(findApiModePropertyAnnotation(context.getAnnotatedElement().get()));
        if (context.getBeanPropertyDefinition().isPresent())
            annotation = (Optional) annotation.or(findPropertyAnnotation(context.getBeanPropertyDefinition().get(), ApiModelProperty.class));
        if (annotation.isPresent() && beanPropertyDefinitionOpt.isPresent()) {
            BeanPropertyDefinition beanPropertyDefinition = beanPropertyDefinitionOpt.get();
            /*获取到注解字段*/
            AnnotatedField field = beanPropertyDefinition.getField();
            /*获取到字段所在的类*/
            Class clazz = field.getDeclaringClass();
            /*获取类中所有字段*/
            Field[] declaredFields = clazz.getDeclaredFields();
            Field declaredField;
            /*获取当前字段的Field*/
            try {
                declaredField = clazz.getDeclaredField(field.getName());
            } catch (NoSuchFieldException | SecurityException e) {
                log.error("", e);
                return;
            }
            /*获取当前字段在数组中的位置。然后设置position属性*/
            int indexOf = ArrayUtils.indexOf(declaredFields, declaredField);
            if (indexOf != -1) context.getBuilder().position(indexOf);
        }
    }
}

