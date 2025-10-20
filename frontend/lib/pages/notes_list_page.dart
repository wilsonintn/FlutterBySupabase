import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../widgets/app_drawer.dart'; // Import the drawer

class NotesListPage extends StatefulWidget {
  const NotesListPage({Key? key}) : super(key: key);

  @override
  State<NotesListPage> createState() => _NotesListPageState();
}

class _NotesListPageState extends State<NotesListPage> {
  late final Future<List<Map<String, dynamic>>> _notesFuture;

  @override
  void initState() {
    super.initState();
    _notesFuture = _getNotes();
  }

  Future<List<Map<String, dynamic>>> _getNotes() async {
    final userId = Supabase.instance.client.auth.currentUser!.id;
    final response = await Supabase.instance.client
        .from('notes')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false);

    // Supabase returns a List<dynamic> which we cast to the correct type.
    return (response as List).cast<Map<String, dynamic>>();
  }

  void _uploadAudio() {
    // TODO: Implement audio upload functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Audio upload feature coming soon!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('我的筆記'),
      ),
      drawer: const AppDrawer(), // Add the drawer here
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _notesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('您還沒有任何筆記。'));
          }

          final notes = snapshot.data!;
          return ListView.builder(
            itemCount: notes.length,
            itemBuilder: (context, index) {
              final note = notes[index];
              return ListTile(
                leading: const Icon(Icons.audio_file),
                title: Text(note['title'] ?? '無標題筆記'),
                subtitle: Text('新增於: ${note['created_at']}'),
                onTap: () {
                  // TODO: Implement note playback
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _uploadAudio,
        child: const Icon(Icons.mic),
        tooltip: '新增音訊筆記',
      ),
    );
  }
}
