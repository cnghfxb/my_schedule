enum Gender {
  male(label: '男', value: 0),
  women(label: '女', value: 1),
  unknow(label: '-', value: 2);

  const Gender({required this.label, required this.value});
  final String label;
  final int value;

  static String getLabel(int value) =>
      Gender.values.firstWhere((gender) => gender.value == value).label;

  static int getValue(String label) =>
      Gender.values.firstWhere((gender) => gender.label == label).value;
}
