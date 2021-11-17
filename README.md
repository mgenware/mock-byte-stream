[![pub package](https://img.shields.io/pub/v/mock_byte_stream.svg)](https://pub.dev/packages/mock_byte_stream)
[![Build Status](https://github.com/mgenware/mock_byte_stream/workflows/Build/badge.svg)](https://github.com/mgenware/mock_byte_stream/actions)

Mocks a dart byte stream. Useful for simulate a network connection in unit tests.

## Features

- Mocks a standard dart byte stream `Stream<List<int>>`.
- Random byte length for each response.
- Random delays between responses.
- Can throw an exception at a random moment if configured.

## Usage

Install and import this package:

```sh
import 'package:mock_byte_stream/mock_byte_stream.dart';
```

Example:

```dart
import 'dart:convert';

import 'package:mock_byte_stream/mock_byte_stream.dart';

var bytes = ascii.encode('<DATA...>');

void main() async {
  var mbs = MockByteStream(bytes, 50,         // Each response has a size of 1-50 bytes.
      minDelay: Duration(milliseconds: 10),   // Random delays.
      maxDelay: Duration(milliseconds: 1000));

  // Use the mocked stream.
  await for (var data in mbs.stream()) {
    print(ascii.decode(data));
  }
}

```
