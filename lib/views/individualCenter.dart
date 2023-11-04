import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:getwidget/components/loader/gf_loader.dart';
import 'package:getwidget/getwidget.dart';
import 'package:list_tile_more_customizable/list_tile_more_customizable.dart';
import 'package:my_schedule/utils/api.dart';
import 'package:my_schedule/utils/colorTheme.dart';
import 'package:my_schedule/utils/storage.dart';

class IndividualCenter extends StatefulWidget {
  const IndividualCenter({super.key});

  @override
  State<IndividualCenter> createState() => _IndividualCenterState();
}

/// Signs a user up with a username, password, and email. The required
/// attributes may be different depending on your app's configuration.

class _IndividualCenterState extends State<IndividualCenter> {
  final defaultIndividualCenterPictureUrlKey =
      'default_individual_center_picture_url.png';
  final defaultAvatarUrlKey = 'default_avatar_picture.png';

  List menuTitles = ['', '头像', '昵称', '邮箱', '性别', '修改密码'];

  String? userId;
  String? nickname;
  String? mailAddress;
  String? avatarPicktureUrl = '';
  String? oldAvatarPictureKey = '';
  String? individualCenterPictureUrl = '';
  String? oldIndividualCenterPictureKey = '';

  Future<void> _getUserInfo() async {
    try {
      final user = await Amplify.Auth.getCurrentUser();
      Map<String, dynamic> userInfo = await getUserInfo(user.userId);
      var _oldIndividualCenterPictureKey = null;
      var _individualCenterPictureUrl = null;

      var _oldAvatarPictureKey = null;
      var _avatarPicktureUrl = null;
      if (userInfo['individualCenterPictureKey'] == '' ||
          userInfo['individualCenterPictureKey'] == null) {
        await getS3UrlPublic(defaultIndividualCenterPictureUrlKey)
            .then((value) {
          _individualCenterPictureUrl = value;
          _oldIndividualCenterPictureKey = defaultIndividualCenterPictureUrlKey;
        });
      } else {
        await getS3UrlPublic(userInfo['individualCenterPictureKey'])
            .then((value) {
          _individualCenterPictureUrl = value;
          _oldIndividualCenterPictureKey =
              userInfo['individualCenterPictureKey'];
        });
      }

      if (userInfo['avatarKey'] == '' || userInfo['avatarKey'] == null) {
        await getS3UrlPublic(defaultAvatarUrlKey).then((value) {
          _avatarPicktureUrl = value;
          _oldAvatarPictureKey = defaultAvatarUrlKey;
        });
      } else {
        await getS3UrlPublic(userInfo['avatarKey']).then((value) {
          _avatarPicktureUrl = value;
          _oldAvatarPictureKey = userInfo['avatarKey'];
        });
      }
      setState(() {
        nickname = userInfo['nickname'];
        mailAddress = userInfo['mailAddress'];
        individualCenterPictureUrl = _individualCenterPictureUrl;
        oldIndividualCenterPictureKey = _oldIndividualCenterPictureKey;
        avatarPicktureUrl = _avatarPicktureUrl;
        oldAvatarPictureKey = _oldAvatarPictureKey;
        userId = user.userId;
      });
    } on ApiException catch (e) {
      print('GET call failed: $e');
    }
  }

  Future<void> _updateBackgroundImg() async {
    try {
      EasyLoading.show(status: 'loading');
      final key = await uploadImage('center_image');
      if (key != '') {
        final newUrl = await getS3UrlPublic(key);
        final restOperation = Amplify.API.post('updateUserInfo',
            body: HttpPayload.json({
              'userId': userId,
              'updateColumn': 'individualCenterPictureKey',
              'value': key
            }));
        await restOperation.response;
        //从S3中删除被替换的文件
        if (oldIndividualCenterPictureKey !=
            defaultIndividualCenterPictureUrlKey) {
          await removeFile(key: oldIndividualCenterPictureKey!);
        }
        EasyLoading.showSuccess('背景更新成功', duration: const Duration(seconds: 2));
        setState(() {
          individualCenterPictureUrl = newUrl;
          //将旧的S3 key替换成新的
          oldIndividualCenterPictureKey = key;
        });
      }
      EasyLoading.dismiss();
    } catch (err) {
      EasyLoading.dismiss();
      print('update backgroud image error');
    }
  }

  Future<void> _updateAvatar() async {
    try {
      EasyLoading.show(status: 'loading');
      final key = await uploadImage('user_avatar');
      if (key != '') {
        final newUrl = await getS3UrlPublic(key);
        final restOperation = Amplify.API.post('updateUserInfo',
            body: HttpPayload.json(
                {'userId': userId, 'updateColumn': 'avatarKey', 'value': key}));
        await restOperation.response;
        //从S3中删除被替换的文件
        if (oldAvatarPictureKey != defaultAvatarUrlKey) {
          await removeFile(key: oldAvatarPictureKey!);
        }
        EasyLoading.showSuccess('头像更新成功', duration: const Duration(seconds: 2));
        setState(() {
          avatarPicktureUrl = newUrl;
          //将旧的S3 key替换成新的
          oldAvatarPictureKey = key;
        });
      }
      EasyLoading.dismiss();
    } catch (err) {
      EasyLoading.dismiss();
      print('update backgroud image error');
    }
  }

  @override
  void initState() {
    super.initState();
    _getUserInfo();
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
                  if (index == 0 && individualCenterPictureUrl != '') {
                    return InkWell(
                      child: Container(
                        height: 200,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image:
                                    NetworkImage(individualCenterPictureUrl!),
                                fit: BoxFit.fill)),
                      ),
                      onTap: () {
                        _updateBackgroundImg();
                      },
                    );
                  }
                  if (index == 0 && individualCenterPictureUrl == '') {
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
                      trailing: avatarPicktureUrl != ''
                          ? CircleAvatar(
                              backgroundImage: NetworkImage(avatarPicktureUrl!),
                            )
                          : const SizedBox(),
                      onTap: (_) {
                        _updateAvatar();
                      },
                    );
                  }

                  if (index == 2) {
                    return ListTileMoreCustomizable(
                      title: Text(menuTitles[index]),
                      trailing: Text(nickname ?? ''),
                    );
                  }

                  if (index == 3) {
                    return ListTileMoreCustomizable(
                      title: Text(menuTitles[index]),
                      trailing: Text(mailAddress ?? ''),
                    );
                  }

                  if (index == 4) {
                    return ListTileMoreCustomizable(
                      title: Text(menuTitles[index]),
                      trailing: const Text('男'),
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
