package com.app.cschedule;

import com.mongodb.client.MongoCollection;
import org.bson.Document;
import org.checkerframework.checker.units.qual.A;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.data.mongodb.core.MongoTemplate;

@SpringBootTest
class MongodbDemoApplicationTests {
    @Autowired
    private MongoTemplate mongoTemplate;

    MongodbDemoApplicationTests(MongoTemplate mongoTemplate) {
        this.mongoTemplate = mongoTemplate;
    }

    @Test
    void contextLoads() {
    }
    @Test
    void collectionExists() {
        String collectionName = "springboot";
        boolean collectionExists = mongoTemplate.collectionExists(collectionName);
        if (!collectionExists) {
            MongoCollection<Document> collection = mongoTemplate.createCollection(collectionName);
            System.out.println(collection.toString());
        } else {
            System.out.println(collectionName + "is exists");
        }
    }
}


