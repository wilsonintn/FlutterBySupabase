import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// --- Data Models ---
class LanguageOption {
  final String code;
  final String name;
  final String flag;
  const LanguageOption(this.code, this.name, this.flag);
}

const List<LanguageOption> _interfaceLanguages = [
  LanguageOption('zh_TW', '繁體中文', '🇹🇼'),
  LanguageOption('zh_CN', '简体中文', '🇨🇳'),
  LanguageOption('en', 'English', '🇺🇸'),
  LanguageOption('ko', '한국어', '🇰🇷'),
  LanguageOption('ja', '日本語', '🇯🇵'),
  LanguageOption('ms', 'Bahasa Melayu', '🇲🇾'),
];

const List<LanguageOption> _qaLanguages = [
  LanguageOption('auto', '無偏好', '🌐'),
  LanguageOption('zh_TW', '繁體中文', '🇹🇼'),
  LanguageOption('zh_CN', '简体中文', '🇨🇳'),
  LanguageOption('en', 'English', '🇺🇸'),
  LanguageOption('ko', '한국어', '🇰🇷'),
  LanguageOption('ja', '日本語', '🇯🇵'),
  LanguageOption('ms', 'Bahasa Melayu', '🇲🇾'),
];


// --- UI Widget ---
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  LanguageOption _selectedInterfaceLanguage = _interfaceLanguages[0]; // Default to Traditional Chinese
  LanguageOption _selectedQaLanguage = _qaLanguages[0]; // Default to No Preference
  Map<String, dynamic>? _userProfile;
  bool _isLoadingProfile = true;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    if (!mounted) return;
    setState(() {
      _isLoadingProfile = true;
    });
    try {
      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId == null) {
        throw 'User not logged in';
      }
      final userProfile = await Supabase.instance.client
          .from('profiles')
          .select()
          .eq('uid', userId)
          .single();
      if (mounted) {
        setState(() {
          _userProfile = userProfile;
          _isLoadingProfile = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingProfile = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('無法載入使用者資訊: $e')),
        );
      }
    }
  }

  Future<void> _showLanguagePicker({
    required BuildContext context,
    required String title,
    required List<LanguageOption> languages,
    required LanguageOption currentLanguage,
    required ValueChanged<LanguageOption> onSelected,
  }) async {
    final selected = await showDialog<LanguageOption>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          backgroundColor: const Color(0xFF2E2E2E),
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
          content: SizedBox(
            width: double.minPositive,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: languages.length,
              itemBuilder: (context, index) {
                final option = languages[index];
                return RadioListTile<LanguageOption>(
                  title: Text('${option.flag} ${option.name}'),
                  value: option,
                  groupValue: currentLanguage,
                  onChanged: (LanguageOption? value) {
                    Navigator.of(context).pop(value);
                  },
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('取消'),
            ),
          ],
        );
      },
    );

    if (selected != null) {
      onSelected(selected);
    }
  }

  void _showLogoutConfirmDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: const Color(0xFF2E2E2E),
          title: const Text('確認登出'),
          content: const Text('您確定要登出嗎？'),
          actions: <Widget>[
            TextButton(
              child: const Text('取消'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              child: const Text('登出', style: TextStyle(color: Colors.red)),
              onPressed: () async {
                Navigator.of(dialogContext).pop(); // Close dialog
                
                // Adapted logout logic
                await Supabase.instance.client.auth.signOut();
                await GoogleSignIn().signOut();

                if (mounted) {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    '/login',
                    (Route<dynamic> route) => false,
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // User Info Section
          Container(
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
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('使用者資訊', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const Divider(height: 24),
                  ListTile(
                    leading: const Icon(Icons.person_outline),
                    title: const Text('用戶名稱'),
                    subtitle: Text(_isLoadingProfile ? '載入中...' : _userProfile?['name'] ?? 'N/A'),
                  ),
                  ListTile(
                    leading: const Icon(Icons.email_outlined),
                    title: const Text('Email'),
                    subtitle: Text(_isLoadingProfile ? '載入中...' : _userProfile?['email'] ?? 'N/A'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          // Language Settings Section
          Container(
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
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('語言設定', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const Divider(height: 24),
                  ListTile(
                    leading: const Icon(Icons.language_outlined),
                    title: const Text('介面語言'),
                    subtitle: Text('${_selectedInterfaceLanguage.flag} ${_selectedInterfaceLanguage.name}'),
                    trailing: const Icon(Icons.arrow_drop_down),
                    onTap: () {
                      _showLanguagePicker(
                        context: context,
                        title: '選擇介面語言',
                        languages: _interfaceLanguages,
                        currentLanguage: _selectedInterfaceLanguage,
                        onSelected: (lang) => setState(() => _selectedInterfaceLanguage = lang),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.forum_outlined),
                    title: const Text('AI 問答語言'),
                    subtitle: Text('${_selectedQaLanguage.flag} ${_selectedQaLanguage.name}'),
                    trailing: const Icon(Icons.arrow_drop_down),
                    onTap: () {
                      _showLanguagePicker(
                        context: context,
                        title: '選擇 AI 問答語言',
                        languages: _qaLanguages,
                        currentLanguage: _selectedQaLanguage,
                        onSelected: (lang) => setState(() => _selectedQaLanguage = lang),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          // Disclaimer Section
          const Text('免責聲明', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(
            '本應用程式由 AI 模型生成內容，包含筆記、摘要與待辦事項。所有生成內容僅供參考，不保證其準確性與完整性。請使用者自行核對重要資訊，開發者不對因使用本服務所造成的任何直接或間接損失負責。',
            style: TextStyle(color: Colors.white.withOpacity(0.7), height: 1.5),
          ),
          const SizedBox(height: 32),
          // Logout Button
          GestureDetector(
            onTap: () {
              _showLogoutConfirmDialog(context);
            },
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(12),
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
                child: Text(
                  '登出',
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        ],
      );
  }
}
