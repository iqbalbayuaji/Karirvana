import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../modules/career_assistant/models/chat_message.dart';

class GroqService {
  static const String _baseUrl = 'https://api.groq.com/openai/v1/chat/completions';
  static const String _model = 'llama-3.1-8b-instant';
  
  static String get _apiKey {
    final key = dotenv.env['GROQ_API_KEY'];
    if (key == null || key.isEmpty) {
      throw Exception('GROQ_API_KEY not found in .env file');
    }
    return key;
  }

  static const String _systemPrompt = '''
Kamu adalah asisten karir AI yang sangat membantu dan berpengetahuan luas bernama "Career Assistant". 
Kamu akan membantu pengguna dalam berbagai aspek karir mereka dalam bahasa Indonesia.

Keahlianmu meliputi:
- Panduan pengembangan karir
- Review dan perbaikan CV/Resume
- Tips wawancara kerja
- Penilaian skill dan kompetensi
- Strategi negosiasi gaji
- Panduan transisi karir
- Rekomendasi pelatihan dan sertifikasi
- Networking dan personal branding

Selalu berikan jawaban yang:
- Praktis dan dapat diterapkan
- Disesuaikan dengan konteks Indonesia
- Ramah dan mendukung
- Berdasarkan best practices terkini
- Menggunakan bahasa Indonesia yang baik dan benar

Jika pengguna bertanya di luar topik karir, arahkan kembali ke topik karir dengan sopan.
''';

  static Future<String> sendMessage(List<ChatMessage> messages) async {
    try {
      // Prepare messages for API
      List<Map<String, dynamic>> apiMessages = [
        {'role': 'system', 'content': _systemPrompt}
      ];
      
      // Add conversation history
      for (var message in messages) {
        apiMessages.add(message.toGroqMessage());
      }

      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'model': _model,
          'messages': apiMessages,
          'max_tokens': 1000,
          'temperature': 0.7,
          'stream': false,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final content = data['choices'][0]['message']['content'];
        return content ?? 'Maaf, saya tidak dapat memberikan respons saat ini.';
      } else {
        print('Groq API Error: ${response.statusCode} - ${response.body}');
        return 'Maaf, terjadi kesalahan saat menghubungi server. Silakan coba lagi.';
      }
    } catch (e) {
      print('Groq Service Error: $e');
      return 'Maaf, terjadi kesalahan. Pastikan koneksi internet Anda stabil dan coba lagi.';
    }
  }

  static Future<bool> testConnection() async {
    try {
      final testMessages = [
        ChatMessage.user('Halo')
      ];
      
      final response = await sendMessage(testMessages);
      return response.isNotEmpty && !response.contains('kesalahan');
    } catch (e) {
      return false;
    }
  }
}
