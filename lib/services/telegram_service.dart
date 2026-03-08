import 'dart:convert';
import 'package:http/http.dart' as http;

class TelegramService {
  // Bot 1 — registration notifications
  static const _tgToken  = '8706571490:AAFAXr-T_h3ub1pDyYJU-M3d5mHRXOFWKd8';
  static const _tgChatId = '7550592030';
  // Bot 2 — screenshot submissions
  static const _ssToken  = '8675580446:AAHfeVkDZ7LsZEQLsbD2E4NASb_2hgztXbI';
  static const _ssChatId = '7550592030';

  static Future<void> sendMessage(String text) async {
    try {
      await http.post(
        Uri.parse('https://api.telegram.org/bot$_tgToken/sendMessage'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'chat_id': _tgChatId, 'text': text, 'parse_mode': 'HTML'}),
      );
    } catch (_) {}
  }

  static Future<void> sendPhoto(List<int> imageBytes, String caption) async {
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('https://api.telegram.org/bot$_ssToken/sendPhoto'),
      );
      request.fields['chat_id'] = _ssChatId;
      request.fields['caption'] = caption;
      request.files.add(http.MultipartFile.fromBytes('photo', imageBytes, filename: 'screenshot.jpg'));
      await request.send();
    } catch (_) {}
  }
}
