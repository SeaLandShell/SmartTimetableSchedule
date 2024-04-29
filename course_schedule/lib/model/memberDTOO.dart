// To parse this JSON data, do
//
//     final memberDtoo = memberDtooFromJson(jsonString);

import 'dart:convert';

import 'Upload.dart';
import 'memberDTO.dart';

MemberDtoo memberDtooFromJson(String str) => MemberDtoo.fromJson(json.decode(str));

String memberDtooToJson(MemberDtoo data) => json.encode(data.toJson());

class MemberDtoo {
  late MemberDto? memberDTO;
  late Upload? upload;

  MemberDtoo({
    this.memberDTO,
    this.upload,
  });

  MemberDtoo copyWith({
    MemberDto? memberDto,
    Upload? upload,
  }) =>
      MemberDtoo(
        memberDTO: memberDto ?? this.memberDTO,
        upload: upload ?? this.upload,
      );

  factory MemberDtoo.fromJson(Map<String, dynamic> json) => MemberDtoo(
    memberDTO: json["memberDTO"] == null ? null : MemberDto.fromJson(json["memberDTO"]),
    upload: json["upload"] == null ? null : Upload.fromJson(json["upload"]),
  );

  Map<String, dynamic> toJson() => {
    "memberDTO": memberDTO?.toJson(),
    "upload": upload?.toJson(),
  };
}

