package com.app.cschedule.service.mongo_service;
import lombok.Data;
import lombok.experimental.Accessors;
import lombok.experimental.FieldNameConstants;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

import java.math.BigDecimal;

@Data
@Accessors(chain = true)
@FieldNameConstants
@Document(collection = "resourcesNoLimit")
public class ResourcesEntity {

    @Id
    private Long id;

    private String resName;

    private String downLinkPath;

    private String courseId;

}