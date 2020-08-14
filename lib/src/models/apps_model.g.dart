// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'apps_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppsModel _$AppsModelFromJson(Map<String, dynamic> json) {
  return AppsModel()
    ..apps = (json['apps'] as List)?.map((e) => e as String)?.toList();
}

Map<String, dynamic> _$AppsModelToJson(AppsModel instance) => <String, dynamic>{
      'apps': instance.apps,
    };
