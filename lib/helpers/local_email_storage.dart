import 'package:shared_preferences/shared_preferences.dart';

class EmailStorage {
  static const _key = 'saved_emails';

  // Save a new email to the list (avoid duplicates)
  static Future<void> saveEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    final emails = prefs.getStringList(_key) ?? [];
    if (!emails.contains(email)) {
      emails.add(email);
      await prefs.setStringList(_key, emails);
    }
  }

  // Retrieve list of saved emails
  static Future<List<String>> getSavedEmails() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_key) ?? [];
  }

  // Clear saved emails
  static Future<void> clearEmails() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
