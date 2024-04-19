// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'background_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BackgroundConfig _$BackgroundConfigFromJson(Map<String, dynamic> json) =>
    BackgroundConfig(
      type: $enumDecode(_$BackgroundTypeEnumMap, json['type']),
      color: json['color'] as int?,
      imgPath: json['imgPath'] as String?,
    );

Map<String, dynamic> _$BackgroundConfigToJson(BackgroundConfig instance) =>
    <String, dynamic>{
      'type': _$BackgroundTypeEnumMap[instance.type]!,
      'color': instance.color,
      'imgPath': instance.imgPath,
    };

const _$BackgroundTypeEnumMap = {
  BackgroundType.defaultBg: 'defaultBg',
  BackgroundType.color: 'color',
  BackgroundType.img: 'img',
};
