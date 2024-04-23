// To parse this JSON data, do
//
//     final member = memberFromJson(jsonString);

import 'dart:convert';

import 'package:floor/floor.dart';

Member memberFromJson(String str) => Member.fromJson(json.decode(str));

String memberToJson(Member data) => json.encode(data.toJson());
@Entity(primaryKeys: ['userId','courseId'])
class Member {
  late int? userId;
  late String? courseId;
  late int? arrive;
  late int? resource;
  late int? experience;
  late int? score;
  late String? remark;
  late int? id;
  late String? gmtCreate;
  late String? gmtModified;

  Member({
    this.userId,
    this.courseId,
    this.arrive,
    this.resource,
    this.experience,
    this.score,
    this.remark,
    this.id,
    this.gmtCreate,
    this.gmtModified,
  });

  Member copyWith({
    int? userId,
    String? courseId,
    int? arrive,
    int? resource,
    int? experience,
    int? score,
    String? remark,
    int? id,
    String? gmtCreate,
    String? gmtModified,
  }) =>
      Member(
        userId: userId ?? this.userId,
        courseId: courseId ?? this.courseId,
        arrive: arrive ?? this.arrive,
        resource: resource ?? this.resource,
        experience: experience ?? this.experience,
        score: score ?? this.score,
        remark: remark ?? this.remark,
        id: id ?? this.id,
        gmtCreate: gmtCreate ?? this.gmtCreate,
        gmtModified: gmtModified ?? this.gmtModified,
      );

  factory Member.fromJson(Map<String, dynamic> json) => Member(
    userId: json["userId"],
    courseId: json["courseId"],
    arrive: json["arrive"],
    resource: json["resource"],
    experience: json["experience"],
    score: json["score"],
    remark: json["remark"],
    id: json["id"],
    gmtCreate: json["gmtCreate"],
    gmtModified: json["gmtModified"],
  );

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "courseId": courseId,
    "arrive": arrive,
    "resource": resource,
    "experience": experience,
    "score": score,
    "remark": remark,
    "id": id,
    "gmtCreate": gmtCreate,
    "gmtModified": gmtModified,
  };
}
