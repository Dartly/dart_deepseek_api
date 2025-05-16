// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tool.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Tool _$ToolFromJson(Map<String, dynamic> json) => Tool(
  type: json['type'] as String,
  function: ToolFunction.fromJson(json['function'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ToolToJson(Tool instance) => <String, dynamic>{
  'type': instance.type,
  'function': instance.function,
};

ToolFunction _$ToolFunctionFromJson(Map<String, dynamic> json) => ToolFunction(
  name: json['name'] as String,
  description: json['description'] as String,
  parameters: ToolFunctionParameters.fromJson(
    json['parameters'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$ToolFunctionToJson(ToolFunction instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'parameters': instance.parameters,
    };

ToolFunctionParameters _$ToolFunctionParametersFromJson(
  Map<String, dynamic> json,
) => ToolFunctionParameters(
  type: json['type'] as String,
  properties: (json['properties'] as Map<String, dynamic>).map(
    (k, e) =>
        MapEntry(k, ToolFunctionProperty.fromJson(e as Map<String, dynamic>)),
  ),
  required:
      (json['required'] as List<dynamic>).map((e) => e as String).toList(),
);

Map<String, dynamic> _$ToolFunctionParametersToJson(
  ToolFunctionParameters instance,
) => <String, dynamic>{
  'type': instance.type,
  'properties': instance.properties,
  'required': instance.required,
};

ToolFunctionProperty _$ToolFunctionPropertyFromJson(
  Map<String, dynamic> json,
) => ToolFunctionProperty(
  type: json['type'] as String,
  description: json['description'] as String,
);

Map<String, dynamic> _$ToolFunctionPropertyToJson(
  ToolFunctionProperty instance,
) => <String, dynamic>{
  'type': instance.type,
  'description': instance.description,
};
