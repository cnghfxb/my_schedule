import 'dart:convert';

import 'package:amplify_flutter/amplify_flutter.dart';

Future<Map<String, dynamic>> getUserInfo(String userId) async {
  final restOperation = Amplify.API.get(
    'getUserInfo',
    queryParameters: {'userId': userId},
  );
  final response = await restOperation.response;
  final data = response.decodeBody();
  Map<String, dynamic> userInfo = jsonDecode(data);
  return userInfo;
}
