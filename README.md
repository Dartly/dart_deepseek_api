<!-- 
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/tools/pub/writing-package-pages). 

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/to/develop-packages). 
-->

# Dart DeepSeek SDK

DeepSeek API的Dart封装，支持流式输出和思维链等功能。

## 功能特点

- 支持DeepSeek聊天API完整功能
- 支持流式输出
- 支持思维链（Chain of Thought）
- 完整的类型支持
- 异常处理
- 简单易用的API接口

## 安装

添加依赖到你的`pubspec.yaml`文件：

```yaml
dependencies:
  dart_deepseek: 
    git:
      url: https://github.com/Dartly/dart_deepseek_api.git
      ref: main
```

然后运行：

```bash
dart pub get
```

## 使用方法

### 初始化客户端

```dart
import 'package:dart_deepseek/dart_deepseek.dart';

// 使用你的API密钥创建客户端
final client = DeepSeekClient(apiKey: 'your_api_key_here');
```

### 基本聊天完成

```dart
final messages = [
  Message.system('你是一个有帮助的助手'),
  Message.user('你好，请告诉我今天的日期'),
];

final response = await client.createChatCompletion(
  messages: messages,
  model: 'deepseek-chat',
  maxTokens: 100,
  temperature: 0.7,
);

print(response.choices.first.delta.content);
```

### 流式聊天完成

```dart
final messages = [
  Message.system('你是一个有帮助的助手'),
  Message.user('请列出5个学习编程的好处'),
];

final stream = client.createStreamingChatCompletion(
  messages: messages,
  model: 'deepseek-chat',
  maxTokens: 200,
  temperature: 0.7,
);

await for (final chunk in stream) {
  for (final choice in chunk.choices) {
    if (choice.delta.content != null && choice.delta.content.isNotEmpty) {
      stdout.write(choice.delta.content);
    }
  }
}
```

### 思维链聊天完成

```dart
final messages = [
  Message.system('你是一个有帮助的助手，可以展示你的推理过程'),
  Message.user('我有三个红苹果和五个绿苹果，然后我吃了两个红苹果，又买了四个绿苹果。我现在总共有多少个苹果？'),
];

final response = await client.createChainOfThoughtChatCompletion(
  messages: messages,
  maxTokens: 500,
  temperature: 0.2,
);

print(response.choices.first.delta.content);
```

### 流式思维链聊天完成

```dart
final messages = [
  Message.system('你是一个有帮助的助手，可以展示你的推理过程'),
  Message.user('如果一个球队在比赛中得了56分，而对手得了87分，那么他们输了多少分？'),
];

final stream = client.createStreamingChainOfThoughtChatCompletion(
  messages: messages,
  maxTokens: 500,
  temperature: 0.2,
);

await for (final chunk in stream) {
  for (final choice in chunk.choices) {
    if (choice.delta.content != null && choice.delta.content.isNotEmpty) {
      stdout.write(choice.delta.content);
    }
  }
}
```

### 关闭客户端

当不再需要客户端时，记得关闭它：

```dart
client.close();
```

## 完整示例

查看 [example/dart_deepseek_example.dart](example/dart_deepseek_example.dart) 获取完整的使用示例。

## API参考

### 主要类

- `DeepSeekClient` - DeepSeek API客户端
- `Message` - 表示聊天消息
- `ChatRequest` - 表示聊天请求
- `ChatResponse` - 表示聊天响应
- `ResponseFormat` - 表示响应格式
- `Tool` - 表示功能工具

### 异常处理

所有API错误会抛出 `DeepSeekApiException` 异常：

```dart
try {
  final response = await client.createChatCompletion(/* ... */);
  // 处理响应
} catch (e) {
  if (e is DeepSeekApiException) {
    print('API错误 ${e.statusCode}: ${e.message}');
  } else {
    print('发生错误: $e');
  }
}
```

## 注意事项

- 使用前请确保你有有效的DeepSeek API密钥
- 对于流式输出，记得正确处理流资源
- 思维链功能需要使用 `deepseek-reasoner` 模型

## 许可证

MIT
