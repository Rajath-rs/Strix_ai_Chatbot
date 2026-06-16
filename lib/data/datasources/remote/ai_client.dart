import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../../../core/errors/exceptions.dart';

abstract class AIClient {
  Future<String> sendMessage(
    String baseUrl,
    String apiKey,
    String model,
    List<Map<String, String>> messages,
  );

  /// Streams assistant tokens/partial text when the provider supports it.
  ///
  /// If streaming is not supported for the given provider, implementations
  /// should fall back to non-streaming and emit a single chunk then close.
  Stream<String> streamMessage(
    String baseUrl,
    String apiKey,
    String model,
    List<Map<String, String>> messages,
  );
}


class AIClientImpl implements AIClient {
  final http.Client httpClient;
  static const int timeoutSeconds = 30;

  AIClientImpl(this.httpClient);

  @override
  Stream<String> streamMessage(
    String baseUrl,
    String apiKey,
    String model,
    List<Map<String, String>> messages,
  ) async* {
    // Only OpenAI-compatible streaming is implemented here (SSE).
    // If the provider looks like Gemini, fall back to non-streaming.
    if (_looksLikeGeminiBaseUrl(baseUrl)) {
      yield await sendMessage(baseUrl, apiKey, model, messages);
      return;
    }

    final normalizedBaseUrl = _normalizeOpenRouterBaseUrl(baseUrl);
    final url = Uri.parse('$normalizedBaseUrl/chat/completions');

    final payload = {
      'model': model,
      'messages': messages,
      'temperature': 0.7,
      'max_tokens': 2000,
      'stream': true,
    };

    final request = http.Request('POST', url);
    request.headers.addAll({
      'Authorization': 'Bearer $apiKey',
      'Content-Type': 'application/json',
    });
    request.body = jsonEncode(payload);

    http.StreamedResponse response;
    try {
      response = await httpClient.send(request).timeout(
            const Duration(seconds: timeoutSeconds),
          );
    } on SocketException catch (e) {
      throw NetworkException('Network error: ${e.message}');
    } on http.ClientException catch (e) {
      throw NetworkException(e.message);
    }

    if (response.statusCode != 200) {
      final body = await response.stream.bytesToString();
      if (response.statusCode == 401) {
        throw AuthenticationException('Invalid API key or unauthorized access: $body');
      }
      if (response.statusCode == 429) {
        throw ServerException('Rate limit exceeded. Please try again later: $body');
      }
      throw ServerException(
        'API request failed with status ${response.statusCode}: $body',
        statusCode: response.statusCode,
      );
    }

    // SSE parsing: lines like "data: {...}"; stream ends with "data: [DONE]".
    final buffer = StringBuffer();
    await for (final chunk in response.stream.transform(const Utf8Decoder())) {
      buffer.write(chunk);

      // Process complete lines.
      while (true) {
        final content = buffer.toString();
        final newlineIndex = content.indexOf('\n');
        if (newlineIndex == -1) break;

        final line = content.substring(0, newlineIndex).trim();
        buffer.clear();
        buffer.write(content.substring(newlineIndex + 1));

        if (!line.startsWith('data:')) continue;
        final data = line.substring(5).trim();
        if (data == '[DONE]') {
          return;
        }

        try {
          final json = jsonDecode(data) as Map<String, dynamic>;
          final choices = json['choices'] as List?;
          if (choices == null || choices.isEmpty) continue;

          final delta = (choices.first as Map<String, dynamic>)['delta'] as Map<String, dynamic>?;
          final token = delta?['content'] as String?;
          if (token != null && token.isNotEmpty) {
            yield token;
          }
        } catch (_) {
          // Ignore malformed SSE lines.
        }
      }
    }

    // Fallback: if stream ends unexpectedly, emit nothing more.
  }

  bool _looksLikeGeminiBaseUrl(String baseUrl) {



    final b = baseUrl.toLowerCase();
    // Typical Gemini REST base: https://generativelanguage.googleapis.com
    // Some users may paste the full host.
    return b.contains('generativelanguage.googleapis.com') ||
        b.contains('googleapis.com');
  }

  @override
  Future<String> sendMessage(
    String baseUrl,
    String apiKey,
    String model,
    List<Map<String, String>> messages,
  ) async {
    try {
      if (_looksLikeGeminiBaseUrl(baseUrl)) {
        return _sendToGemini(baseUrl: baseUrl, apiKey: apiKey, model: model, messages: messages);
      }

      // Default: OpenAI-compatible chat/completions endpoint.
      return _sendToOpenAICompatible(
        baseUrl: _normalizeOpenRouterBaseUrl(baseUrl),

        apiKey: apiKey,
        model: model,
        messages: messages,
      );
    } on http.ClientException catch (e) {
      // Keep original message; upstream maps it to NetworkFailure.
      throw NetworkException(e.message);
    } on SocketException catch (e) {
      throw NetworkException('Network error: ${e.message}');
    } on AuthenticationException {
      rethrow;
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException('Unexpected error: $e');
    }
  }

