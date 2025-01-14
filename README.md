API Helper

A comprehensive Flutter package that simplifies REST API operations by providing an intuitive interface for making HTTP requests. This package streamlines common API tasks like fetching, updating, deleting, and visualizing API data, while incorporating features like authentication, retry logic, and WebSocket support.

Features

Clean and extensible API for HTTP operations.

Built-in JSON parsing, error handling, and metrics tracking.

Token-based authentication support.

Support for:

Fetching list data (GET).

Fetching data with query parameters (GET).

Updating data (PUT).

Deleting data (DELETE).

Fetching paginated data.

Visualizing API data hierarchy.

Request retry logic with exponential backoff.

Configurable timeout and dynamic environment switching.

WebSocket support for real-time data streaming.

Getting Started

Add this package to your Flutter project by adding the following to your pubspec.yaml:

dependencies:
  api_request_helper: ^0.1.4

Install the package by running:

flutter pub get

Usage

Initialize the API Helper

Initialize the ApiHelper with your base URLs for different environments:

final apiHelper = ApiHelper(
  environments: {
    'development': 'https://dev.api.example.com',
    'staging': 'https://staging.api.example.com',
    'production': 'https://api.example.com',
  },
  currentEnvironment: 'production',
);

apiHelper.setAuthToken('your-auth-token');

Fetch a List of Items

try {
  List<dynamic> users = await apiHelper.fetchAllData('/users');
  print(users);
} catch (e) {
  print('Error: $e');
}

Fetch Data with Query Parameters

try {
  final queryParams = {
    'page': '1',
    'limit': '10',
  };

  Map<String, dynamic> result = await apiHelper.fetchDataWithQuery(
    '/users',
    queryParams
  );
  print(result);
} catch (e) {
  print('Error: $e');
}

Update Data

try {
  final updates = {
    'name': 'John Doe',
    'email': 'john@example.com'
  };

  Map<String, dynamic> result = await apiHelper.editData(
    '/users/1',
    updates
  );
  print(result);
} catch (e) {
  print('Error: $e');
}

Delete Data

try {
  bool success = await apiHelper.deleteData('/users/1');
  if (success) {
    print('Successfully deleted');
  }
} catch (e) {
  print('Error: $e');
}

Fetch Paginated Data

try {
  List<dynamic> paginatedData = await apiHelper.fetchPaginatedData('/users', 10, 0);
  print(paginatedData);
} catch (e) {
  print('Error: $e');
}

Generate Hierarchy Map of API Data

try {
  String hierarchy = await apiHelper.generateHierarchyMap('/users');
  print(hierarchy);
} catch (e) {
  print('Error: $e');
}

WebSocket Support

final wsHelper = WebSocketHelper('wss://api.example.com/socket');
wsHelper.stream.listen((event) {
  print('New message: $event');
});

Additional Information

Minimum Requirements

Dart SDK: >=3.0.0 <4.0.0

Flutter: >=3.0.0

Dependencies

http: ^1.1.0

web_socket_channel: ^2.2.0

Error Handling

The package throws custom exceptions (ApiException) with detailed messages and status codes. Always wrap API calls in try-catch blocks for proper error handling.

Metrics Tracking

Track API usage and performance:

print('Total Requests: ${apiHelper._metrics.totalRequests}');
print('Average Latency: ${apiHelper._metrics.averageLatency} ms');

Issues and Feedback

Please file issues, bugs, or feature requests in our issue tracker.

Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

License

MIT License - Copyright (c) 2024 ANAS_OAMRI

