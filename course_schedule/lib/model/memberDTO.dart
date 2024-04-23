// To parse this JSON data, do
//
//     final memberDto = memberDtoFromJson(jsonString);

import 'dart:convert';

MemberDto memberDtoFromJson(String str) => MemberDto.fromJson(json.decode(str));

String memberDtoToJson(MemberDto data) => json.encode(data.toJson());

class MemberDto {
  final String? id;
  final int? userId;
  final String? courseId;
  final String? stuName;
  final String? stuNum;
  final String? avatar;
  final String? signature;
  final int? experience;
  final int? resource;
  final int? arrive;
  final int? score;
  final String? remark;

  MemberDto({
    this.id,
    this.userId,
    this.courseId,
    this.stuName,
    this.stuNum,
    this.avatar,
    this.signature,
    this.experience,
    this.resource,
    this.arrive,
    this.score,
    this.remark,
  });

  MemberDto copyWith({
    String? id,
    int? userId,
    String? courseId,
    String? stuName,
    String? stuNum,
    String? avatar,
    String? signature,
    int? experience,
    int? resource,
    int? arrive,
    int? score,
    String? remark,
  }) =>
      MemberDto(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        courseId: courseId ?? this.courseId,
        stuName: stuName ?? this.stuName,
        stuNum: stuNum ?? this.stuNum,
        avatar: avatar ?? this.avatar,
        signature: signature ?? this.signature,
        experience: experience ?? this.experience,
        resource: resource ?? this.resource,
        arrive: arrive ?? this.arrive,
        score: score ?? this.score,
        remark: remark ?? this.remark,
      );

  factory MemberDto.fromJson(Map<String, dynamic> json) => MemberDto(
    id: json["id"],
    userId: json["userId"],
    courseId: json["courseId"],
    stuName: json["stuName"],
    stuNum: json["stuNum"],
    avatar: json["avatar"],
    signature: json["signature"],
    experience: json["experience"],
    resource: json["resource"],
    arrive: json["arrive"],
    score: json["score"],
    remark: json["remark"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "userId": userId,
    "courseId": courseId,
    "stuName": stuName,
    "stuNum": stuNum,
    "avatar": avatar,
    "signature": signature,
    "experience": experience,
    "resource": resource,
    "arrive": arrive,
    "score": score,
    "remark": remark,
  };
}
