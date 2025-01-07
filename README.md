# API Helper

A lightweight Flutter package that provides a clean and simple way to handle REST API calls. This package wraps the `http` package to provide easy-to-use methods for common API operations like fetching, updating, and deleting data.

## Features

- Simplified REST API operations:
  - Fetch all data (GET)
  - Fetch data with query parameters (GET)
  - Edit data (PUT)
  - Delete data (DELETE)
- Automatic JSON parsing and error handling
- Support for query parameters
- Clean and simple API interface

## Getting started

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  api_helper: ^1.0.0
```

This package depends on the `http` package, which will be automatically installed.

## Usage

First, initialize the ApiHelper with your root API URL:

```dart
final apiHelper = ApiHelper(rootApi: 'https://api.example.com');
```

### Fetch all data
```dart
try {
  List<dynamic> data = await apiHelper.fetchAllData('/users');
  print(data);
} catch (e) {
  print('Error: $e');
}
```

### Fetch data with query parameters
```dart
try {
  Map<String, String> queryParams = {
    'page': '1',
    'limit': '10'
  };
  
  Map<String, dynamic> response = await apiHelper.fetchDataWithQuery(
    '/users',
    queryParams
  );
  print(response);
} catch (e) {
  print('Error: $e');
}
```

### Edit data
```dart
try {
  Map<String, dynamic> updateData = {
    'name': 'John Doe',
    'email': 'john@example.com'
  };
  
  Map<String, dynamic> response = await apiHelper.editData(
    '/users/1',
    updateData
  );
  print(response);
} catch (e) {
  print('Error: $e');
}
```

### Delete data
```dart
try {
  bool success = await apiHelper.deleteData('/users/1');
  if (success) {
    print('User deleted successfully');
  }
} catch (e) {
  print('Error: $e');
}
```

## Error Handling

All methods will throw an Exception with a status code if the API request fails. Make sure to wrap your API calls in try-catch blocks for proper error handling.

## Additional information

### Dependencies
- http: ^1.1.0

### Contributing
Feel free to file issues and submit pull requests on the GitHub repository.

### License
This project is licensed under the MIT License - see the LICENSE file for details.
