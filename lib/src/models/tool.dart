import 'package:json_annotation/json_annotation.dart';

part 'tool.g.dart';

/// 功能工具类
@JsonSerializable()
class Tool {
  /// 工具类型
  final String type;

  /// 工具功能
  final ToolFunction function;

  Tool({required this.type, required this.function});

  factory Tool.fromJson(Map<String, dynamic> json) => _$ToolFromJson(json);
  Map<String, dynamic> toJson() => _$ToolToJson(this);
}

/// 工具功能类
@JsonSerializable()
class ToolFunction {
  /// 功能名称
  final String name;

  /// 功能描述
  final String description;

  /// 功能参数
  final ToolFunctionParameters parameters;

  ToolFunction({
    required this.name,
    required this.description,
    required this.parameters,
  });

  factory ToolFunction.fromJson(Map<String, dynamic> json) =>
      _$ToolFunctionFromJson(json);
  Map<String, dynamic> toJson() => _$ToolFunctionToJson(this);
}

/// 工具功能参数
@JsonSerializable()
class ToolFunctionParameters {
  /// 参数类型
  final String type;

  /// 参数属性
  final Map<String, ToolFunctionProperty> properties;

  /// 必需的参数
  final List<String> required;

  ToolFunctionParameters({
    required this.type,
    required this.properties,
    required this.required,
  });

  factory ToolFunctionParameters.fromJson(Map<String, dynamic> json) =>
      _$ToolFunctionParametersFromJson(json);
  Map<String, dynamic> toJson() => _$ToolFunctionParametersToJson(this);
}

/// 工具功能属性
@JsonSerializable()
class ToolFunctionProperty {
  /// 属性类型
  final String type;

  /// 属性描述
  final String description;

  ToolFunctionProperty({required this.type, required this.description});

  factory ToolFunctionProperty.fromJson(Map<String, dynamic> json) =>
      _$ToolFunctionPropertyFromJson(json);
  Map<String, dynamic> toJson() => _$ToolFunctionPropertyToJson(this);
}