  String _normalizeOpenRouterBaseUrl(String baseUrl) {
    var b = baseUrl.trim();

    // Users may accidentally save the wrong hostname: https://api.openrouter.ai/api/v1
    // Correct is: https://openrouter.ai/api/v1
    b = b.replaceAll('https://api.openrouter.ai', 'https://openrouter.ai');
    b = b.replaceAll('http://api.openrouter.ai', 'http://openrouter.ai');

    // Avoid double /api/v1 concatenation issues.
    // If user provides .../api/v1 already, keep it.
    // If they provide .../v1, normalize to .../api/v1.
    final lower = b.toLowerCase();
    if (lower.endsWith('/v1') && !lower.endsWith('/api/v1')) {
      b = '${b.substring(0, b.length - 2)}/api/v1';
    }

    return b;
  }

  Future<String> _sendToOpenAICompatible({
    required String baseUrl,


    required String apiKey,
    required String model,
    required List<Map<String, String>> messages,
  }) async {
    final url = Uri.parse('$baseUrl/chat/completions');

    final payload = {
      'model': model,
      'messages': messages,
      'temperature': 0.7,
      'max_tokens': 2000,
    };

    final response = await httpClient
        .post(
          url,
          headers: {
            'Authorization': 'Bearer $apiKey',
            'Content-Type': 'application/json',
          },
          body: jsonEncode(payload),
        )
        .timeout(const Duration(seconds: timeoutSeconds));

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;

      if (json.containsKey('choices') && (json['choices'] as List).isNotEmpty) {
        final firstChoice = (json['choices'] as List).first as Map<String, dynamic>;
        if (firstChoice.containsKey('message')) {
          final message = firstChoice['message'] as Map<String, dynamic>;
          return message['content'] as String? ?? 'No response';
        }
      }
      throw ServerException('Invalid response format from AI provider');
    }

    // Non-200: include body snippet for debuggability.
    final bodySnippet = response.body.isNotEmpty ? response.body : '(empty response)';

    if (response.statusCode == 401) {
      throw AuthenticationException('Invalid API key or unauthorized access: $bodySnippet');
    } else if (response.statusCode == 429) {
      throw ServerException('Rate limit exceeded. Please try again later: $bodySnippet');
    } else {
      throw ServerException(
        'API request failed with status ${response.statusCode}: $bodySnippet',
        statusCode: response.statusCode,
      );
    }
  }

  Future<String> _sendToGemini({
    required String baseUrl,
    required String apiKey,
    required String model,
    required List<Map<String, String>> messages,
  }) async {
    // Gemini REST API: POST
    //   {baseUrl}/v1beta/models/{model}:generateContent?key={apiKey}
    // Payload:
    //   { contents: [{ role, parts:[{text}]}], generationConfig: {...} }
    final trimmedBase = baseUrl.endsWith('/') ? baseUrl.substring(0, baseUrl.length - 1) : baseUrl;
    final url = Uri.parse('$trimmedBase/v1beta/models/$model:generateContent?key=$apiKey');

    final contents = messages.map((m) {
      final role = (m['role'] ?? '').toLowerCase();
      final geminiRole = role == 'user' ? 'user' : 'model';
      final text = m['content'] ?? '';

      return {
        'role': geminiRole,
        'parts': [
          {'text': text}
        ]
      };
    }).toList();

    final payload = {
      'contents': contents,
      'generationConfig': {
        'temperature': 0.7,
        'maxOutputTokens': 2000,
      }
    };

    final response = await httpClient
        .post(
          url,
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode(payload),
        )
        .timeout(const Duration(seconds: timeoutSeconds));

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;

      // Expected:
      // { candidates:[{ content:{ parts:[{ text: '...' }]}}] }
      final candidates = json['candidates'] as List?;
      if (candidates == null || candidates.isEmpty) {
        throw ServerException('Invalid Gemini response: missing candidates');
      }

      final content = (candidates.first as Map<String, dynamic>)['content'] as Map<String, dynamic>?;
      final parts = content?['parts'] as List?;
      if (parts == null || parts.isEmpty) {
        throw ServerException('Invalid Gemini response: missing parts');
      }

      final text = (parts.first as Map<String, dynamic>)['text'] as String?;
      return text ?? 'No response';
    }

    final bodySnippet = response.body.isNotEmpty ? response.body : '(empty response)';

    if (response.statusCode == 401) {
      throw AuthenticationException('Gemini auth failed: $bodySnippet');
    } else if (response.statusCode == 429) {
      throw ServerException('Gemini rate limit exceeded. Please try again later: $bodySnippet');
    } else {
      throw ServerException(
        'Gemini request failed with status ${response.statusCode}: $bodySnippet',
        statusCode: response.statusCode,
      );
    }
  }
}

