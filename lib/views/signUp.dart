import 'dart:async';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:my_schedule/utils/auth/auth.dart';
import 'package:my_schedule/utils/common/throttle.dart';
import 'package:my_schedule/utils/enum/gender.dart';
import 'package:my_schedule/utils/theme/colorTheme.dart';
import 'package:getwidget/getwidget.dart';
import 'package:my_schedule/views/signIn.dart';

/// 注册界面
class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  /// 邮箱编辑控制器
  final TextEditingController _controllerEmail = TextEditingController();

  /// 密码编辑控制器
  final TextEditingController _controllerPassword = TextEditingController();

  /// 确认密码编辑控制器
  final TextEditingController _controllerConfirmPassword =
      TextEditingController();

  /// 验证码编辑控制器
  final TextEditingController _controllerCode = TextEditingController();

  /// 昵称编辑控制器
  final TextEditingController _controllerNickname = TextEditingController();

  /// 是否隐藏密码
  bool isShowPassword = false;

  bool sendCodeBtn = false; //判断发送验证码按钮是否点击过标志

  late Timer _timer;

  final defaultTimeCout = 10;
  int _timeCount = 10;

  late String userId;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: getBody(),
      resizeToAvoidBottomInset: false,
    );
  }

  //倒计时
  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      setState(() {
        if (_timeCount <= 0) {
          _timer.cancel();
          _timeCount = defaultTimeCout;
          sendCodeBtn = false;
        } else {
          _timeCount -= 1;
        }
      });
    });
  }

  bool valueCheck(String type) {
    var result = false;

    if (_controllerNickname.text == '') {
      GFToast.showToast(
        '请输入昵称',
        context,
      );
      result = true;
    }
    if (_controllerPassword.text == '') {
      GFToast.showToast(
        '请输入密码',
        context,
      );
      result = true;
    }
    if (_controllerEmail.text == '') {
      GFToast.showToast(
        '请输入邮箱',
        context,
      );
      result = true;
    }

    if (type == 'regist' && _controllerCode.text == '') {
      GFToast.showToast(
        '请输入验证码',
        context,
      );
      result = true;
    }
    if (_controllerConfirmPassword.text != _controllerPassword.text) {
      GFToast.showToast(
        '两次密码输入不一致',
        context,
      );
      result = true;
    }
    return result;
  }

  //重新发送验证码
  Future<void> sendCode() async {
    if (valueCheck('code') == false) {
      try {
        setState(() {
          sendCodeBtn = true;
        });
        _startTimer();
        EasyLoading.show(
            status: "Loading", maskType: EasyLoadingMaskType.black);
        await deleteUser();
        final result = await signUpUser(
            username: _controllerEmail.text,
            password: _controllerPassword.text,
            email: _controllerEmail.text,
            nickname: _controllerNickname.text);
        EasyLoading.dismiss();
        EasyLoading.showInfo("验证码已通过邮件发送，请注意查收。");
        userId = result;
      } catch (err) {
        print(err);
      }
    }
  }

  Future<void> submit() async {
    if (valueCheck('regist') == false) {
      try {
        EasyLoading.show(status: 'loading');
        final restOperation = Amplify.API.post('addRegistedUser',
            body: HttpPayload.json({
              'userId': userId,
              'nickname': _controllerNickname.text,
              'mailAddress': _controllerEmail.text,
              'gender': Gender.unknow.value
            }));
        await restOperation.response;

        await confirmUser(
            username: _controllerEmail.text,
            confirmationCode: _controllerCode.text);
        EasyLoading.dismiss();
        EasyLoading.showSuccess("注册成功");
        // ignore: use_build_context_synchronously
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (context) {
          return const SignInPage();
          // ignore: unnecessary_null_comparison
        }), (route) => route == null);
      } catch (err) {
        print(err);
        EasyLoading.showError("注册失败");
      }
    }
  }

  ///
  Widget getBody() {
    return SafeArea(
        child: SingleChildScrollView(
            child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Padding(
              padding: EdgeInsets.only(left: 15, top: 20),
              child: Icon(Icons.arrow_back_ios),
            )),
        Padding(
          padding: const EdgeInsets.only(left: 30, right: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(
                height: 20,
              ),
              const Text(
                "注册",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
              Container(
                width: 45,
                height: 5,
                decoration: const BoxDecoration(color: primary),
              ),
              const SizedBox(
                height: 40,
              ),
              TextField(
                cursorColor: primary,
                controller: _controllerNickname,
                decoration: const InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: primary)),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: primary)),
                    hintText: "请输入昵称",
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
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: primary)),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: primary)),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              TextField(
                obscureText: !isShowPassword,
                cursorColor: primary,
                controller: _controllerConfirmPassword,
                decoration: const InputDecoration(
                  hintStyle: TextStyle(fontSize: 14),
                  hintText: "确认密码",
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: primary)),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: primary)),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              TextField(
                cursorColor: primary,
                controller: _controllerEmail,
                decoration: const InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: primary)),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: primary)),
                    hintText: "请输入你的邮箱",
                    hintStyle: TextStyle(fontSize: 14)),
              ),
              const SizedBox(
                height: 30,
              ),
              Flex(
                  direction: Axis.horizontal,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                        flex: 3,
                        child: TextField(
                          cursorColor: primary,
                          controller: _controllerCode,
                          decoration: const InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: primary)),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: primary)),
                              hintText: "请输入验证码",
                              hintStyle: TextStyle(fontSize: 14)),
                        )),
                    Expanded(
                        flex: 2,
                        child: Container(
                          margin: EdgeInsets.only(left: 20),
                          child: sendCodeBtn
                              ? GFButton(
                                  onPressed: () {},
                                  text: '$_timeCount秒后重发',
                                  shape: GFButtonShape.square,
                                  color: grey,
                                  textColor: white,
                                )
                              : GFButton(
                                  onPressed: () {
                                    throttle(sendCode)();
                                  },
                                  text: "发送验证码",
                                  shape: GFButtonShape.square,
                                  color: primary,
                                  textColor: white,
                                ),
                        ))
                  ]),
              const SizedBox(
                height: 40,
              ),
              Row(
                children: <Widget>[
                  Expanded(
                      child: GFButton(
                    onPressed: () {
                      throttle(submit)();
                    },
                    text: "提交",
                    shape: GFButtonShape.square,
                    color: primary,
                    textColor: white,
                  ))
                ],
              ),
            ],
          ),
        )
      ],
    )));
  }
}
