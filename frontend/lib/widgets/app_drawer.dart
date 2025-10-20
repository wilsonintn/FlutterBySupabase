import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  Map<String, dynamic>? _profile;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _getProfile();
  }

  Future<void> _getProfile() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final userId = Supabase.instance.client.auth.currentUser!.id;
      final data = await Supabase.instance.client
          .from('profiles')
          .select()
          .eq('uid', userId)
          .single();
      setState(() {
        _profile = data;
        _isLoading = false;
      });
    } catch (e) {
      // Handle error, maybe show a snackbar
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget header;
    if (_isLoading) {
      header = const UserAccountsDrawerHeader(
        accountName: Text('Loading...'),
        accountEmail: Text(''),
        currentAccountPicture: CircleAvatar(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );
    } else if (_profile != null) {
      header = UserAccountsDrawerHeader(
        accountName: Text(_profile!['name'] ?? 'Guest'),
        accountEmail: Text(_profile!['email'] ?? ''),
        currentAccountPicture: CircleAvatar(
          backgroundImage: _profile!['photoUrl'] != null
              ? NetworkImage(_profile!['photoUrl'])
              : null,
          child: _profile!['photoUrl'] == null ? const Icon(Icons.person) : null,
        ),
      );
    } else {
      header = const UserAccountsDrawerHeader(
        accountName: Text('Guest'),
        accountEmail: Text('Could not load profile'),
        currentAccountPicture: CircleAvatar(
          child: Icon(Icons.person),
        ),
      );
    }

    return Drawer(
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                header,
                ListTile(
                  leading: const Icon(Icons.list_alt),
                  title: const Text('筆記列表'),
                  onTap: () {
                    Navigator.pop(context); // Close drawer
                    Navigator.pushReplacementNamed(context, '/home');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.question_answer),
                  title: const Text('智能 QA'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushReplacementNamed(context, '/smart_qa');
                  },
                ),
              ],
            ),
          ),
          // This ListTile is outside the ListView to stick to the bottom.
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('用戶設定'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/settings');
            },
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
