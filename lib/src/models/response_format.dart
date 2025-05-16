import 'package:json_annotation/json_annotation.dart';

part 'response_format.g.dart';

/// 响应格式类型
@JsonSerializable()
class ResponseFormat {
  /// 响应类型，例如 'text', 'json_object'
  final String type;

  ResponseFormat({required this.type});

  factory ResponseFormat.text() => ResponseFormat(type: 'text');
  factory ResponseFormat.jsonObject() => ResponseFormat(type: 'json_object');

  factory ResponseFormat.fromJson(Map<String, dynamic> json) =>
      _$ResponseFormatFromJson(json);
  Map<String, dynamic> toJson() => _$ResponseFormatToJson(this);
}
