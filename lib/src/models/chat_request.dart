import 'package:json_annotation/json_annotation.dart';
import 'message.dart';
import 'response_format.dart';
import 'tool.dart';

part 'chat_request.g.dart';

/// DeepSeek聊天完成请求模型
@JsonSerializable()
class ChatRequest {
  /// 消息列表
  final List<Message> messages;

  /// 模型名称，如 'deepseek-chat'
  final String model;

  /// 重复惩罚
  @JsonKey(includeIfNull: false)
  final double? frequencyPenalty;

  /// 最大输出token数
  @JsonKey(name: 'max_tokens', includeIfNull: false)
  final int? maxTokens;

  /// 存在惩罚
  @JsonKey(includeIfNull: false)
  final double? presencePenalty;

  /// 响应格式
  @JsonKey(name: 'response_format', includeIfNull: false)
  final ResponseFormat? responseFormat;

  /// 停止标记
  @JsonKey(includeIfNull: false)
  final List<String>? stop;

  /// 是否流式响应
  @JsonKey(includeIfNull: false)
  final bool? stream;

  /// 流式选项
  @JsonKey(name: 'stream_options', includeIfNull: false)
  final Map<String, dynamic>? streamOptions;

  /// 温度
  @JsonKey(includeIfNull: false)
  final double? temperature;

  /// Top P 采样
  @JsonKey(name: 'top_p', includeIfNull: false)
  final double? topP;

  /// 工具列表
  @JsonKey(includeIfNull: false)
  final List<Tool>? tools;

  /// 工具选择
  @JsonKey(name: 'tool_choice', includeIfNull: false)
  final String? toolChoice;

  /// 是否返回logprobs
  @JsonKey(includeIfNull: false)
  final bool? logprobs;

  /// Top Logprobs
  @JsonKey(name: 'top_logprobs', includeIfNull: false)
  final int? topLogprobs;

  ChatRequest({
    required this.messages,
    required this.model,
    this.frequencyPenalty,
    this.maxTokens,
    this.presencePenalty,
    this.responseFormat,
    this.stop,
    this.stream,
    this.streamOptions,
    this.temperature,
    this.topP,
    this.tools,
    this.toolChoice,
    this.logprobs,
    this.topLogprobs,
  });

  factory ChatRequest.fromJson(Map<String, dynamic> json) =>
      _$ChatRequestFromJson(json);
  Map<String, dynamic> toJson() => _$ChatRequestToJson(this);
}
