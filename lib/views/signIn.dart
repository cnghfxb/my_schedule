import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:my_schedule/utils/auth/auth.dart';
import 'package:my_schedule/utils/theme/colorTheme.dart';
import 'package:getwidget/getwidget.dart';
import 'package:my_schedule/utils/common/throttle.dart';
import 'package:my_schedule/views/content.dart';
import 'package:my_schedule/views/signUp.dart';

/// 注册界面
class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  /// 账号编辑控制器
  final TextEditingController _controllerUserName = TextEditingController();

  /// 密码编辑控制器
  final TextEditingController _controllerPassword = TextEditingController();

  /// 是否隐藏密码
  bool isShowPassword = false;

  void goHomePage(BuildContext context) {
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) {
      return const Content();
    }), (route) => route == null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: getBody(),
      resizeToAvoidBottomInset: false,
    );
  }

  Future<void> doSignIn() async {
    try {
      //signOutCurrentUser();
      String username = _controllerUserName.text;
      String password = _controllerPassword.text;
      if (username == '' || password == '') {
        await GFToast.showToast(
          '邮箱地址和密码不能为空',
          context,
        );
        return;
      }
      EasyLoading.show(
          status: 'loading...', maskType: EasyLoadingMaskType.black);
      await signOutCurrentUser();
      await signInUser(username, password);
      EasyLoading.dismiss();
      // ignore: use_build_context_synchronously
      goHomePage(context);
    } catch (err) {
      EasyLoading.dismiss();
      EasyLoading.showError("登录失败，请检查邮箱地址和密码");
      rethrow;
    }
  }

  ///
  Widget getBody() {
    return SafeArea(
        child: Padding(
      padding: const EdgeInsets.all(30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(
            height: 30,
          ),
          const Text(
            "来了，老弟！",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          Container(
            width: 140,
            height: 5,
            decoration: const BoxDecoration(color: primary),
          ),
          const SizedBox(
            height: 40,
          ),
          TextField(
            cursorColor: primary,
            controller: _controllerUserName,
            decoration: const InputDecoration(
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: primary)),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: primary)),
                hintText: "请输入邮箱地址",
                hintStyle: TextStyle(fontSize: 14)),
          ),
          const SizedBox(
            height: 30,
          ),
          TextField(
            obscureText: !isShowPassword,
            cursorColor: primary,
            controller: _controllerPassword,
            decoration: const InputDecoration(
              hintStyle: TextStyle(fontSize: 14),
              hintText: "请输入密码",
              enabledBorder:
                  UnderlineInputBorder(borderSide: BorderSide(color: primary)),
              focusedBorder:
                  UnderlineInputBorder(borderSide: BorderSide(color: primary)),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Flex(
            direction: Axis.horizontal,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                  onPressed: () {},
                  child: const Text(
                    '忘记密码？',
                    style: TextStyle(color: link),
                  )),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (BuildContext content) {
                      return const SignUpPage();
                    }));
                  },
                  child: const Text(
                    '立即注册',
                    style: TextStyle(color: link),
                  )),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: GFButton(
                  onPressed: () {
                    throttle(doSignIn)();
                  },
                  text: "登录",
                  shape: GFButtonShape.square,
                  color: primary,
                  textColor: white,
                ),
              )
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Center(
            child: TextButton(
              onPressed: () {
                goHomePage(context);
              },
              child: const Text(
                '游客登录',
                style: TextStyle(color: link),
              ),
            ),
          )
        ],
      ),
    ));
  }
}
