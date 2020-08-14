import 'package:json_annotation/json_annotation.dart';

part 'apps_model.g.dart';

@JsonSerializable()
class AppsModel {
  List<String> apps;

  AppsModel();

  static AppsModel fromJson(Map<String, dynamic> json) =>
      _$AppsModelFromJson(json);

  Map<String, dynamic> toJson() => _$AppsModelToJson(this);
}
