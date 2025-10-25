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
    return Stack(
      children: [
        FutureBuilder<List<Map<String, dynamic>>>(
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
              padding: const EdgeInsets.all(16.0),
              itemCount: notes.length,
              itemBuilder: (context, index) {
                final note = notes[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 16.0),
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0xFF242424),
                        offset: Offset(3, 3),
                        blurRadius: 8,
                      ),
                      BoxShadow(
                        color: Color(0xFF383838),
                        offset: Offset(-3, -3),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
                    leading: const Icon(Icons.audio_file, size: 30),
                    title: Text(note['title'] ?? '無標題筆記'),
                    subtitle: Text('新增於: ${note['created_at']}'),
                    onTap: () {
                      // TODO: Implement note playback
                    },
                  ),
                );
              },
            );
          },
        ),
        Positioned(
          bottom: 32,
          right: 32,
          child: FloatingActionButton(
            onPressed: _uploadAudio,
            child: const Icon(Icons.mic),
            tooltip: '新增音訊筆記',
          ),
        ),
      ],
    );
  }
}
