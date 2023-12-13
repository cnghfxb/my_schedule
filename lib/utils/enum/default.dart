enum Default {
  defaultAvatarUrlKey(label: 'default_avatar_picture.png', value: 0),
  defaultIndividualCenterPictureUrlKey(
      label: 'default_individual_center_picture_url.png', value: 1);

  const Default({required this.label, required this.value});
  final String label;
  final int value;

  static String getLabel(int value) =>
      Default.values.firstWhere((gender) => gender.value == value).label;

  static int getValue(String label) =>
      Default.values.firstWhere((gender) => gender.label == label).value;
}
