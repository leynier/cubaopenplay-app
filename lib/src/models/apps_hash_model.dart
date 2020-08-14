import 'package:json_annotation/json_annotation.dart';

part 'apps_hash_model.g.dart';

@JsonSerializable()
class AppsHashModel {
  String hash;

  AppsHashModel();

  static AppsHashModel fromJson(Map<String, dynamic> json) =>
      _$AppsHashModelFromJson(json);

  Map<String, dynamic> toJson() => _$AppsHashModelToJson(this);
}
