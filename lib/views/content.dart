import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:list_tile_more_customizable/list_tile_more_customizable.dart';
import 'package:my_schedule/store/userInfo.dart';
import 'package:my_schedule/utils/api/api.dart';
import 'package:my_schedule/utils/auth/auth.dart';
import 'package:my_schedule/utils/enum/default.dart';
import 'package:my_schedule/utils/enum/gender.dart';
import 'package:my_schedule/utils/theme/colorTheme.dart';
import 'package:my_schedule/utils/s3storage/storage.dart';
import 'package:my_schedule/views/Home.dart';
import 'package:my_schedule/views/Setting.dart';
import 'package:my_schedule/views/User.dart';
import 'package:my_schedule/views/addSechedule.dart';
import 'package:my_schedule/views/share.dart';
import 'package:my_schedule/views/signIn.dart';

class Content extends StatefulWidget {
  const Content({super.key});

  @override
  State<Content> createState() => _Content();
}

class _Content extends State<Content> {
  UserInfoController userInfoController =
      Get.put<UserInfoController>(UserInfoController());
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const Home(),
    const Share(),
    const AddSechedule(),
    const Setting(),
    const User()
  ];

  Future<void> _getUserInfo() async {
    try {
      final user = await Amplify.Auth.getCurrentUser();
      Map<String, dynamic> userInfo = await getUserInfo(user.userId);
      var _avatarPicktureUrl = null;
      var _individualCenterPictureUrl = null;

      if (userInfo['individualCenterPictureKey'] == '' ||
          userInfo['individualCenterPictureKey'] == null) {
        await getS3UrlPublic(Default.defaultIndividualCenterPictureUrlKey.label)
            .then((value) {
          _individualCenterPictureUrl = value;
          userInfoController.setIndividualCenterPictureKey(
              Default.defaultIndividualCenterPictureUrlKey.label);
        });
      } else {
        await getS3UrlPublic(userInfo['individualCenterPictureKey'])
            .then((value) {
          _individualCenterPictureUrl = value;
          userInfoController.setIndividualCenterPictureKey(
              userInfo['individualCenterPictureKey']);
        });
      }

      if (userInfo['avatarKey'] == '' || userInfo['avatarKey'] == null) {
        await getS3UrlPublic(Default.defaultAvatarUrlKey.label).then((value) {
          _avatarPicktureUrl = value;
          userInfoController.setAvatar(Default.defaultAvatarUrlKey.label);
        });
      } else {
        await getS3UrlPublic(userInfo['avatarKey']).then((value) {
          _avatarPicktureUrl = value;
          userInfoController.setAvatar(userInfo['avatarKey']);
        });
      }

      userInfoController.setIsSignIn(true);
      userInfoController.setAvatar(_avatarPicktureUrl);
      userInfoController.setUserId(user.userId);
      userInfoController.setNickname(userInfo['nickname']);
      userInfoController.setMailAddress(userInfo['mailAddress']);
      userInfoController.setGender(userInfo['gender'] ?? Gender.unknow.value);
      userInfoController
          .setIndividualCenterPictureUrl(_individualCenterPictureUrl);
    } on ApiException catch (e) {
      print('GET call failed: $e');
    }
  }

  Future<void> _getDefaultInfo() async {
    var _individualCenterUrl = null;

    await getS3UrlPublic(Default.defaultIndividualCenterPictureUrlKey.label)
        .then((value) {
      _individualCenterUrl = value;
    });
    userInfoController.setIndividualCenterPictureUrl(_individualCenterUrl);
  }

  Future<void> _signOutHandle() async {
    EasyLoading.show(status: 'loading...');
    await signOutCurrentUser();
    userInfoController.resetAll();
    EasyLoading.dismiss();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isUserSignedIn().then((value) {
      if (value != true) {
        _getDefaultInfo();
      } else {
        //获取当前登录用户信息
        _getUserInfo();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('日程'),
        elevation: 0,
        backgroundColor: primary,
      ),
      body: _pages[_currentIndex],
      drawer: Drawer(
          child: Obx(() => Column(
                children: [
                  userInfoController.isSignIn.value == true
                      ? UserAccountsDrawerHeader(
                          accountName: Text(userInfoController.nickname.value),
                          accountEmail:
                              Text(userInfoController.mailAddress.value),
                          currentAccountPicture: CircleAvatar(
                              backgroundImage: NetworkImage(
                                  userInfoController.avatarUrl.value)),
                          decoration: BoxDecoration(
                              color: Colors.yellow,
                              image: DecorationImage(
                                  image: NetworkImage(userInfoController
                                      .individualCenterPictureUrl.value),
                                  fit: BoxFit.cover)),
                        )
                      : const UserAccountsDrawerHeader(
                          accountName: Text(''),
                          accountEmail: Text(''),
                          decoration: BoxDecoration(
                              color: Colors.yellow,
                              image: DecorationImage(
                                  image: NetworkImage(
                                      "https://www.itying.com/images/flutter/2.png"),
                                  fit: BoxFit.cover)),
                        ),
                  if (userInfoController.isSignIn.value == true)
                    const ListTile(
                        title: Text('个人中心'),
                        leading: CircleAvatar(
                          child: Icon(Icons.people),
                        )),
                  if (userInfoController.isSignIn.value == true)
                    const Divider(),
                  if (userInfoController.isSignIn.value == true)
                    const ListTile(
                      title: Text("系统设置"),
                      leading: CircleAvatar(
                        child: Icon(Icons.settings),
                      ),
                    ),
                  if (userInfoController.isSignIn.value == true)
                    const Divider(),
                  userInfoController.isSignIn.value == true
                      ? ListTileMoreCustomizable(
                          title: const Text(
                            "退出",
                            style: TextStyle(color: red),
                          ),
                          leading: const CircleAvatar(
                            backgroundColor: red,
                            child: Icon(
                              Icons.logout,
                              color: white,
                            ),
                          ),
                          onTap: (details) async {
                            await _signOutHandle();
                            // ignore: use_build_context_synchronously
                            Navigator.pushAndRemoveUntil(context,
                                MaterialPageRoute(builder: (context) {
                              return const Content();
                            }), (route) => route == null);
                          },
                        )
                      : ListTileMoreCustomizable(
                          title: const Text(
                            "登录",
                            style: TextStyle(color: red),
                          ),
                          leading: const CircleAvatar(
                            backgroundColor: red,
                            child: Icon(
                              Icons.login,
                              color: white,
                            ),
                          ),
                          onTap: (details) {
                            Navigator.pushAndRemoveUntil(context,
                                MaterialPageRoute(builder: (context) {
                              return const SignInPage();
                            }), (route) => route == null);
                          },
                        )
                ],
              ))),
      bottomNavigationBar: BottomNavigationBar(
        fixedColor: primary, //选中的颜色
        type: BottomNavigationBarType.fixed, //如果底部有4个或者4个以上的菜单的时候 就需要配置这个参数
        currentIndex: _currentIndex, //第几个菜单被选中
        onTap: (v) {
          setState(() {
            _currentIndex = v;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '首页'),
          BottomNavigationBarItem(icon: Icon(Icons.category), label: '分类'),
          BottomNavigationBarItem(icon: Icon(Icons.category), label: '新建'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: '设置'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: '我的'),
        ],
      ),
      floatingActionButton: Container(
        height: 60,
        width: 60,
        padding: const EdgeInsets.all(4),
        margin: const EdgeInsets.only(top: 4),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(30)),
        child: FloatingActionButton(
          backgroundColor: _currentIndex == 2 ? primary : Colors.blue,
          onPressed: () {
            setState(() {
              _currentIndex = 2;
            });
          },
          child: const Icon(Icons.add),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
