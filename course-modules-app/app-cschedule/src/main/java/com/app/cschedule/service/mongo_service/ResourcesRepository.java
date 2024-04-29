package com.app.cschedule.service.mongo_service;

import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ResourcesRepository extends MongoRepository<ResourcesEntity, Long> {

}