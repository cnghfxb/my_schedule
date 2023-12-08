import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_pickers/pickers.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:list_tile_more_customizable/list_tile_more_customizable.dart';
import 'package:my_schedule/store/userInfo.dart';
import 'package:my_schedule/utils/api/api.dart';
import 'package:my_schedule/utils/enum/default.dart';
import 'package:my_schedule/utils/enum/gender.dart';
import 'package:my_schedule/utils/theme/colorTheme.dart';
import 'package:my_schedule/utils/dialog/renameDialog.dart';
import 'package:my_schedule/utils/dialog/renameDialogContent.dart';
import 'package:my_schedule/utils/s3storage/storage.dart';

class IndividualCenter extends StatefulWidget {
  const IndividualCenter({super.key});

  @override
  State<IndividualCenter> createState() => _IndividualCenterState();
}

/// Signs a user up with a username, password, and email. The required
/// attributes may be different depending on your app's configuration.

class _IndividualCenterState extends State<IndividualCenter> {
  UserInfoController userInfoController =
      Get.put<UserInfoController>(UserInfoController());

  List menuTitles = ['', '头像', '昵称', '邮箱', '性别', '修改密码'];

  /// 昵称编辑控制器
  final TextEditingController _controllerNick = TextEditingController();

  Future<void> _updateBackgroundImg() async {
    try {
      EasyLoading.show(status: 'loading');
      final key = await uploadImage('center_image');
      if (key != '') {
        final newUrl = await getS3UrlPublic(key);
        final restOperation = Amplify.API.post('updateUserInfo',
            body: HttpPayload.json({
              'userId': userInfoController.userId.value,
              'updateColumn': 'individualCenterPictureKey',
              'value': key
            }));
        await restOperation.response;
        await updateUserInfo(
            userInfoController.userId.value, 'individualCenterPictureKey', key);
        //从S3中删除被替换的文件
        if (userInfoController.individualCenterPictureKey.value !=
            Default.defaultIndividualCenterPictureUrlKey.label) {
          await removeFile(
              key: userInfoController.individualCenterPictureKey.value!);
        }
        userInfoController.setIndividualCenterPictureUrl(newUrl);
        userInfoController.setIndividualCenterPictureKey(key);
        EasyLoading.showSuccess('背景更新成功', duration: const Duration(seconds: 2));
      }
    } catch (err) {
      print('update backgroud image error');
      EasyLoading.showError('背景更新失败', duration: const Duration(seconds: 2));
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future<void> _updateAvatar() async {
    try {
      EasyLoading.show(status: 'loading');
      final key = await uploadImage('user_avatar');
      if (key != '') {
        final newUrl = await getS3UrlPublic(key);
        await updateUserInfo(userInfoController.userId.value, 'avatarKey', key);
        //从S3中删除被替换的文件
        if (userInfoController.avatarKey.value !=
            Default.defaultAvatarUrlKey.label) {
          await removeFile(key: userInfoController.avatarKey.value);
        }
        userInfoController.setAvatar(newUrl);
        userInfoController.setAvatarKey(key);
        EasyLoading.showSuccess('头像更新成功', duration: const Duration(seconds: 2));
      }
    } catch (err) {
      print('update backgroud image error');
      EasyLoading.showError('头像更新失败', duration: const Duration(seconds: 2));
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future<void> _updateNickName() async {
    try {
      EasyLoading.show(status: 'loading');
      final _nickName = _controllerNick.text;
      await updateUserInfo(
          userInfoController.userId.value, 'nickname', _controllerNick.text);
      userInfoController.setNickname(_nickName);
      EasyLoading.showSuccess('昵称更新成功', duration: const Duration(seconds: 2));
    } catch (err) {
      print(err);
      EasyLoading.showError('昵称更新失败', duration: const Duration(seconds: 2));
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future<void> _updateGender(int gender) async {
    try {
      EasyLoading.show(status: 'loading');
      await updateUserInfo(userInfoController.userId.value, 'gender', gender);
      userInfoController.setGender(gender);
      EasyLoading.showSuccess('性别更新成功', duration: const Duration(seconds: 2));
    } catch (err) {
      print(err);
      EasyLoading.showError('性别更新失败', duration: const Duration(seconds: 2));
    } finally {
      EasyLoading.dismiss();
    }
  }

  _showUpdateNickNameDialog() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return RenameDialog(
            contentWidget: RenameDialogContent(
              title: "请输入新的昵称",
              okBtnTitle: '确定',
              cancelBtnTitle: '取消',
              okBtnTap: () async {
                await _updateNickName();
              },
              vc: _controllerNick,
              cancelBtnTap: () {},
            ),
          );
        });
  }

  _showGenderPicker(BuildContext context) {
    Pickers.showSinglePicker(context,
        data: [Gender.male.label, Gender.women.label, Gender.unknow.label],
        onConfirm: (data, _) async {
      _updateGender(Gender.getValue(data));
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('个人中心'),
          backgroundColor: primary,
          elevation: 0,
        ),
        body: SafeArea(
            child: ListView.separated(
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return InkWell(
                      child: Obx(() => Container(
                            height: 200,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: NetworkImage(userInfoController
                                        .individualCenterPictureUrl.value),
                                    fit: BoxFit.fill)),
                          )),
                      onTap: () {
                        _updateBackgroundImg();
                      },
                    );
                  }
                  if (index == 0) {
                    return const SizedBox(
                      height: 200,
                      child: Center(
                        child: GFLoader(type: GFLoaderType.ios),
                      ),
                    );
                  }
                  if (index == 1) {
                    return ListTileMoreCustomizable(
                      title: Text(menuTitles[index]),
                      trailing: Obx(() => CircleAvatar(
                            backgroundImage: NetworkImage(
                                userInfoController.avatarUrl.value),
                          )),
                      onTap: (_) {
                        _updateAvatar();
                      },
                    );
                  }

                  if (index == 2) {
                    return ListTileMoreCustomizable(
                      title: Text(menuTitles[index]),
                      trailing:
                          Obx(() => Text(userInfoController.nickname.value)),
                      onTap: (_) {
                        _showUpdateNickNameDialog();
                      },
                    );
                  }

                  if (index == 3) {
                    return ListTileMoreCustomizable(
                      title: Text(menuTitles[index]),
                      trailing: Obx(() =>
                          Text(userInfoController.mailAddress.value ?? '')),
                    );
                  }

                  if (index == 4) {
                    return ListTileMoreCustomizable(
                      title: Text(menuTitles[index]),
                      trailing: Obx(() => Text(
                          Gender.getLabel(userInfoController.gender.value))),
                      onTap: (_) {
                        _showGenderPicker(context);
                      },
                    );
                  }
                  if (index == 5) {
                    return ListTileMoreCustomizable(
                      title: Text(menuTitles[index]),
                      trailing: const Icon(Icons.arrow_forward_ios),
                    );
                  }
                },
                separatorBuilder: (context, index) {
                  return const Divider();
                },
                itemCount: menuTitles.length)));
  }
}
