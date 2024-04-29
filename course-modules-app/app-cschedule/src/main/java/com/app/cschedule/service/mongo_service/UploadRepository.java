package com.app.cschedule.service.mongo_service;

import com.app.cschedule.entity.Upload;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface UploadRepository extends MongoRepository<Upload, String> {

}