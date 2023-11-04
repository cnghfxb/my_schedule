import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:list_tile_more_customizable/list_tile_more_customizable.dart';
import 'package:my_schedule/utils/api/api.dart';
import 'package:my_schedule/utils/auth/auth.dart';
import 'package:my_schedule/utils/theme/colorTheme.dart';
import 'package:my_schedule/utils/s3storage/storage.dart';
import 'package:my_schedule/views/Home.dart';
import 'package:my_schedule/views/Setting.dart';
import 'package:my_schedule/views/User.dart';
import 'package:my_schedule/views/message.dart';
import 'package:my_schedule/views/share.dart';
import 'package:my_schedule/views/signIn.dart';

class Content extends StatefulWidget {
  const Content({super.key});

  @override
  State<Content> createState() => _Content();
}

class _Content extends State<Content> {
  final defaultAvatarUrlKey = 'default_avatar_picture.png';
  final defaultIndividualCenterPictureUrlKey =
      'default_individual_center_picture_url.png';

  int _currentIndex = 0;
  bool isSignIn = false;
  String userId = '';
  String nickname = '';
  String mailAddress = '';
  String avatarUrl = '';
  String individualCenterPictureUrl = '';

  final List<Widget> _pages = [
    const Home(),
    const Share(),
    const Message(),
    const Setting(),
    const User(isSignedIn: false)
  ];

  Future<void> _getUserInfo() async {
    try {
      final user = await Amplify.Auth.getCurrentUser();
      Map<String, dynamic> userInfo = await getUserInfo(user.userId);
      var _avatarPicktureUrl = null;
      var _individualCenterPictureUrl = null;

      if (userInfo['individualCenterPictureKey'] == '' ||
          userInfo['individualCenterPictureKey'] == null) {
        await getS3UrlPublic(defaultIndividualCenterPictureUrlKey)
            .then((value) {
          _individualCenterPictureUrl = value;
        });
      } else {
        await getS3UrlPublic(userInfo['individualCenterPictureKey'])
            .then((value) {
          _individualCenterPictureUrl = value;
        });
      }

      if (userInfo['avatarKey'] == '' || userInfo['avatarKey'] == null) {
        await getS3UrlPublic(defaultAvatarUrlKey).then((value) {
          _avatarPicktureUrl = value;
        });
      } else {
        await getS3UrlPublic(userInfo['avatarKey']).then((value) {
          _avatarPicktureUrl = value;
        });
      }
      setState(() {
        isSignIn = true;
        userId = user.userId;
        nickname = userInfo['nickname'];
        mailAddress = userInfo['mailAddress'];
        avatarUrl = _avatarPicktureUrl;
        individualCenterPictureUrl = _individualCenterPictureUrl;
        _pages[4] = User(
            isSignedIn: true,
            nickname: nickname,
            mailAddress: mailAddress,
            avatarUrl: avatarUrl,
            individualCenterUrl: _individualCenterPictureUrl);
      });
    } on ApiException catch (e) {
      print('GET call failed: $e');
    }
  }

  Future<void> _getDefaultInfo() async {
    var _individualCenterUrl = null;

    await getS3UrlPublic(defaultIndividualCenterPictureUrlKey).then((value) {
      _individualCenterUrl = value;
    });

    setState(() {
      _pages[4] = User(
        isSignedIn: false,
        individualCenterUrl: _individualCenterUrl,
      );
    });
  }

  Future<void> _signOutHandle() async {
    EasyLoading.show(status: 'loading...');
    await signOutCurrentUser();
    setState(() {
      isSignIn = false;
      userId = '';
      nickname = '';
      mailAddress = '';
      avatarUrl = '';
    });
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
          child: Column(
        children: [
          isSignIn == true
              ? UserAccountsDrawerHeader(
                  accountName: Text(nickname),
                  accountEmail: Text(mailAddress),
                  currentAccountPicture:
                      CircleAvatar(backgroundImage: NetworkImage(avatarUrl)),
                  decoration: BoxDecoration(
                      color: Colors.yellow,
                      image: DecorationImage(
                          image: NetworkImage(individualCenterPictureUrl),
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
          if (isSignIn == true)
            const ListTile(
                title: Text('个人中心'),
                leading: CircleAvatar(
                  child: Icon(Icons.people),
                )),
          if (isSignIn == true) const Divider(),
          if (isSignIn == true)
            const ListTile(
              title: Text("系统设置"),
              leading: CircleAvatar(
                child: Icon(Icons.settings),
              ),
            ),
          if (isSignIn == true) const Divider(),
          isSignIn == true
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
      )),
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
          BottomNavigationBarItem(icon: Icon(Icons.category), label: '消息'),
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
