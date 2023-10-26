import 'dart:convert';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
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
  String username = '';
  String mailAddress = '';
  String avatarUrl = '';

  late final List<Widget> _pages = const [
    Home(),
    Share(),
    Message(),
    Setting(),
    User()
  ];

  Future<void> _getUserInfo() async {
    try {
      final user = await Amplify.Auth.getCurrentUser();
      print(user.userId);
      final restOperation = Amplify.API.get(
        'getUserInfo',
        queryParameters: {'userId': user.userId, 'username': user.username},
      );
      final response = await restOperation.response;

      final data = response.decodeBody();
      Map<String, dynamic> userInfo = jsonDecode(data);
      setState(() {
        isSignIn = true;
        userId = user.userId;
        username = user.username;
        mailAddress = userInfo['mailAddress'];
        avatarUrl = userInfo['avatarUrl'];
      });
    } on ApiException catch (e) {
      print('GET call failed: $e');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isUserSignedIn().then((value) {
      if (value != true) {
        //    Navigator.pushAndRemoveUntil(context,
        //       MaterialPageRoute(builder: (context) {
        //      return const SignInPage();
        //  }), (route) => route == null);
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
      ),
      body: _pages[_currentIndex],
      drawer: Drawer(
          child: Column(
        children: [
          isSignIn == true
              ? UserAccountsDrawerHeader(
                  accountName: Text(username),
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
                  onTap: (details) {
                    signOutCurrentUser();
                    Navigator.pushAndRemoveUntil(context,
                        MaterialPageRoute(builder: (context) {
                      return const SignInPage();
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
        fixedColor: Colors.red, //选中的颜色
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
          BottomNavigationBarItem(icon: Icon(Icons.people), label: '用户'),
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
          backgroundColor: _currentIndex == 2 ? Colors.red : Colors.blue,
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
