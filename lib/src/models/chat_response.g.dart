// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatResponse _$ChatResponseFromJson(Map<String, dynamic> json) => ChatResponse(
  id: json['id'] as String,
  model: json['model'] as String,
  choices:
      (json['choices'] as List<dynamic>)
          .map((e) => ChatResponseChoice.fromJson(e as Map<String, dynamic>))
          .toList(),
  usage:
      json['usage'] == null
          ? null
          : ChatResponseUsage.fromJson(json['usage'] as Map<String, dynamic>),
  streamedData:
      (json['streamed_data'] as List<dynamic>?)
          ?.map((e) => StreamedData.fromJson(e as Map<String, dynamic>))
          .toList(),
);

Map<String, dynamic> _$ChatResponseToJson(ChatResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'model': instance.model,
      'choices': instance.choices,
      'usage': instance.usage,
      if (instance.streamedData case final value?) 'streamed_data': value,
    };

ChatResponseChoice _$ChatResponseChoiceFromJson(Map<String, dynamic> json) =>
    ChatResponseChoice(
      delta:
          json['delta'] == null
              ? null
              : ChatResponseDelta.fromJson(
                json['delta'] as Map<String, dynamic>,
              ),
    );

Map<String, dynamic> _$ChatResponseChoiceToJson(ChatResponseChoice instance) =>
    <String, dynamic>{'delta': instance.delta};

ChatResponseDelta _$ChatResponseDeltaFromJson(Map<String, dynamic> json) =>
    ChatResponseDelta(
      role: json['role'] as String?,
      content: json['content'] as String?,
      reasoningContent: json['reasoning_content'] as String?,
    );

Map<String, dynamic> _$ChatResponseDeltaToJson(
  ChatResponseDelta instance,
) => <String, dynamic>{
  if (instance.role case final value?) 'role': value,
  if (instance.content case final value?) 'content': value,
  if (instance.reasoningContent case final value?) 'reasoning_content': value,
};

ChatResponseUsage _$ChatResponseUsageFromJson(Map<String, dynamic> json) =>
    ChatResponseUsage(
      promptTokens: (json['prompt_tokens'] as num).toInt(),
      completionTokens: (json['completion_tokens'] as num).toInt(),
      totalTokens: (json['total_tokens'] as num).toInt(),
      promptTokensDetails:
          json['prompt_tokens_details'] == null
              ? null
              : TokenDetails.fromJson(
                json['prompt_tokens_details'] as Map<String, dynamic>,
              ),
      completionTokensDetails:
          json['completion_tokens_details'] == null
              ? null
              : TokenDetails.fromJson(
                json['completion_tokens_details'] as Map<String, dynamic>,
              ),
      promptCacheHitTokens: (json['prompt_cache_hit_tokens'] as num?)?.toInt(),
      promptCacheMissTokens:
          (json['prompt_cache_miss_tokens'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ChatResponseUsageToJson(ChatResponseUsage instance) =>
    <String, dynamic>{
      'prompt_tokens': instance.promptTokens,
      'completion_tokens': instance.completionTokens,
      'total_tokens': instance.totalTokens,
      if (instance.promptTokensDetails case final value?)
        'prompt_tokens_details': value,
      if (instance.completionTokensDetails case final value?)
        'completion_tokens_details': value,
      if (instance.promptCacheHitTokens case final value?)
        'prompt_cache_hit_tokens': value,
      if (instance.promptCacheMissTokens case final value?)
        'prompt_cache_miss_tokens': value,
    };

TokenDetails _$TokenDetailsFromJson(Map<String, dynamic> json) => TokenDetails(
  cachedTokens: (json['cached_tokens'] as num?)?.toInt(),
  reasoningTokens: (json['reasoning_tokens'] as num?)?.toInt(),
);

Map<String, dynamic> _$TokenDetailsToJson(TokenDetails instance) =>
    <String, dynamic>{
      if (instance.cachedTokens case final value?) 'cached_tokens': value,
      if (instance.reasoningTokens case final value?) 'reasoning_tokens': value,
    };

StreamedData _$StreamedDataFromJson(Map<String, dynamic> json) => StreamedData(
  nonce: json['nonce'] as String?,
  id: json['id'] as String,
  object: json['object'] as String,
  created: (json['created'] as num).toInt(),
  model: json['model'] as String,
  systemFingerprint: json['system_fingerprint'] as String,
  choices:
      (json['choices'] as List<dynamic>)
          .map((e) => StreamedDataChoice.fromJson(e as Map<String, dynamic>))
          .toList(),
  usage:
      json['usage'] == null
          ? null
          : ChatResponseUsage.fromJson(json['usage'] as Map<String, dynamic>),
);

Map<String, dynamic> _$StreamedDataToJson(StreamedData instance) =>
    <String, dynamic>{
      if (instance.nonce case final value?) 'nonce': value,
      'id': instance.id,
      'object': instance.object,
      'created': instance.created,
      'model': instance.model,
      'system_fingerprint': instance.systemFingerprint,
      'choices': instance.choices,
      'usage': instance.usage,
    };

StreamedDataChoice _$StreamedDataChoiceFromJson(Map<String, dynamic> json) =>
    StreamedDataChoice(
      index: (json['index'] as num).toInt(),
      delta: StreamedDataDelta.fromJson(json['delta'] as Map<String, dynamic>),
      logprobs: json['logprobs'],
      finishReason: json['finish_reason'] as String?,
    );

Map<String, dynamic> _$StreamedDataChoiceToJson(StreamedDataChoice instance) =>
    <String, dynamic>{
      'index': instance.index,
      'delta': instance.delta,
      if (instance.logprobs case final value?) 'logprobs': value,
      if (instance.finishReason case final value?) 'finish_reason': value,
    };

StreamedDataDelta _$StreamedDataDeltaFromJson(Map<String, dynamic> json) =>
    StreamedDataDelta(
      content: json['content'] as String?,
      reasoningContent: json['reasoning_content'] as String?,
    );

Map<String, dynamic> _$StreamedDataDeltaToJson(
  StreamedDataDelta instance,
) => <String, dynamic>{
  if (instance.content case final value?) 'content': value,
  if (instance.reasoningContent case final value?) 'reasoning_content': value,
};
