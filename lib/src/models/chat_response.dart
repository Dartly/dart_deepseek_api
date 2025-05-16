import 'package:json_annotation/json_annotation.dart';

part 'chat_response.g.dart';

/// DeepSeek聊天完成响应
@JsonSerializable()
class ChatResponse {
  /// 响应ID
  final String id;

  /// 使用的模型
  final String model;

  /// 响应选择
  final List<ChatResponseChoice> choices;

  /// 使用统计
  final ChatResponseUsage usage;

  /// 流式数据（仅在流式请求中使用）
  @JsonKey(name: 'streamed_data', includeIfNull: false)
  final List<StreamedData>? streamedData;

  ChatResponse({
    required this.id,
    required this.model,
    required this.choices,
    required this.usage,
    this.streamedData,
  });

  factory ChatResponse.fromJson(Map<String, dynamic> json) =>
      _$ChatResponseFromJson(json);
  Map<String, dynamic> toJson() => _$ChatResponseToJson(this);
}

/// 聊天响应选择
@JsonSerializable()
class ChatResponseChoice {
  /// 增量内容
  final ChatResponseDelta delta;

  ChatResponseChoice({required this.delta});

  factory ChatResponseChoice.fromJson(Map<String, dynamic> json) =>
      _$ChatResponseChoiceFromJson(json);
  Map<String, dynamic> toJson() => _$ChatResponseChoiceToJson(this);
}

/// 聊天响应增量内容
@JsonSerializable()
class ChatResponseDelta {
  /// 角色
  @JsonKey(includeIfNull: false)
  final String? role;

  /// 内容
  @JsonKey(includeIfNull: false)
  final String? content;

  /// 推理内容
  @JsonKey(name: 'reasoning_content', includeIfNull: false)
  final String? reasoningContent;

  ChatResponseDelta({this.role, this.content, this.reasoningContent});

  factory ChatResponseDelta.fromJson(Map<String, dynamic> json) =>
      _$ChatResponseDeltaFromJson(json);
  Map<String, dynamic> toJson() => _$ChatResponseDeltaToJson(this);
}

/// 聊天响应使用统计
@JsonSerializable()
class ChatResponseUsage {
  /// 提示token数
  @JsonKey(name: 'prompt_tokens')
  final int promptTokens;

  /// 完成token数
  @JsonKey(name: 'completion_tokens')
  final int completionTokens;

  /// 总token数
  @JsonKey(name: 'total_tokens')
  final int totalTokens;

  /// 提示token详情
  @JsonKey(name: 'prompt_tokens_details', includeIfNull: false)
  final TokenDetails? promptTokensDetails;

  /// 完成token详情
  @JsonKey(name: 'completion_tokens_details', includeIfNull: false)
  final TokenDetails? completionTokensDetails;

  /// 缓存命中token数
  @JsonKey(name: 'prompt_cache_hit_tokens', includeIfNull: false)
  final int? promptCacheHitTokens;

  /// 缓存未命中token数
  @JsonKey(name: 'prompt_cache_miss_tokens', includeIfNull: false)
  final int? promptCacheMissTokens;

  ChatResponseUsage({
    required this.promptTokens,
    required this.completionTokens,
    required this.totalTokens,
    this.promptTokensDetails,
    this.completionTokensDetails,
    this.promptCacheHitTokens,
    this.promptCacheMissTokens,
  });

  factory ChatResponseUsage.fromJson(Map<String, dynamic> json) =>
      _$ChatResponseUsageFromJson(json);
  Map<String, dynamic> toJson() => _$ChatResponseUsageToJson(this);
}

/// Token详情
@JsonSerializable()
class TokenDetails {
  /// 缓存token
  @JsonKey(name: 'cached_tokens', includeIfNull: false)
  final int? cachedTokens;

  /// 推理token
  @JsonKey(name: 'reasoning_tokens', includeIfNull: false)
  final int? reasoningTokens;

  TokenDetails({this.cachedTokens, this.reasoningTokens});

  factory TokenDetails.fromJson(Map<String, dynamic> json) =>
      _$TokenDetailsFromJson(json);
  Map<String, dynamic> toJson() => _$TokenDetailsToJson(this);
}

/// 流式数据
@JsonSerializable()
class StreamedData {
  /// nonce值
  @JsonKey(includeIfNull: false)
  final String? nonce;

  /// ID
  final String id;

  /// 对象类型
  final String object;

  /// 创建时间
  final int created;

  /// 模型
  final String model;

  /// 系统指纹
  @JsonKey(name: 'system_fingerprint')
  final String systemFingerprint;

  /// 选择列表
  final List<StreamedDataChoice> choices;

  /// 使用统计
  final ChatResponseUsage usage;

  StreamedData({
    this.nonce,
    required this.id,
    required this.object,
    required this.created,
    required this.model,
    required this.systemFingerprint,
    required this.choices,
    required this.usage,
  });

  factory StreamedData.fromJson(Map<String, dynamic> json) =>
      _$StreamedDataFromJson(json);
  Map<String, dynamic> toJson() => _$StreamedDataToJson(this);
}

/// 流式数据选择
@JsonSerializable()
class StreamedDataChoice {
  /// 索引
  final int index;

  /// 增量
  final StreamedDataDelta delta;

  /// 日志概率
  @JsonKey(includeIfNull: false)
  final dynamic logprobs;

  /// 结束原因
  @JsonKey(name: 'finish_reason', includeIfNull: false)
  final String? finishReason;

  StreamedDataChoice({
    required this.index,
    required this.delta,
    this.logprobs,
    this.finishReason,
  });

  factory StreamedDataChoice.fromJson(Map<String, dynamic> json) =>
      _$StreamedDataChoiceFromJson(json);
  Map<String, dynamic> toJson() => _$StreamedDataChoiceToJson(this);
}

/// 流式数据增量
@JsonSerializable()
class StreamedDataDelta {
  /// 内容
  @JsonKey(includeIfNull: false)
  final String? content;

  /// 推理内容
  @JsonKey(name: 'reasoning_content', includeIfNull: false)
  final String? reasoningContent;

  StreamedDataDelta({this.content, this.reasoningContent});

  factory StreamedDataDelta.fromJson(Map<String, dynamic> json) =>
      _$StreamedDataDeltaFromJson(json);
  Map<String, dynamic> toJson() => _$StreamedDataDeltaToJson(this);
}
