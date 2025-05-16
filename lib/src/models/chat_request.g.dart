// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatRequest _$ChatRequestFromJson(Map<String, dynamic> json) => ChatRequest(
  messages:
      (json['messages'] as List<dynamic>)
          .map((e) => Message.fromJson(e as Map<String, dynamic>))
          .toList(),
  model: json['model'] as String,
  frequencyPenalty: (json['frequencyPenalty'] as num?)?.toDouble(),
  maxTokens: (json['max_tokens'] as num?)?.toInt(),
  presencePenalty: (json['presencePenalty'] as num?)?.toDouble(),
  responseFormat:
      json['response_format'] == null
          ? null
          : ResponseFormat.fromJson(
            json['response_format'] as Map<String, dynamic>,
          ),
  stop: (json['stop'] as List<dynamic>?)?.map((e) => e as String).toList(),
  stream: json['stream'] as bool?,
  streamOptions: json['stream_options'] as Map<String, dynamic>?,
  temperature: (json['temperature'] as num?)?.toDouble(),
  topP: (json['top_p'] as num?)?.toDouble(),
  tools:
      (json['tools'] as List<dynamic>?)
          ?.map((e) => Tool.fromJson(e as Map<String, dynamic>))
          .toList(),
  toolChoice: json['tool_choice'] as String?,
  logprobs: json['logprobs'] as bool?,
  topLogprobs: (json['top_logprobs'] as num?)?.toInt(),
);

Map<String, dynamic> _$ChatRequestToJson(
  ChatRequest instance,
) => <String, dynamic>{
  'messages': instance.messages,
  'model': instance.model,
  if (instance.frequencyPenalty case final value?) 'frequencyPenalty': value,
  if (instance.maxTokens case final value?) 'max_tokens': value,
  if (instance.presencePenalty case final value?) 'presencePenalty': value,
  if (instance.responseFormat case final value?) 'response_format': value,
  if (instance.stop case final value?) 'stop': value,
  if (instance.stream case final value?) 'stream': value,
  if (instance.streamOptions case final value?) 'stream_options': value,
  if (instance.temperature case final value?) 'temperature': value,
  if (instance.topP case final value?) 'top_p': value,
  if (instance.tools case final value?) 'tools': value,
  if (instance.toolChoice case final value?) 'tool_choice': value,
  if (instance.logprobs case final value?) 'logprobs': value,
  if (instance.topLogprobs case final value?) 'top_logprobs': value,
};
