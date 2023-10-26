import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:flutter/material.dart';
import 'package:amplify_api/amplify_api.dart';
import 'package:my_schedule/router/router.dart';
import 'package:my_schedule/views/content.dart';
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
      showSemanticsDebugger: false,
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(primaryColor: Colors.blue),
      home: const Content(),
      initialRoute: '/',
      onGenerateRoute: onGenerateRoute,
    );
  }
}
