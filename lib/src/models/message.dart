import 'package:json_annotation/json_annotation.dart';

part 'message.g.dart';

/// 表示DeepSeek API中的消息
@JsonSerializable()
class Message {
  /// 消息角色: 'system', 'user', 'assistant'
  final String role;

  /// 消息内容
  final String content;

  Message({required this.role, required this.content});

  factory Message.system(String content) =>
      Message(role: 'system', content: content);
  factory Message.user(String content) =>
      Message(role: 'user', content: content);
  factory Message.assistant(String content) =>
      Message(role: 'assistant', content: content);

  factory Message.fromJson(Map<String, dynamic> json) =>
      _$MessageFromJson(json);
  Map<String, dynamic> toJson() => _$MessageToJson(this);
}
