import 'package:get/get.dart';

class UserInfoController extends GetxController {
  final avatarUrl =
      'https://ask.qcloudimg.com/raw/yehe-fbd3d4418/eshb6g3in5.png'.obs;
  final userId = ''.obs;
  final nickname = ''.obs;
  final mailAddress = ''.obs;
  final individualCenterPictureUrl =
      'https://ask.qcloudimg.com/raw/yehe-fbd3d4418/eshb6g3in5.png'.obs;
  final isSignIn = false.obs;
  final individualCenterPictureKey = ''.obs;
  final avatarKey = ''.obs;
  final gender = 0.obs;

  void setUserId(String userId) {
    this.userId.value = userId;
  }

  void setAvatar(String avatarUrl) {
    this.avatarUrl.value = avatarUrl;
  }

  void setNickname(String nickname) {
    this.nickname.value = nickname;
  }

  void setMailAddress(String mailAddress) {
    this.mailAddress.value = mailAddress;
  }

  void setIndividualCenterPictureUrl(String individualCenterPictureUrl) {
    this.individualCenterPictureUrl.value = individualCenterPictureUrl;
  }

  void setIsSignIn(bool isSigin) {
    this.isSignIn.value = isSigin;
  }

  void setIndividualCenterPictureKey(String individualCenterPictureKey) {
    this.individualCenterPictureKey.value = individualCenterPictureKey;
  }

  void setAvatarKey(String avatarKey) {
    this.avatarKey.value = avatarKey;
  }

  void setGender(int gender) {
    this.gender.value = gender;
  }

  void resetAll() {
    this.avatarUrl.value = '';
    this.nickname.value = '';
    this.mailAddress.value = '';
    this.individualCenterPictureUrl.value = '';
    this.isSignIn.value = false;
    this.gender.value = 0;
  }
}
