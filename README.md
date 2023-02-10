# Flutter DROPDOWN INPUT

A simple dropdown input widget.

## Installation

Add `dropdown_input` as a dependency in your pubspec.yaml file ([what?](https://flutter.io/using-packages/)).
```yaml
dropdown_input: ^0.0.1
```

Import Dropdown Input:
```dart
import 'package:dropdown_input/dropdown_input.dart';
```

## Basic usage

Given a [List<Map<String, dynamic>](https://api.flutter.dev/flutter/dart-core/Map-class.html) `optionsList` and [String](https://api.flutter.dev/flutter/dart-core/String-class.html) `filterField` as parameters:

```dart
  List<Map<String, dynamic>> optionsList = [
    {
      "name": "grey",
      "id": "1"
    },
    {
      "name": "green",
      "id": "2"
    },
    {
      "name": "red",
      "id": "3"
    },
    {
      "name": "orange",
      "id": "4"
    }
  ];
```

```dart
@override
Widget build(BuildContext context) {
  return DropdownInput(
    optionsList: optionsList,
    filterField: "name",
    onItemSelected: (item) {
      print(item);
    },
  );
}
```

## Result
| ![In action](https://firebasestorage.googleapis.com/v0/b/easy-school-c3659.appspot.com/o/dropdown_input%2F1.jpg?alt=media&token=bb58910b-1c09-4ef7-8f5e-bc7470823ec9) | ![In action](https://firebasestorage.googleapis.com/v0/b/easy-school-c3659.appspot.com/o/dropdown_input%2F2.jpg?alt=media&token=22794299-c33a-446e-b235-9c80604ead5c) |
| ![In action](https://firebasestorage.googleapis.com/v0/b/easy-school-c3659.appspot.com/o/dropdown_input%2F3.jpg?alt=media&token=b56f023a-69df-4b0a-949a-55d063dbb4b7) | ![In action](https://firebasestorage.googleapis.com/v0/b/easy-school-c3659.appspot.com/o/dropdown_input%2F4.jpg?alt=media&token=4ac6677a-6deb-478f-a434-773230182122) |

