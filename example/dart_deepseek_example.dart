import 'dart:io';

import 'package:dart_deepseek/dart_deepseek.dart';

void main() async {
  // 从环境变量或者配置文件读取API密钥
  final apiKey = 'sk-8f401781dc8e454a9fa5da1f4a962601';

  // 创建客户端
  final client = DeepSeekClient(apiKey: apiKey);

  try {
    // 示例1: 基本聊天完成
    // await basicChatExample(client);

    // 示例2: 流式聊天
    // await streamingChatExample(client);

    // 示例3: 思维链聊天
    // await chainOfThoughtExample(client);

    // 示例4: 流式思维链聊天
    await streamingChainOfThoughtExample(client);
  } catch (e) {
    print('发生错误: $e');
  } finally {
    // 关闭客户端
    client.close();
  }
}

/// 基本聊天完成示例
Future<void> basicChatExample(DeepSeekClient client) async {
  print('\n=== 基本聊天完成示例 ===');

  final messages = [Message.system('你是一个有帮助的助手'), Message.user('你好，请告诉我今天的日期')];

  final response = await client.createChatCompletion(
    messages: messages,
    model: 'deepseek-chat',
    maxTokens: 100,
    temperature: 0.7,
  );

  print('回答: ${response.choices.first.delta?.content ?? ""}');
  print('使用的token数: ${response.usage?.totalTokens}');
}

/// 流式聊天示例
Future<void> streamingChatExample(DeepSeekClient client) async {
  print('\n=== 流式聊天示例 ===');

  final messages = [Message.system('你是一个有帮助的助手'), Message.user('请列出5个学习编程的好处')];

  print('流式响应:');
  final stream = client.createStreamingChatCompletion(
    messages: messages,
    model: 'deepseek-chat',
    maxTokens: 200,
    temperature: 0.7,
  );

  await for (final chunk in stream) {
    for (final choice in chunk.choices) {
      final content = choice.delta?.content;
      if (content != null && content.isNotEmpty) {
        stdout.write(content);
      }
    }
  }
  print('\n');
}

/// 思维链聊天示例
Future<void> chainOfThoughtExample(DeepSeekClient client) async {
  print('\n=== 思维链聊天示例 ===');

  final messages = [
    Message.system('你是一个有帮助的助手，可以展示你的推理过程'),
    Message.user('我有三个红苹果和五个绿苹果，然后我吃了两个红苹果，又买了四个绿苹果。我现在总共有多少个苹果？'),
  ];

  final response = await client.createChainOfThoughtChatCompletion(
    messages: messages,
    maxTokens: 1024,
    temperature: 0.0,
    model: 'deepseek-reasoner',
  );

  print('思维链回答:');
  print(response.choices.first.delta?.content ?? '');
  print('使用的token数: ${response.usage?.totalTokens}');

  if (response.usage?.completionTokensDetails?.reasoningTokens != null) {
    print(
      '推理token数: ${response.usage?.completionTokensDetails!.reasoningTokens}',
    );
  }
}

/// 流式思维链聊天示例
Future<void> streamingChainOfThoughtExample(DeepSeekClient client) async {
  print('\n=== 流式思维链聊天示例 ===');

  final messages = [
    Message.user('明天会下雨吗？。'),
  ];

  print('流式思维链响应:');
  final stream = client.createStreamingChainOfThoughtChatCompletion(
    messages: messages,
    maxTokens: 4086,
    temperature: 0.2,
  );

  String shownReasoningContent = ''; // 用于去重连续的推理内容

  await for (final chunk in stream) {
    for (final choice in chunk.choices) {
      final delta = choice.delta;

      // 打印推理内容
      if (delta?.reasoningContent != null &&
          delta!.reasoningContent!.isNotEmpty) {
        // 简单的去重，避免连续打印完全相同的推理步骤片段
        // 只有当新的推理内容与已显示的推理内容末尾不同时才打印
        if (shownReasoningContent.isEmpty ||
            !shownReasoningContent.endsWith(delta.reasoningContent!)) {
          stdout.write('\n(推理: ${delta.reasoningContent})');
          shownReasoningContent += delta.reasoningContent!;
        }
      }

      // 打印普通内容
      if (delta?.content != null && delta!.content!.isNotEmpty) {
        stdout.write(delta.content);
        // 如果普通内容出现，且之前有推理内容，且当前块没有新的推理内容，
        // 可能表示一段推理结束，清空shownReasoningContent以准备打印新的推理链
        if (shownReasoningContent.isNotEmpty &&
            (delta.reasoningContent == null ||
                delta.reasoningContent!.isEmpty)) {
          shownReasoningContent = '';
        }
      }
    }
  }
  print('\n'); // 确保最后换行
}
