import 'dart:convert';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:list_tile_more_customizable/list_tile_more_customizable.dart';
import 'package:my_schedule/utils/auth.dart';
import 'package:my_schedule/utils/colorTheme.dart';
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
  int _currentIndex = 0;
  bool isSignIn = false;
  String userId = '';
  String nickname = '';
  String mailAddress = '';
  String avatarUrl = '';

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
      final restOperation = Amplify.API.get(
        'getUserInfo',
        queryParameters: {'userId': user.userId},
      );
      final response = await restOperation.response;
      final data = response.decodeBody();
      Map<String, dynamic> userInfo = jsonDecode(data);
      setState(() {
        isSignIn = true;
        userId = user.userId;
        nickname = userInfo['nickname'];
        mailAddress = userInfo['mailAddress'];
        avatarUrl = userInfo['avatarUrl'];
        _pages[4] = User(
            isSignedIn: true,
            nickname: nickname,
            mailAddress: mailAddress,
            avatarUrl: avatarUrl);
      });
    } on ApiException catch (e) {
      print('GET call failed: $e');
    }
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
        setState(() {
          _pages[4] = User(
            isSignedIn: value,
          );
        });
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
                  decoration: const BoxDecoration(
                      color: Colors.yellow,
                      image: DecorationImage(
                          image: NetworkImage(
                              "https://www.itying.com/images/flutter/2.png"),
                          fit: BoxFit.cover)),
                  otherAccountsPictures: [
                    Image.network(
                        "https://www.itying.com/images/flutter/4.png"),
                    Image.network(
                        "https://www.itying.com/images/flutter/5.png"),
                    Image.network("https://www.itying.com/images/flutter/6.png")
                  ],
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
          const ListTile(
              title: Text('个人中心'),
              leading: CircleAvatar(
                child: Icon(Icons.people),
              )),
          const Divider(),
          const ListTile(
            title: Text("系统设置"),
            leading: CircleAvatar(
              child: Icon(Icons.settings),
            ),
          ),
          const Divider(),
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
