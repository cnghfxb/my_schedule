import 'dart:async';

Map<String, bool> _funcThrottle = {};

/// 函数节流
///329017575
/// [func]: 要执行的方法
Function throttle(Future Function() func) {
  // ignore: unnecessary_null_comparison
  if (func == null) {
    return func;
  }
  target() {
    String key = func.hashCode.toString();
    bool enable = _funcThrottle[key] ?? true;
    if (enable) {
      _funcThrottle[key] = false;
      func().then((_) {
        _funcThrottle[key] = false;
      }).whenComplete(() {
        _funcThrottle.remove(key);
      });
    }
  }

  return target;
}
