// To parse this JSON data, do
//
//     final work = workFromJson(jsonString);

import 'dart:convert';

Work workFromJson(String str) => Work.fromJson(json.decode(str));

String workToJson(Work data) => json.encode(data.toJson());

class Work {
  late String? workId;
  late String? courseId;
  late String? workName;
  late bool? isEnabled;
  late String? content;
  late String? linkResource;
  late String? startTime;
  late String? endTime;
  late int? state;
  late String? gmtCreate;
  late String? gmtModified;

  Work({
    this.workId,
    this.courseId,
    this.workName,
    this.isEnabled,
    this.content,
    this.linkResource,
    this.startTime,
    this.endTime,
    this.state,
    this.gmtCreate,
    this.gmtModified,
  });

  Work copyWith({
    String? workId,
    String? courseId,
    String? workName,
    bool? isEnabled,
    String? content,
    String? linkResource,
    String? startTime,
    String? endTime,
    int? state,
    String? gmtCreate,
    String? gmtModified,
  }) =>
      Work(
        workId: workId ?? this.workId,
        courseId: courseId ?? this.courseId,
        workName: workName ?? this.workName,
        isEnabled: isEnabled ?? this.isEnabled,
        content: content ?? this.content,
        linkResource: linkResource ?? this.linkResource,
        startTime: startTime ?? this.startTime,
        endTime: endTime ?? this.endTime,
        state: state ?? this.state,
        gmtCreate: gmtCreate ?? this.gmtCreate,
        gmtModified: gmtModified ?? this.gmtModified,
      );

  factory Work.fromJson(Map<String, dynamic> json) => Work(
    workId: json["workId"],
    courseId: json["courseId"],
    workName: json["workName"],
    isEnabled: json["isEnabled"],
    content: json["content"],
    linkResource: json["linkResource"],
    startTime: json["startTime"],
    endTime: json["endTime"],
    state: json["state"],
    gmtCreate: json["gmtCreate"],
    gmtModified: json["gmtModified"],
  );

  Map<String, dynamic> toJson() => {
    "workId": workId,
    "courseId": courseId,
    "workName": workName,
    "isEnabled": isEnabled,
    "content": content,
    "linkResource": linkResource,
    "startTime": startTime,
    "endTime": endTime,
    "state": state,
    "gmtCreate": gmtCreate,
    "gmtModified": gmtModified,
  };
}
