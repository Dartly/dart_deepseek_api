import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'models/chat_request.dart';
import 'models/chat_response.dart';
import 'models/message.dart';
import 'models/response_format.dart';

/// DeepSeek API客户端
class DeepSeekClient {
  /// DeepSeek API基本URL
  static const String _baseUrl = 'https://api.deepseek.com';

  /// API密钥
  final String apiKey;

  /// HTTP客户端
  http.Client _client;

  /// 创建一个新的DeepSeek API客户端
  DeepSeekClient({required this.apiKey, http.Client? client})
    : _client = client ?? http.Client();

  /// 关闭客户端
  void close() {
    _client.close();
  }

  /// 取消当前请求
  void cancelRequest() {
    _client.close();
    _client = http.Client();
  }

  /// 创建授权头
  Map<String, String> _createHeaders() {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $apiKey',
    };
  }

  /// 发送聊天完成请求
  Future<ChatResponse> createChatCompletion({
    required List<Message> messages,
    String model = 'deepseek-chat',
    double? temperature,
    double? topP,
    int? maxTokens,
    List<String>? stop,
    double? frequencyPenalty,
    double? presencePenalty,
    ResponseFormat? responseFormat,
    bool? logprobs,
    int? topLogprobs,
  }) async {
    final request = ChatRequest(
      messages: messages,
      model: model,
      temperature: temperature,
      topP: topP,
      maxTokens: maxTokens,
      stop: stop,
      frequencyPenalty: frequencyPenalty,
      presencePenalty: presencePenalty,
      responseFormat: responseFormat,
      logprobs: logprobs,
      topLogprobs: topLogprobs,
      stream: false,
    );

    final response = await _client.post(
      Uri.parse('$_baseUrl/chat/completions'),
      headers: _createHeaders(),
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode != 200) {
      throw DeepSeekApiException(
        statusCode: response.statusCode,
        message: response.body,
      );
    }
    print('------------------------${json.encode(response.body)}');

    return ChatResponse.fromJson(jsonDecode(response.body));
  }

  /// 发送流式聊天完成请求
  Stream<ChatResponse> createStreamingChatCompletion({
    required List<Message> messages,
    String model = 'deepseek-chat',
    double? temperature,
    double? topP,
    int? maxTokens,
    List<String>? stop,
    double? frequencyPenalty,
    double? presencePenalty,
    ResponseFormat? responseFormat,
    bool? logprobs,
    int? topLogprobs,
    Map<String, dynamic>? streamOptions,
  }) async* {
    // 创建一个可取消的流控制器
    final streamController = StreamController<ChatResponse>();
    bool isCancelled = false;
    final requestBody = ChatRequest(
      messages: messages,
      model: model,
      temperature: temperature,
      topP: topP,
      maxTokens: maxTokens,
      stop: stop,
      frequencyPenalty: frequencyPenalty,
      presencePenalty: presencePenalty,
      responseFormat: responseFormat,
      logprobs: logprobs,
      topLogprobs: topLogprobs,
      stream: true,
      streamOptions: streamOptions,
    );

    // 创建一个StreamedRequest
    final request =
        http.Request('POST', Uri.parse('$_baseUrl/chat/completions'))
          ..headers.addAll(_createHeaders())
          ..body = jsonEncode(requestBody.toJson());

    // 监听取消请求
    streamController.onCancel = () {
      isCancelled = true;
      _client.close();
      _client = http.Client();
    };

    // 发送请求并获取StreamedResponse
    final http.StreamedResponse streamedResponse = await _client.send(request);

    if (streamedResponse.statusCode != 200) {
      // 如果状态码不是200，需要读取响应体以获取错误信息
      final responseBody = await streamedResponse.stream.bytesToString();
      throw DeepSeekApiException(
        statusCode: streamedResponse.statusCode,
        message: responseBody,
      );
    }

    // 将HTTP响应流分割成行，并解析每行JSON
    // 注意：这里我们传递的是streamedResponse.stream，而不是整个Response对象
    await for (final chunk in _parseStreamedChunks(streamedResponse.stream)) {
      if (isCancelled) {
        break;
      }
      yield chunk;
    }
    await streamController.close();
  }

  /// 解析 SSE 流中的 JSON 块 (从 Stream<List<int>>)
  Stream<ChatResponse> _parseStreamedChunks(
    Stream<List<int>> byteStream,
  ) async* {
    final stream = byteStream
        .transform(utf8.decoder)
        .transform(const LineSplitter())
        .where((line) => line.isNotEmpty && line.startsWith('data: '))
        .map((line) => line.substring(6).trim()) // 去掉 "data: " 前缀
        .where((line) => line != '[DONE]')
        .map((line) {
          try {
            final Map<String, dynamic> json = jsonDecode(line);
            return _createSafeResponse(json, line);
          } catch (e) {
            throw DeepSeekApiException(
              statusCode: -1,
              message: 'Failed to parse streaming response: $e, data: $line',
            );
          }
        });

    await for (final chunk in stream) {
      yield chunk;
    }
  }

  /// 创建一个安全的ChatResponse对象，处理可能的null字段
  ChatResponse _createSafeResponse(Map<String, dynamic> json, String rawData) {
    try {
      // 提取基本字段
      final String id = json['id'] as String;
      final String model = json['model'] as String;

      // 安全处理choices数组
      final List<dynamic> choicesJson = json['choices'] as List<dynamic>;
      final List<ChatResponseChoice> choices =
          choicesJson.map((choiceJson) {
            // 确保choiceJson本身是一个Map
            if (choiceJson is! Map<String, dynamic>) {
              // 如果choiceJson不是预期的Map，则抛出错误或返回一个默认/空的Choice
              // 这里我们选择创建一个空的delta，更安全的做法可能是记录错误并跳过这个choice
              return ChatResponseChoice(delta: ChatResponseDelta());
            }

            final dynamic rawDelta = choiceJson['delta'];
            // 如果delta为null，则使用空Map，否则使用实际的delta Map
            final Map<String, dynamic> deltaJson =
                (rawDelta is Map<String, dynamic>)
                    ? rawDelta
                    : <String, dynamic>{};

            // 安全处理delta对象
            final ChatResponseDelta delta = ChatResponseDelta(
              role: deltaJson['role'] as String?,
              content: deltaJson['content'] as String?,
              reasoningContent: deltaJson['reasoning_content'] as String?,
            );

            return ChatResponseChoice(delta: delta);
          }).toList();

      // 安全处理usage对象 - 如果usage为null，则创建一个空的Usage对象
      final dynamic rawUsage = json['usage'];
      final Map<String, dynamic>? usageJson =
          (rawUsage is Map<String, dynamic>) ? rawUsage : null;
      final ChatResponseUsage usage =
          usageJson != null
              ? ChatResponseUsage(
                promptTokens: usageJson['prompt_tokens'] as int,
                completionTokens: usageJson['completion_tokens'] as int,
                totalTokens: usageJson['total_tokens'] as int,
                promptTokensDetails: _safeTokenDetails(
                  usageJson['prompt_tokens_details'],
                ),
                completionTokensDetails: _safeTokenDetails(
                  usageJson['completion_tokens_details'],
                ),
                promptCacheHitTokens:
                    usageJson['prompt_cache_hit_tokens'] as int?,
                promptCacheMissTokens:
                    usageJson['prompt_cache_miss_tokens'] as int?,
              )
              : ChatResponseUsage(
                promptTokens: 0,
                completionTokens: 0,
                totalTokens: 0,
              ); // 默认值

      return ChatResponse(id: id, model: model, choices: choices, usage: usage);
    } catch (e) {
      // 如果有任何解析错误，提供更详细的错误信息
      throw DeepSeekApiException(
        statusCode: -1,
        message: 'Error creating safe response: $e, data: $rawData',
      );
    }
  }

  /// 安全处理TokenDetails对象
  TokenDetails? _safeTokenDetails(dynamic json) {
    if (json == null) return null;
    if (json is! Map<String, dynamic>) return null;

    return TokenDetails(
      cachedTokens: json['cached_tokens'] as int?,
      reasoningTokens: json['reasoning_tokens'] as int?,
    );
  }

  /// 创建使用思维链的聊天完成
  Future<ChatResponse> createChainOfThoughtChatCompletion({
    required List<Message> messages,
    String model = 'deepseek-reasoner',
    double? temperature,
    double? topP,
    int? maxTokens,
    List<String>? stop,
    double? frequencyPenalty,
    double? presencePenalty,
    ResponseFormat? responseFormat,
    bool? logprobs,
    int? topLogprobs,
  }) async {
    // 思维链使用 deepseek-reasoner 模型
    return createChatCompletion(
      messages: messages,
      model: model,
      temperature: temperature,
      topP: topP,
      maxTokens: maxTokens,
      stop: stop,
      frequencyPenalty: frequencyPenalty,
      presencePenalty: presencePenalty,
      responseFormat: responseFormat,
      logprobs: logprobs,
      topLogprobs: topLogprobs,
    );
  }

  /// 创建流式思维链聊天完成
  Stream<ChatResponse> createStreamingChainOfThoughtChatCompletion({
    required List<Message> messages,
    String model = 'deepseek-reasoner',
    double? temperature,
    double? topP,
    int? maxTokens,
    List<String>? stop,
    double? frequencyPenalty,
    double? presencePenalty,
    ResponseFormat? responseFormat,
    bool? logprobs,
    int? topLogprobs,
    Map<String, dynamic>? streamOptions,
  }) {
    // 思维链使用 deepseek-reasoner 模型
    return createStreamingChatCompletion(
      messages: messages,
      model: model,
      temperature: temperature,
      topP: topP,
      maxTokens: maxTokens,
      stop: stop,
      frequencyPenalty: frequencyPenalty,
      presencePenalty: presencePenalty,
      responseFormat: responseFormat,
      logprobs: logprobs,
      topLogprobs: topLogprobs,
      streamOptions: streamOptions,
    );
  }
}

/// DeepSeek API异常
class DeepSeekApiException implements Exception {
  /// HTTP状态码
  final int statusCode;

  /// 错误消息
  final String message;

  DeepSeekApiException({required this.statusCode, required this.message});

  @override
  String toString() {
    return 'DeepSeekApiException: [$statusCode] $message';
  }
}
