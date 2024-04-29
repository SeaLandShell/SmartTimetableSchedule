// To parse this JSON data, do
//
//     final upload = uploadFromJson(jsonString);

import 'dart:convert';

Upload uploadFromJson(String str) => Upload.fromJson(json.decode(str));

String uploadToJson(Upload data) => json.encode(data.toJson());

class Upload {
  late String? uploadId;
  late String? courseId;
  late int? userId;
  late String? workId;
  late String? workName;
  late String? content;
  late String? linkResource;
  late String? appraise;
  late String? criticism;
  late int? score;
  late String? review;
  late String? gmtCreate;
  late String? gmtModified;

  Upload({
    this.uploadId,
    this.courseId,
    this.userId,
    this.workId,
    this.workName,
    this.content,
    this.linkResource,
    this.appraise,
    this.criticism,
    this.score,
    this.review,
    this.gmtCreate,
    this.gmtModified,
  });

  Upload copyWith({
    String? uploadId,
    String? courseId,
    int? userId,
    String? workId,
    String? workName,
    String? content,
    String? linkResource,
    String? appraise,
    String? criticism,
    int? score,
    String? review,
    String? gmtCreate,
    String? gmtModified,
  }) =>
      Upload(
        uploadId: uploadId ?? this.uploadId,
        courseId: courseId ?? this.courseId,
        userId: userId ?? this.userId,
        workId: workId ?? this.workId,
        workName: workName ?? this.workName,
        content: content ?? this.content,
        linkResource: linkResource ?? this.linkResource,
        appraise: appraise ?? this.appraise,
        criticism: criticism ?? this.criticism,
        score: score ?? this.score,
        review: review ?? this.review,
        gmtCreate: gmtCreate ?? this.gmtCreate,
        gmtModified: gmtModified ?? this.gmtModified,
      );

  factory Upload.fromJson(Map<String, dynamic> json) => Upload(
    uploadId: json["uploadId"],
    courseId: json["courseId"],
    userId: json["userId"],
    workId: json["workId"],
    workName: json["workName"],
    content: json["content"],
    linkResource: json["linkResource"],
    appraise: json["appraise"],
    criticism: json["criticism"],
    score: json["score"],
    review: json["review"],
    gmtCreate: json["gmtCreate"],
    gmtModified: json["gmtModified"],
  );

  Map<String, dynamic> toJson() => {
    "uploadId": uploadId,
    "courseId": courseId,
    "userId": userId,
    "workId": workId,
    "workName": workName,
    "content": content,
    "linkResource": linkResource,
    "appraise": appraise,
    "criticism": criticism,
    "score": score,
    "review": review,
    "gmtCreate": gmtCreate,
    "gmtModified": gmtModified,
  };
}
