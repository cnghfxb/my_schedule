import 'dart:convert';

import 'package:amplify_flutter/amplify_flutter.dart';

//获取用户信息
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

//更新的用户信息
Future<void> updateUserInfo(
    String userId, String updateColumn, dynamic value) async {
  try {
    final restOperation = Amplify.API.post('updateUserInfo',
        body: HttpPayload.json(
            {'userId': userId, 'updateColumn': updateColumn, 'value': value}));
    await restOperation.response;
  } catch (err) {
    rethrow;
  }
}

//获取新建类型
Future<List<dynamic>> getScheduleTypes() async {
  try {
    final restOperation = Amplify.API.get('getScheduleType');
    final response = await restOperation.response;
    return jsonDecode(response.decodeBody());
  } catch (err) {
    rethrow;
  }
}
