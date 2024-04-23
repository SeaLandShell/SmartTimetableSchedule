import 'dart:convert';
import 'package:course_schedule/model/index.dart';
import 'package:course_schedule/model/schedule.dart';
import 'package:dio/dio.dart' as dio;
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'dart:async';

import '../data/token_repository.dart';
import '../model/code.dart';
import '../model/user.dart';
import '../utils/http_util.dart';
import '../utils/shared_preferences_util.dart';
import 'globalVariables.dart';

class ApiClientSchdedule {
  ApiClientSchdedule._();
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
  static Future<Schedule?> searchCourse(String courseNum) async {
    final resp = await HttpUtil.client.get("/cschedule/schedule/courses/$courseNum",
        data: {
          'num':courseNum,
        });
    final data = HttpUtil.getDataFromResponse(resp.toString()); // 解析响应数据
    // print(data.toString());
    return Schedule.fromJson(data);
  }

  static Future<Member> addMember(Member member) async {
    final resp = await HttpUtil.client.post("/cschedule/members",
        data: {
          'userId': member.userId,
          'courseId': member.courseId,
        });
    final data = HttpUtil.getDataFromResponse(resp.toString()); // 解析响应数据
    return Member.fromJson(data);
  }

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


}
