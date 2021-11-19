import 'dart:math';

enum ErrorPosition { start, middle, end }

/// Mocks a [Stream<List<int>>].
class MockByteStream {
  /// The byte source.
  final List<int> bytes;

  /// Max length of bytes of each response.
  final int maxLength;

  /// Minimum delay between responses.
  final Duration? minDelay;

  /// Maximum delay between responses.
  final Duration? maxDelay;

  /// If true, the resulting stream will throw an exception.
  final bool hasError;

  /// Determines where the error will be thrown.
  final ErrorPosition? errorPosition;

  final Random _random = Random();
  late final bool _hasDelay;
  late int _minDelay = 0;
  late int _maxDelay = 0;

  MockByteStream(this.bytes, this.maxLength,
      {this.minDelay,
      this.maxDelay,
      this.hasError = false,
      this.errorPosition}) {
    _hasDelay = minDelay != null || maxDelay != null;
    if (_hasDelay) {
      var delay1 = (minDelay ?? maxDelay)!.inMilliseconds;
      var delay2 = (maxDelay ?? minDelay)!.inMilliseconds;
      _minDelay = min(delay1, delay2);
      _maxDelay = max(delay1, delay2);
    }
  }

  /// Gets the resulting stream instance.
  Stream<List<int>> stream() async* {
    if (hasError && errorPosition == ErrorPosition.start) {
      _panic();
    }
    var avgCount = bytes.length / maxLength / 2;
    var i = 0;
    while (i < bytes.length) {
      if (_hasDelay) {
        await Future<void>.delayed(
            Duration(milliseconds: _randomIntRange(_minDelay, _maxDelay)));
      }

      var nextLength = _random.nextInt(maxLength) + 1;
      var end = min(bytes.length, i + nextLength);
      var data = bytes.sublist(i, end);
      yield data;

      i = end;
      if (hasError) {
        if ((errorPosition == null || errorPosition == ErrorPosition.middle) &&
            _random.nextDouble() <= 1 / avgCount) {
          _panic();
        }
        if (i == bytes.length && errorPosition == ErrorPosition.middle) {
          _panic();
        }
      }
    }

    if (hasError) {
      _panic();
    }
  }

  void _panic() {
    throw Exception('Fake error thrown by [MockByteStream]');
  }

  int _randomIntRange(int min, int max) {
    if (min == max) {
      return min;
    }
    return min + _random.nextInt(max - min);
  }
}
