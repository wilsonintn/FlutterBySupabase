import 'package:flutter/material.dart';

class SmartQAPage extends StatelessWidget {
  const SmartQAPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Color(0xFF242424),
              offset: Offset(4, 4),
              blurRadius: 10,
            ),
            BoxShadow(
              color: Color(0xFF383838),
              offset: Offset(-4, -4),
              blurRadius: 10,
            ),
          ],
        ),
        child: const Center(
          child: Text('這裡是智能 QA 頁面'),
        ),
      ),
    );
  }
}
