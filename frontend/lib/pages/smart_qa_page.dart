import 'package:flutter/material.dart';

class SmartQAPage extends StatelessWidget {
  const SmartQAPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('智能 QA'),
      ),
      body: const Center(
        child: Text('這裡是智能 QA 頁面'),
      ),
    );
  }
}
