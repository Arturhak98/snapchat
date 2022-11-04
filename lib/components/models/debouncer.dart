import 'dart:async';
import 'dart:ui';


class Debouncer {
 int milliseconds;
  //late Future<void> Function(String name) action;
  Timer? _timer;

  Debouncer({required this.milliseconds});

  void run(VoidCallback action) {
    if (null != _timer) {
      _timer?.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}