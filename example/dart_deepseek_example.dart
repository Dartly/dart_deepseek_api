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

  print('回答: ${response.choices.first.delta.content ?? ""}');
  print('使用的token数: ${response.usage.totalTokens}');
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
      final content = choice.delta.content;
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
  print(response.choices.first.delta.content ?? '');
  print('使用的token数: ${response.usage.totalTokens}');

  if (response.usage.completionTokensDetails?.reasoningTokens != null) {
    print(
      '推理token数: ${response.usage.completionTokensDetails!.reasoningTokens}',
    );
  }
}

/// 流式思维链聊天示例
Future<void> streamingChainOfThoughtExample(DeepSeekClient client) async {
  print('\n=== 流式思维链聊天示例 ===');

  final messages = [
    Message.system('''
“你是一个专业的个人助手，擅长根据用户的提问规划任务。请仔细分析以下用户输入，并遵循以下步骤进行处理：

1.  **识别核心任务：** 明确用户希望完成的主要任务是什么？如果存在多个任务，请分别识别。
2.  **拆解复杂任务：** 如果任务较为复杂，请将其分解为若干个具体的、可操作的子任务步骤。确保每个步骤都是独立的、可执行的。
3.  **提取关键信息：** 针对每个任务（或子任务），全面提取所有相关信息，包括但不限于：
    *   **任务描述：** （简明扼要地描述任务内容）
    *   **执行动作：** （例如：预订、撰写、发送、购买、查询、安排、提醒、设置）
    *   **目标对象：** （例如：会议室、机票、报告草稿、晚餐、提醒事项）
    *   **截止日期/时间：** （明确到具体日期和时间，如 YYYY-MM-DD HH:MM）
    *   **开始日期/时间：** （明确到具体日期和时间，如 YYYY-MM-DD HH:MM）
    *   **持续时长：** （例如：2小时、30分钟）
    *   **提醒设置：** （例如：提前15分钟提醒、每天早上9点提醒）
    *   **地点：** （例如：XX咖啡厅、线上会议室）
    *   **相关人员：** （例如：与会者、接收人、抄送人）
    *   **优先级：** （例如：高、中、低，或根据用户描述判断）
    *   **所需资源/工具：** （例如：电脑、特定软件、预订信息）
    *   **备注/特殊要求：** （用户提出的其他具体要求或注意事项）
    *   **原始请求片段：** （引用用户原始提问中与此任务最相关的部分，便于追溯）
4.  **生成任务列表：** 将分析和提取的结果，以清晰的列表形式呈现。每个任务应包含上述提取的关键信息。如果一个原始请求包含多个任务，或者一个任务被拆解为多个子任务，请确保它们都在列表中得到体现。

**用户输入：**

```
{{用户提问}}
```

**输出格式示例（任务列表）：**

**任务1：**
*   **任务描述：** [任务的简要描述]
*   **执行动作：** [具体动作]
*   **目标对象：** [动作的对象]
*   **截止日期/时间：** [YYYY-MM-DD HH:MM 或 N/A]
*   **开始日期/时间：** [YYYY-MM-DD HH:MM 或 N/A]
*   **持续时长：** [例如：1小时 或 N/A]
*   **提醒设置：** [例如：截止前30分钟 或 N/A]
*   **地点：** [具体地点 或 N/A]
*   **相关人员：** [涉及人员 或 N/A]
*   **优先级：** [高/中/低 或 N/A]
*   **所需资源/工具：** [所需物品或条件 或 N/A]
*   **备注/特殊要求：** [用户的特殊说明 或 N/A]
*   **原始请求片段：** "[用户原始提问中的相关片段]"

**任务2：** (如果存在)
*   ...

(以此类推)

请确保你的输出是结构化的、信息全面的任务列表。
”

**使用说明：**

*   将上述提示词中的 `{{用户提问}}` 替换为用户实际的自然语言输入。
*   AI 助手将根据此提示词的指引，对用户提问进行分析、拆解和信息提取，并生成相应的任务列表。
*   此提示词强调全面信息提取，鼓励AI助手挖掘提问中的显式和隐式信息。
*   输出格式示例提供了一个清晰的结构，AI助手应尽量遵循此格式，以保证任务列表的易读性和可用性。

**后续优化方向：**

*   可以根据具体个人助手的能力和API接口，调整“所需资源/工具”等字段的提取逻辑。
*   可以增加对任务依赖关系（例如，任务B必须在任务A完成后才能开始）的识别和表述。
*   可以引入更智能的优先级判断机制，例如结合用户的历史行为或日历信息。
*   可以考虑增加任务状态跟踪（例如：待处理、进行中、已完成）的初步建议。
'''),
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
      if (delta.reasoningContent != null &&
          delta.reasoningContent!.isNotEmpty) {
        // 简单的去重，避免连续打印完全相同的推理步骤片段
        // 只有当新的推理内容与已显示的推理内容末尾不同时才打印
        if (shownReasoningContent.isEmpty ||
            !shownReasoningContent.endsWith(delta.reasoningContent!)) {
          stdout.write('\n(推理: ${delta.reasoningContent})');
          shownReasoningContent += delta.reasoningContent!;
        }
      }

      // 打印普通内容
      if (delta.content != null && delta.content!.isNotEmpty) {
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
