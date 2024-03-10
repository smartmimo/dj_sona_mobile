import 'dart:async';

class Debounce {
  final Duration delay;
  Timer? _timer;

  Debounce({
    this.delay = const Duration(milliseconds: 300),
  });

  call(void Function() callback) {
    _timer?.cancel();
    _timer = Timer(delay, callback);
  }

  dispose() {
    _timer?.cancel();
  }
}
