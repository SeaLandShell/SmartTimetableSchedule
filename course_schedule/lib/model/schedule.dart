// To parse this JSON data, do
//
//     final schedule = scheduleFromJson(jsonString);

import 'dart:convert';

import 'package:floor/floor.dart';

Schedule scheduleFromJson(String str) => Schedule.fromJson(json.decode(str));

String scheduleToJson(Schedule data) => json.encode(data.toJson());
@Entity(primaryKeys: ['courseId'])
class Schedule {
  late String? courseId;
  late String? courseNum;
  late String? courseName;
  late String? coursePic;
  late String? clazzName;
  late String? term;
  late String? synopsis;
  late int? arrivesNum;
  late int? resourcesNum;
  late int? experiencesNum;
  late bool? appraise;
  late int? teacherId;
  late String? teacherName;
  late int? id;
  late String? gmtCreate;
  late String? gmtModified;

  Schedule({
    this.courseId,
    this.courseNum,
    this.courseName,
    this.coursePic,
    this.clazzName,
    this.term,
    this.synopsis,
    this.arrivesNum,
    this.resourcesNum,
    this.experiencesNum,
    this.appraise,
    this.teacherId,
    this.teacherName,
    this.id,
    this.gmtCreate,
    this.gmtModified,
  });

  Schedule copyWith({
    String? courseId,
    String? courseNum,
    String? courseName,
    String? coursePic,
    String? clazzName,
    String? term,
    String? synopsis,
    int? arrivesNum,
    int? resourcesNum,
    int? experiencesNum,
    bool? appraise,
    int? teacherId,
    String? teacherName,
    int? id,
    String? gmtCreate,
    String? gmtModified,
  }) =>
      Schedule(
        courseId: courseId ?? this.courseId,
        courseNum: courseNum ?? this.courseNum,
        courseName: courseName ?? this.courseName,
        coursePic: coursePic ?? this.coursePic,
        clazzName: clazzName ?? this.clazzName,
        term: term ?? this.term,
        synopsis: synopsis ?? this.synopsis,
        arrivesNum: arrivesNum ?? this.arrivesNum,
        resourcesNum: resourcesNum ?? this.resourcesNum,
        experiencesNum: experiencesNum ?? this.experiencesNum,
        appraise: appraise ?? this.appraise,
        teacherId: teacherId ?? this.teacherId,
        teacherName: teacherName ?? this.teacherName,
        id: id ?? this.id,
        gmtCreate: gmtCreate ?? this.gmtCreate,
        gmtModified: gmtModified ?? this.gmtModified,
      );

  factory Schedule.fromJson(Map<String, dynamic> json) => Schedule(
    courseId: json["courseId"],
    courseNum: json["courseNum"],
    courseName: json["courseName"],
    coursePic: json["coursePic"],
    clazzName: json["clazzName"],
    term: json["term"],
    synopsis: json["synopsis"]??"",
    arrivesNum: json["arrivesNum"]??0,
    resourcesNum: json["resourcesNum"]??0,
    experiencesNum: json["experiencesNum"]??0,
    appraise: json["appraise"]??false,
    teacherId: json["teacherId"],
    teacherName: json["teacherName"],
    id: json["id"]??0,
    gmtCreate: json["gmtCreate"]??"",
    gmtModified: json["gmtModified"]??"",
  );

  Map<String, dynamic> toJson() => {
    "courseId": courseId,
    "courseNum": courseNum,
    "courseName": courseName,
    "coursePic": coursePic,
    "clazzName": clazzName,
    "term": term,
    "synopsis": synopsis,
    "arrivesNum": arrivesNum,
    "resourcesNum": resourcesNum,
    "experiencesNum": experiencesNum,
    "appraise": appraise,
    "teacherId": teacherId,
    "teacherName": teacherName,
    "id": id,
    "gmtCreate": gmtCreate,
    "gmtModified": gmtModified,
  };
}
