import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('用戶設定'),
      ),
      body: const Center(
        child: Text('這裡是使用者設定頁面'),
      ),
    );
  }
}
