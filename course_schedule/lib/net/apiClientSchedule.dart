import 'package:course_schedule/model/index.dart';
import 'package:course_schedule/model/schedule.dart';
import 'package:course_schedule/utils/dialog_util.dart';
import 'package:course_schedule/utils/text_util.dart';
import 'package:course_schedule/utils/util.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/cupertino.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'dart:async';

import '../model/Upload.dart';
import '../model/Work.dart';
import '../utils/http_util.dart';

class ApiClientSchdedule {
  ApiClientSchdedule._();
  // 根据课程基本信息创建课程并持久化存储
  static Future<Schedule> createCourse(Schedule schedule) async {
    final resp = await HttpUtil.client.post("/cschedule/schedule/courses",
        data: {
            'teacherName':schedule.teacherName,
          'clazzName':schedule.clazzName,
          'term':schedule.term,
          'courseName':schedule.courseName,
          'teacherId':schedule.teacherId,
        });
    final data = HttpUtil.getDataFromResponse(resp.toString()); // 解析响应数据
    // print(data.toString());
    return Schedule.fromJson(data);
  }

  // 根据云课号拿到课程信息
  static Future<Schedule?> searchCourse(String courseNum) async {
    final resp = await HttpUtil.client.get("/cschedule/schedule/courses/$courseNum",
        data: {
          'num':courseNum,
        });
    final data = HttpUtil.getDataFromResponse(resp.toString()); // 解析响应数据
    // print(data.toString());
    return Schedule.fromJson(data);
  }

  static Future<int> resourceDelete(String resId) async {
    final resp = await HttpUtil.client.delete("/cschedule/resources/delete/${resId}",
        data: {'id':resId});
    print(resp.toString());
    final data = HttpUtil.getDataFromResponse(resp.toString()); // 解析响应数据
    return data;
  }


  // 输入云课号加入教师课程
  static Future<Member> addMember(Member member) async {
    final resp = await HttpUtil.client.post("/cschedule/members",
        data: {
          'userId': member.userId,
          'courseId': member.courseId,
          'arrive': 0,
          'resource': 0,
          'experience': 0,
          'score': 0,
          'remark': member.remark,
          'id': 0,
        });
    print(resp.toString());
    final data = HttpUtil.getDataFromResponse(resp.toString()); // 解析响应数据
    return Member.fromJson(data);
  }

  static Future<Member> searchMemberByUserIdCourseId(int userId,String courseId)async{
    final resp = await HttpUtil.client.post("/cschedule/members/searchMemberByUserIdCourseId",
      data: dio.FormData.fromMap({
        'userId': userId,
        'courseId': courseId,
      }),);
    final data = HttpUtil.getDataFromResponse(resp.toString());
    if(data!=null){
      return Member.fromJson(data);
    }else{
      DialogUtil.showToast("获取本成员功能不知道去哪啦~");
      return Member();
    }
  }

  static Future<int> customDelete(Member member) async {
    final resp = await HttpUtil.client.delete("/cschedule/members/customDelete",
        data: member.toJson());
    print(resp.toString());
    final data = HttpUtil.getDataFromResponse(resp.toString()); // 解析响应数据
    return data;
  }

