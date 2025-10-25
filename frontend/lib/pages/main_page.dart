import 'package:flutter/material.dart';
import 'package:frontend/pages/notes_list_page.dart';
import 'package:frontend/pages/settings_page.dart';
import 'package:frontend/pages/smart_qa_page.dart';
import 'package:frontend/widgets/app_drawer.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  // The pages are now managed by this main shell
  static const List<Widget> _widgetOptions = <Widget>[
    NotesListPage(),
    SmartQAPage(),
    SettingsPage(),
  ];

  static const List<String> _widgetTitles = <String>[
    '我的筆記',
    '智能 QA',
    '用戶設定',
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_widgetTitles.elementAt(_selectedIndex)),
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      // Pass the callback to the drawer
      drawer: AppDrawer(onItemSelected: _onItemTapped),
      body: IndexedStack(
        index: _selectedIndex,
        children: _widgetOptions,
      ),
    );
  }
}
