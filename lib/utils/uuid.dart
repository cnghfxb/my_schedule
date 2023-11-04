import 'package:uuid/uuid.dart';

getUUid() {
  var uuid = Uuid();
  return uuid.v4();
}
