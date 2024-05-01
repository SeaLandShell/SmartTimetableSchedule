// To parse this JSON data, do
//
//     final notice = noticeFromJson(jsonString);

import 'dart:convert';

Notice noticeFromJson(String str) => Notice.fromJson(json.decode(str));

String noticeToJson(Notice data) => json.encode(data.toJson());

class Notice {
  late String? noticeId;
  late String? content;
  late String? author;
  late String? releaseTime;
  late int? type;
  late String? courseId;

  Notice({
    this.noticeId,
    this.content,
    this.author,
    this.releaseTime,
    this.type,
    this.courseId,
  });

  Notice copyWith({
    String? noticeId,
    String? content,
    String? author,
    String? releaseTime,
    int? type,
    String? courseId,
  }) =>
      Notice(
        noticeId: noticeId ?? this.noticeId,
        content: content ?? this.content,
        author: author ?? this.author,
        releaseTime: releaseTime ?? this.releaseTime,
        type: type ?? this.type,
        courseId: courseId ?? this.courseId,
      );

  factory Notice.fromJson(Map<String, dynamic> json) => Notice(
    noticeId: json["noticeId"],
    content: json["content"],
    author: json["author"],
    releaseTime: json["releaseTime"],
    type: json["type"],
    courseId: json["courseId"],
  );

  Map<String, dynamic> toJson() => {
    "noticeId": noticeId,
    "content": content,
    "author": author,
    "releaseTime": releaseTime,
    "type": type,
    "courseId": courseId,
  };
}
