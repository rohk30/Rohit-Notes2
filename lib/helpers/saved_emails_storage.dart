import 'package:shared_preferences/shared_preferences.dart';

class SavedEmailsService {
  static const String _savedEmailsKey = 'saved_emails';

  // Get list of saved emails
  static Future<List<String>> getSavedEmails() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_savedEmailsKey) ?? [];
  }

  // Save an email to the list
  static Future<void> saveEmail(String email) async {
    if (email.isEmpty) return;

    final prefs = await SharedPreferences.getInstance();
    final savedEmails = prefs.getStringList(_savedEmailsKey) ?? [];

    // If the email already exists in the list, remove it
    savedEmails.remove(email);

    // Add the email to the beginning of the list (most recent first)
    savedEmails.insert(0, email);

    // Limit list to 5 emails to prevent it from growing too large
    if (savedEmails.length > 5) {
      savedEmails.removeLast();
    }

    await prefs.setStringList(_savedEmailsKey, savedEmails);
  }

  // Clear all saved emails
  static Future<void> clearSavedEmails() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_savedEmailsKey);
  }
}