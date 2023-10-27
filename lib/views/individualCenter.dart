import 'package:flutter/material.dart';
import 'package:my_schedule/utils/colorTheme.dart';

class IndividualCenter extends StatefulWidget {
  const IndividualCenter({super.key});

  @override
  State<IndividualCenter> createState() => _IndividualCenterState();
}

/// Signs a user up with a username, password, and email. The required
/// attributes may be different depending on your app's configuration.

class _IndividualCenterState extends State<IndividualCenter> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('个人中心'),
        backgroundColor: primary,
        elevation: 0,
      ),
      body: Text('个人中心'),
    );
  }
}
