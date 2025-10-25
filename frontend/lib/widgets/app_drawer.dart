import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AppDrawer extends StatelessWidget {
  final void Function(int) onItemSelected;

  const AppDrawer({Key? key, required this.onItemSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;
    final userMetadata = user?.userMetadata;

    return Drawer(
      backgroundColor: const Color(0xFF2E2E2E),
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                UserAccountsDrawerHeader(
                  decoration: const BoxDecoration(
                    color: Color(0xFF242424),
                  ),
                  accountName: Text(userMetadata?['name'] ?? 'Guest'),
                  accountEmail: Text(user?.email ?? ''),
                  currentAccountPicture: CircleAvatar(
                    backgroundImage: userMetadata?['avatar_url'] != null
                        ? NetworkImage(userMetadata!['avatar_url'])
                        : null,
                    child: userMetadata?['avatar_url'] == null
                        ? const Icon(Icons.person)
                        : null,
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.list_alt),
                  title: const Text('筆記列表'),
                  onTap: () {
                    Navigator.pop(context); // Close drawer
                    onItemSelected(0); // Notify main page
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.question_answer),
                  title: const Text('智能 QA'),
                  onTap: () {
                    Navigator.pop(context);
                    onItemSelected(1); // Notify main page
                  },
                ),
              ],
            ),
          ),
          const Divider(color: Color(0xFF383838)),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('用戶設定'),
            onTap: () {
              Navigator.pop(context);
              onItemSelected(2); // Notify main page
            },
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}