  // 上传图片
  static Future<Resource?> uploadImage(String courseId,String name,String path) async {
    try {
      final form = dio.FormData.fromMap({
        'file': await dio.MultipartFile.fromFile(path),
        'info': '''{"resName": "$name","courseId": "$courseId"}''',
      }); // 构建表单数据
      final resp = await HttpUtil.client.post(
        "/cschedule/resources",
        data: form,
      ); // 发起上传请求
      final data = HttpUtil.getDataFromResponse(resp.toString()); // 解析响应数据
      print('resource:$data');
      if (data.isNotEmpty) {
        Resource resource = Resource.fromJson(data);
        return resource;
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  // 循环上传多个资产
  static Future<List<Resource>?> uploadAssets(String courseId,List<AssetEntity> assets) async {
    try {
      List<Resource> resources = [];
      for(var i=0;i<assets.length;i++){
        int dotIndex = assets[i].title!.lastIndexOf('.');
        String fileNameNoExt= dotIndex != -1 ? assets[i].title!.substring(0, dotIndex) : assets[i].title!;
        if(fileNameNoExt.length>=100){
          fileNameNoExt = fileNameNoExt.substring(0,99);
        }
        final file = await assets[i].file;
        final form = dio.FormData.fromMap({
          'file': await dio.MultipartFile.fromFile(file!.path),
          'info': '''{"resName": "${fileNameNoExt}","courseId": "$courseId"}''',
        }); // 构建表单数据
        final resp = await HttpUtil.client.post(
          "/cschedule/resources",
          data: form,
        ); // 发起上传请求
        final data = HttpUtil.getDataFromResponse(resp.toString()); // 解析响应数据
        print('resource:$data');
        if (data.isNotEmpty) {
          Resource resource = Resource.fromJson(data);
          resources.add(resource);
        }
      }
      return resources;
    } catch (e) {
      print(e);
    }
    return null;
  }


  // 根据资产实体返回MultipartFile数据流
  static Future<dio.MultipartFile> multipartFileFromAssetEntity(AssetEntity entity) async {
    dio.MultipartFile mf;
    // Using the file path.
    final file = await entity.file;
    if (file == null) {
      throw StateError('Unable to obtain file of the entity ${entity.id}.');
    }
    mf = await dio.MultipartFile.fromFile(file.path);
    // Using the bytes.
    final bytes = await entity.originBytes;
    if (bytes == null) {
      throw StateError('Unable to obtain bytes of the entity ${entity.id}.');
    }
    mf = dio.MultipartFile.fromBytes(bytes);
    return mf;
  }

  static void expirence(int userId,String courseId,String resId)async{
    final resp = await HttpUtil.client.post("/cschedule/members/expirence",
      data: dio.FormData.fromMap({
        'userId': userId,
        'courseId': courseId,
        'resId': resId,
      }),);
    final data = HttpUtil.getDataFromResponse(resp.toString());
    Member member = Member.fromJson(data);
    if(member==null){
      DialogUtil.showToast("经验值功能不知道去哪啦~");
    }
  }
  // 资源学习个数
  static Future<int> resourceLearnCount(int userId,String courseId,String resId)async{
    final resp = await HttpUtil.client.post("/cschedule/members/resourceLearnCount",
      data: dio.FormData.fromMap({
        'userId': userId,
        'courseId': courseId,
        'resId': resId,
      }),);
    final data = HttpUtil.getDataFromResponse(resp.toString());
    if(data!=null && data!=0){
      return data;
    }else{
      return 0;
    }
  }

//   作业管理模块接口
  static Future<Work?> addWork(Work work) async {
    final resp = await HttpUtil.client.post("/cschedule/works",
        data: work.toJson());
    // print(resp.toString());
    final data = HttpUtil.getDataFromResponse(resp.toString()); // 解析响应数据
    return Work.fromJson(data);
  }

  static Future<int> workDelete(Work work) async {
    final resp = await HttpUtil.client.delete("/cschedule/works/workDelete",
        data: work.toJson());
    print(resp.toString());
    final data = HttpUtil.getDataFromResponse(resp.toString()); // 解析响应数据
    return data;
  }

  static Future<int?> workUpdate(Work work) async {
    final resp = await HttpUtil.client.post("/cschedule/works/update",
      data: work.toJson(),);
    print(resp.toString());
    final data = HttpUtil.getDataFromResponse(resp.toString()); // 解析响应数据
    return data;
  }

//   学生作业管理模块
  static Future<int?> addUpload(Upload upload) async {
    final resp = await HttpUtil.client.post("/cschedule/uploads/submit",
        data: upload.toJson());
    // print(resp.toString());
    final data = HttpUtil.getDataFromResponse(resp.toString()); // 解析响应数据
    return data;
  }

  static Future<int?> updateUpload(Upload upload) async {
    final resp = await HttpUtil.client.post("/cschedule/uploads/update",
        data: upload.toJson());
    final data = HttpUtil.getDataFromResponse(resp.toString()); // 解析响应数据
    return data;
  }

  static Future<int?> correct(Upload upload) async {
    final resp = await HttpUtil.client.post("/cschedule/uploads/correct",
        data: upload.toJson());
    final data = HttpUtil.getDataFromResponse(resp.toString()); // 解析响应数据
    return data;
  }



}
