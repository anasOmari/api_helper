import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/web_socket_channel.dart';

// Custom exception for better error handling
class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, [this.statusCode]);

  @override
  String toString() {
    return 'ApiException: $message (Status Code: $statusCode)';
  }
}

// API Metrics for tracking usage
class ApiMetrics {
  int totalRequests = 0;
  Duration totalDuration = Duration.zero;

  void logRequest(Duration duration) {
    totalRequests++;
    totalDuration += duration;
  }

  double get averageLatency => totalRequests == 0
      ? 0
      : totalDuration.inMilliseconds / totalRequests;
}

// Main ApiHelper class
class ApiHelper {
  final Map<String, String> environments;
  final Duration timeout;
  String currentEnvironment;
  String? _authToken;
  final Map<String, String> defaultHeaders;
  final List<Function(Uri, Map<String, String>)> _interceptors = [];
  final ApiMetrics _metrics = ApiMetrics();

  ApiHelper({
    required this.environments,
    this.currentEnvironment = 'production',
    this.defaultHeaders = const {'Content-Type': 'application/json'},
    this.timeout = const Duration(seconds: 15),
  });

  // Get the current base API URL
  String get rootApi => environments[currentEnvironment] ?? '';

  // Set authentication token
  void setAuthToken(String token) {
    _authToken = token;
  }

  // Add a request interceptor
  void addInterceptor(Function(Uri, Map<String, String>) interceptor) {
    _interceptors.add(interceptor);
  }

  // Apply interceptors before making the request
  Future<void> _applyInterceptors(Uri uri, Map<String, String> headers) async {
    for (var interceptor in _interceptors) {
      await interceptor(uri, headers);
    }
  }

  // Centralized request handler with retry logic
  Future<http.Response> _makeRequest(
    Future<http.Response> Function() request, {
    int retries = 3,
    Duration backoff = const Duration(seconds: 2),
  }) async {
    for (int attempt = 1; attempt <= retries; attempt++) {
      try {
        final stopwatch = Stopwatch()..start();
        final response = await request().timeout(timeout);
        _metrics.logRequest(stopwatch.elapsed);

        if (response.statusCode >= 200 && response.statusCode < 300) {
          return response;
        } else {
          throw ApiException(
            'Request failed with status code ${response.statusCode}',
            response.statusCode,
          );
        }
      } on SocketException {
        if (attempt == retries) {
          throw ApiException('No Internet connection');
        }
        await Future.delayed(backoff * attempt);
      } on TimeoutException {
        throw ApiException('Request timed out');
      }
    }
    throw ApiException('Failed after multiple retries');
  }

  // Fetch all data
  Future<List<dynamic>> fetchAllData(String endpoint) async {
    final Uri url = Uri.parse('$rootApi$endpoint');
    await _applyInterceptors(url, defaultHeaders);
    final response = await _makeRequest(() => http.get(url, headers: defaultHeaders));
    return jsonDecode(response.body) as List<dynamic>;
  }

  // Fetch data with query parameters
  Future<Map<String, dynamic>> fetchDataWithQuery(
    String endpoint,
    Map<String, String> queryParams,
  ) async {
    final Uri url = Uri.parse('$rootApi$endpoint').replace(queryParameters: queryParams);
    await _applyInterceptors(url, defaultHeaders);
    final response = await _makeRequest(() => http.get(url, headers: defaultHeaders));
    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  // Edit data using PUT
  Future<Map<String, dynamic>> editData(
    String endpoint,
    Map<String, dynamic> data,
  ) async {
    final Uri url = Uri.parse('$rootApi$endpoint');
    await _applyInterceptors(url, defaultHeaders);
    final response = await _makeRequest(() => http.put(
          url,
          headers: defaultHeaders,
          body: jsonEncode(data),
        ));
    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  // Delete data
  Future<bool> deleteData(String endpoint) async {
    final Uri url = Uri.parse('$rootApi$endpoint');
    await _applyInterceptors(url, defaultHeaders);
    await _makeRequest(() => http.delete(url, headers: defaultHeaders));
    return true;
  }

  // Fetch paginated data
  Future<List<dynamic>> fetchPaginatedData(
    String endpoint,
    int limit,
    int offset,
  ) async {
    final Uri url = Uri.parse('$rootApi$endpoint').replace(queryParameters: {
      'limit': limit.toString(),
      'offset': offset.toString(),
    });
    await _applyInterceptors(url, defaultHeaders);
    final response = await _makeRequest(() => http.get(url, headers: defaultHeaders));
    return jsonDecode(response.body) as List<dynamic>;
  }

  // Generate hierarchy map for API response
  Future<String> generateHierarchyMap(String endpoint) async {
    final Uri url = Uri.parse('$rootApi$endpoint');
    await _applyInterceptors(url, defaultHeaders);
    final response = await _makeRequest(() => http.get(url, headers: defaultHeaders));
    final data = jsonDecode(response.body);
    return _buildHierarchy(data);
  }

  String _buildHierarchy(dynamic data, {int depth = 0}) {
    final StringBuffer buffer = StringBuffer();
    if (data is Map) {
      data.forEach((key, value) {
        buffer.writeln('${_indent(depth)}- $key');
        buffer.write(_buildHierarchy(value, depth: depth + 1));
      });
    } else if (data is List) {
      buffer.writeln('${_indent(depth)}[List of ${data.length} items]');
      if (data.isNotEmpty) {
        buffer.write(_buildHierarchy(data.first, depth: depth + 1));
      }
    } else {
      buffer.writeln('${_indent(depth)}(Value: $data)');
    }
    return buffer.toString();
  }

  String _indent(int depth) => '  ' * depth;
}

// WebSocket helper class
class WebSocketHelper {
  final WebSocketChannel channel;

  WebSocketHelper(String url) : channel = WebSocketChannel.connect(Uri.parse(url));

  Stream<dynamic> get stream => channel.stream;
}
