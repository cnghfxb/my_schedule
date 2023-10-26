import 'dart:async';

Map<String, Timer> _funcDebounce = {};

/// 函数防抖
///
/// [func]: 要执行的方法
/// [milliseconds]: 要迟延的毫秒时间
Function debounce(Function func, [int milliseconds = 2000]) {
  target() {
    String key = func.hashCode.toString();
    Timer? timer = _funcDebounce[key];
    if (timer == null) {
      func.call();
      timer = Timer(Duration(milliseconds: milliseconds), () {
        Timer? t = _funcDebounce.remove(key);
        t?.cancel();
        t = null;
      });
      _funcDebounce[key] = timer;
    }
  }

  return target;
}
