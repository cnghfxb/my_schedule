import 'package:flutter/material.dart';
import 'package:my_schedule/utils/auth.dart';
import 'package:my_schedule/views/signIn.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

/// Signs a user up with a username, password, and email. The required
/// attributes may be different depending on your app's configuration.

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    getIsSignedIn().then((value) {
      if (!value) {
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (context) {
          return const SignInPage();
        }), (route) => route == null);
      }
    });

    return MaterialApp(
        home: Scaffold(
            body: Center(
                child: Column(
      children: [
        const SizedBox(
          height: 100,
          child: Text('hh'),
        ),
        Row(
          children: [
            OutlinedButton(
                onPressed: () {
                  signOutCurrentUser();
                  Navigator.pushAndRemoveUntil(context,
                      MaterialPageRoute(builder: (context) {
                    return const SignInPage();
                  }), (route) => route == null);
                },
                child: const Text('登出')),
          ],
        )
      ],
    ))));
  }
}
