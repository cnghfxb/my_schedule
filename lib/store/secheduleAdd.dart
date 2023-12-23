import 'package:get/get.dart';

class ScheduleAddController extends GetxController {
  final typeOptions = [].obs;

  void setTypeOptions(List<Map<String, dynamic>> options) {
    this.typeOptions.value = options;
  }
}
