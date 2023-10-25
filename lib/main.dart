import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:flutter/material.dart';
import 'package:amplify_api/amplify_api.dart';
import 'package:my_schedule/models/Todo.dart';
import 'package:my_schedule/router/router.dart';
import 'package:my_schedule/utils/auth.dart';
import 'package:my_schedule/views/signIn.dart';
import 'package:my_schedule/views/signUp.dart';
import 'amplifyconfiguration.dart';

void main() async {
  runApp(const MyApp());
  configureAmplify();
}

Future<void> configureAmplify() async {
  // Add the following line to add API plugin to your app.
  // Auth plugin needed for IAM authorization mode, which is default for REST API.
  final auth = AmplifyAuthCognito();
  final api = AmplifyAPI();
  await Amplify.addPlugins([api, auth]);
  try {
    await Amplify.configure(amplifyconfig);
  } on AmplifyAlreadyConfiguredException {
    safePrint(
        'Tried to reconfigure Amplify; this can occur when your app restarts on Android.');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(primaryColor: Colors.blue),
      home: const Home(),
      initialRoute: '/',
      onGenerateRoute: onGenerateRoute,
    );
  }
}

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

  //Rest api test
  Future<void> postTodo() async {
    try {
      final restOperation = Amplify.API.get('sayHello');
      final response = await restOperation.response;
      print('GET call succeeded');
      print(response.decodeBody());
    } on ApiException catch (e) {
      print('GET call failed: $e');
    }
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
