// To parse this JSON data, do
//
//     final mnotice = mnoticeFromJson(jsonString);

import 'dart:convert';

Mnotice mnoticeFromJson(String str) => Mnotice.fromJson(json.decode(str));

String mnoticeToJson(Mnotice data) => json.encode(data.toJson());

class Mnotice {
  late String? mnoticeId;
  late String? courseId;
  late String? sendName;
  late String? sendId;
  late String? receiveId;
  late String? receiveName;
  late String? title;
  late String? content;
  late String? gmtCreate;
  late String? gmtModified;

  Mnotice({
    this.mnoticeId,
    this.courseId,
    this.sendName,
    this.sendId,
    this.receiveId,
    this.receiveName,
    this.title,
    this.content,
    this.gmtCreate,
    this.gmtModified,
  });

  Mnotice copyWith({
    String? mnoticeId,
    String? courseId,
    String? sendName,
    String? sendId,
    String? receiveId,
    String? receiveName,
    String? title,
    String? content,
    String? gmtCreate,
    String? gmtModified,
  }) =>
      Mnotice(
        mnoticeId: mnoticeId ?? this.mnoticeId,
        courseId: courseId ?? this.courseId,
        sendName: sendName ?? this.sendName,
        sendId: sendId ?? this.sendId,
        receiveId: receiveId ?? this.receiveId,
        receiveName: receiveName ?? this.receiveName,
        title: title ?? this.title,
        content: content ?? this.content,
        gmtCreate: gmtCreate ?? this.gmtCreate,
        gmtModified: gmtModified ?? this.gmtModified,
      );

  factory Mnotice.fromJson(Map<String, dynamic> json) => Mnotice(
    mnoticeId: json["mnoticeId"],
    courseId: json["courseId"],
    sendName: json["sendName"],
    sendId: json["sendId"],
    receiveId: json["receiveId"],
    receiveName: json["receiveName"],
    title: json["title"],
    content: json["content"],
    gmtCreate: json["gmtCreate"],
    gmtModified: json["gmtModified"],
  );

  Map<String, dynamic> toJson() => {
    "mnoticeId": mnoticeId,
    "courseId": courseId,
    "sendName": sendName,
    "sendId": sendId,
    "receiveId": receiveId,
    "receiveName": receiveName,
    "title": title,
    "content": content,
    "gmtCreate": gmtCreate,
    "gmtModified": gmtModified,
  };
}
