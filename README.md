# API Helper

A lightweight Flutter package that simplifies REST API operations by providing a clean, intuitive interface for making HTTP requests. This package streamlines common API tasks like fetching, updating, and deleting data while handling JSON parsing and error management.

## Features

- Simple and clean API for HTTP operations
- Built-in JSON parsing and error handling
- Support for:
    - Fetching list data (GET)
    - Fetching data with query parameters (GET)
    - Updating data (PUT)
    - Deleting data (DELETE)
- Automatic status code handling
- Query parameter support

## Getting started

Add this package to your Flutter project by adding the following to your `pubspec.yaml`:

```yaml
dependencies:
  api_request_helper: ^0.1.3
```

Install the package by running:
```bash
flutter pub get
```

## Usage

Initialize the API Helper with your base URL:

```dart
final apiHelper = ApiHelper(rootApi: 'https://api.example.com');
```

### Fetch a list of items
```dart
try {
  List<dynamic> users = await apiHelper.fetchAllData('/users');
  print(users);
} catch (e) {
  print('Error: $e');
}
```

### Fetch with query parameters
```dart
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
```

### Update data
```dart
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
```

### Delete data
```dart
try {
  bool success = await apiHelper.deleteData('/users/1');
  if (success) {
    print('Successfully deleted');
  }
} catch (e) {
  print('Error: $e');
}
```

## Additional information

### Minimum Requirements
- Dart SDK: >=3.0.0 <4.0.0
- Flutter: >=3.0.0

### Dependencies
- http: ^1.1.0

### Error Handling
The package throws exceptions with status codes when requests fail. Always wrap API calls in try-catch blocks for proper error handling.

### Issues and Feedback
Please file issues, bugs, or feature requests in our [issue tracker](link-to-your-repository-issues).

### Contributing
Contributions are welcome! Please feel free to submit a Pull Request.

### License
```
MIT License - Copyright (c) 2024 YOUR_NAME
```