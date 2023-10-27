import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:list_tile_more_customizable/list_tile_more_customizable.dart';
import 'package:my_schedule/utils/auth.dart';
import 'package:my_schedule/utils/colorTheme.dart';
import 'package:my_schedule/views/individualCenter.dart';

class User extends StatefulWidget {
  final bool isSignedIn;
  final String? nickname;
  final String? mailAddress;
  final String? avatarUrl;
  const User(
      {super.key,
      required this.isSignedIn,
      this.nickname,
      this.mailAddress,
      this.avatarUrl});

  @override
  State<User> createState() => _UserState();
}

class _UserState extends State<User> {
  List menuTitles = ['我的消息', '我的关注', '设置'];

  List menuIcons = [Icons.message, Icons.favorite, Icons.settings];

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        itemBuilder: (context, index) {
          if (index == 0) {
            return Container(
              height: 150.0,
              color: primary,
              child: Center(
                child: widget.isSignedIn == true
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FloatingActionButton(
                            onPressed: () {},
                            child: SizedBox(
                              width: 60,
                              height: 60,
                              child: CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(widget.avatarUrl ?? '')),
                            ),
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          Text(widget.nickname ?? '')
                        ],
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                              width: 60,
                              height: 60,
                              decoration: const BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                          'assets/img/default_avatar.png')))),
                          const SizedBox(
                            height: 10.0,
                          ),
                          const Text('点击头像登录')
                        ],
                      ),
              ),
            );
          }
          index -= 1;
          return ListTileMoreCustomizable(
            leading: Icon(menuIcons[index]),
            title: Text(menuTitles[index]),
            trailing: const Icon(Icons.arrow_forward_ios),
          );
        },
        separatorBuilder: (context, index) {
          return const Divider();
        },
        itemCount: menuTitles.length + 1);
  }
}
