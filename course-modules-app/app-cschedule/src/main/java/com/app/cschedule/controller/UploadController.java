package com.app.cschedule.controller;

import com.app.cschedule.common.annotation.LogAnnotation;
import com.app.cschedule.common.constant.LogType;
import com.app.cschedule.common.result.Result;
import com.app.cschedule.common.support.BaseController;
import com.app.cschedule.common.util.IdUtil;
import com.app.cschedule.entity.Member;
import com.app.cschedule.entity.Upload;
import com.app.cschedule.mapper.MemberMapper;
import com.app.cschedule.model.MemberDTO;
import com.app.cschedule.model.MemberDTOO;
import com.app.cschedule.service.UploadService;
import com.app.cschedule.service.mongo_service.UploadRepository;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import org.apache.commons.lang3.RandomStringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Example;
import org.springframework.data.domain.Sort;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.data.mongodb.core.query.Criteria;
import org.springframework.data.mongodb.core.query.Query;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import java.util.ArrayList;
import java.util.List;

@Api(tags = "学生作业管理")
@RestController
@RequestMapping("/uploads")
public class UploadController extends BaseController {
    @Resource
    UploadRepository uploadRepository;
    @Autowired
    private UploadService uploadService;
    @Autowired
    private MemberMapper memberMapper;
    @Autowired
    private MongoTemplate mongoTemplate;

    @ApiOperation(value = "提交作业")
    @LogAnnotation(operation = "提交作业")
    @PostMapping("/submit")
    public Result addUpload(@RequestBody Upload upload) {
//        mysql
        Upload uploaded = uploadService.selectUploadByCourseIdUploadName(upload.getCourseId(), upload.getWorkId(), upload.getUserId());
        if(uploaded!=null){
            return handleResult(0).setMessage("当前作业已提交，请在提交记录中提交修改！").setCode(1);
        }
        upload.setUploadId(RandomStringUtils.randomAlphanumeric(20));
        upload.setLinkResource("");
        upload.setAppraise("");
        upload.setCriticism("");
        upload.setScore(0);
        upload.setReview("0");
        if(uploadService.addUpload(upload)>0){//mongo存储历史提交记录（第一次提交）
            uploadRepository.insert(uploadService.selectUpload(upload));
        }
        return handleResult(1);
    }

    @ApiOperation(value = "获取作业提交记录")
    @LogAnnotation(operation = "获取作业提交记录", exclude = {LogType.URL})
    @GetMapping("/record") // 定义GET请求映射路径为"/{id}"
    public Result getRecordDetail(String courseId, String workId, Integer userId) {
        Criteria criteria = Criteria.where("courseId").is(courseId)
                .and("workId").is(workId)
                .and("userId").is(userId.longValue());
        Query query = new Query(criteria).with(Sort.by(Sort.Direction.ASC, "uploadId")); // 可以根据需要进行排序
        List<Upload> records = mongoTemplate.find(query, Upload.class);
//        for (Upload ll : records) {
//            System.out.println(ll.toString());
//        }
//        Upload upload = new Upload().setCourseId(courseId).setWorkId(workId).setUserId(userId.longValue());
//        List<Upload> records = uploadRepository.findAll(Example.of(upload), Sort.by("uploadId"));
        return Result.success(records);
    }

    @ApiOperation(value = "学生修改作业")
    @LogAnnotation(operation = "学生修改作业")
    @PostMapping("/update")
    public Result updateUpload(@RequestBody Upload upload) {
//        重新构造mongo的上传表id，并恢复原本id给mysql
        upload.setUploadId(upload.getUploadId() + System.currentTimeMillis());
        uploadRepository.insert(upload);
        upload.setUploadId(upload.getUploadId().substring(0,20));
        return handleResult(uploadService.updateByExId(upload));
    }

    @ApiOperation(value = "教师批改作业")
    @LogAnnotation(operation = "教师批改作业")
    @PostMapping("/correct")
    public Result correctWork(@RequestBody Upload upload) {
//        批阅即更改mongo上传表、sql上传表
        String originUid = upload.getUploadId();
        Query query = new Query(Criteria.where("uploadId").regex("^" + originUid));
        List<Upload> latestUploads = mongoTemplate.find(query, Upload.class);
//        for (Upload ll : latestUploads){
//            System.out.println(ll.toString());
//        }
//        记录最新记录的id值并赋值给要批阅的作业的id值
        if(!latestUploads.isEmpty()){
            upload.setUploadId(latestUploads.get(latestUploads.size()-1).getUploadId());
        }else{
            return handleResult(1).setMessage("学生未提交作业或系统出问题啦!").setCode(1);
        }
        uploadRepository.save(upload);
//        恢复原来的uploadId
        upload.setUploadId(originUid);
        return handleResult(uploadService.updateByExId(upload));
    }

    @ApiOperation(value = "教师获取所有学生该课程该作业的提交情况")
    @LogAnnotation(operation = "获取班级详情", exclude = {LogType.URL})
    @GetMapping("/allSubmit")
    public Result allSubmit(String courseId,String workId) {
        List<MemberDTO> memberDTOS = memberMapper.getMembersByCourseId(courseId);
        List<MemberDTOO> memberDTOOS= new ArrayList<>();
        for(MemberDTO member : memberDTOS){
            Upload supload= uploadService.selectUploadByCourseIdUploadName(member.getCourseId(), workId,member.getUserId().longValue());
            if(supload!=null){
                System.out.println(supload.toString());
            }
            memberDTOOS.add(new MemberDTOO().setMemberDTO(member).setUpload(supload));
        }
        return Result.success(memberDTOOS); // 返回成功结果
    }
//
//    @ApiOperation(value = "删除作业")
//    @LogAnnotation(operation = "删除作业")
//    @DeleteMapping("/delete")
//    public Result deleteWork(@PathVariable String id) {
//        return handleResult(workService.delete(new Work().setWorkId(id)));
//    }
}