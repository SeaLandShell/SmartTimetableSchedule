// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'code.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Code _$CodeFromJson(Map<String, dynamic> json) => Code()
  ..msg = json['msg'] as String
  ..img = json['img'] as String
  ..code = json['code'] as num
  ..captchaEnabled = json['captchaEnabled'] as bool
  ..uuid = json['uuid'] as String;

Map<String, dynamic> _$CodeToJson(Code instance) => <String, dynamic>{
      'msg': instance.msg,
      'img': instance.img,
      'code': instance.code,
      'captchaEnabled': instance.captchaEnabled,
      'uuid': instance.uuid,
    };
