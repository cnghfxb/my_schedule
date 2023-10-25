import 'package:flutter/material.dart';
import 'package:my_schedule/main.dart';
import 'package:my_schedule/views/signIn.dart';
import 'package:my_schedule/views/signUp.dart';

final Map<String, Function> routes = {
  '/': (context) => const Home(),
  '/sign-in': (context) => const SignInPage(),
  '/sign-up': (context) => const SignUpPage()
};

var onGenerateRoute = (RouteSettings settings) {
  final String? name = settings.name;
  final Function? pageContentBuilder = routes[name];

  if (pageContentBuilder != null) {
    if (settings.arguments != null) {
      final Route route = MaterialPageRoute(
          builder: (context) =>
              pageContentBuilder(context, arguments: settings.arguments));
      return route;
    } else {
      final Route route =
          MaterialPageRoute(builder: (context) => pageContentBuilder(context));
      return route;
    }
  }
  return null;
};
