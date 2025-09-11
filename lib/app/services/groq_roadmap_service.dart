import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../modules/career_assistant/models/chat_message.dart';

class GroqRoadmapService {
  static const String _baseUrl = 'https://api.groq.com/openai/v1/chat/completions';
  static const String _model = 'llama3-8b-8192';
  
  static const String _systemPrompt = '''
Kamu adalah AI Career Roadmap Specialist bernama "Roadmap Assistant" yang sangat ahli dalam membuat roadmap karir yang detail dan personal.

TUGAS UTAMA:
1. JANGAN langsung membuat roadmap! Kamu HARUS bertanya dan memahami dulu kebutuhan pengguna secara mendalam
2. Tanyakan pertanyaan yang relevan untuk memahami:
   - Latar belakang pendidikan dan pengalaman saat ini
   - Minat dan passion karir
   - Target karir yang diinginkan (posisi, industri)
   - Timeframe yang diharapkan
   - Skill yang sudah dimiliki vs yang perlu dipelajari
   - Preferensi pembelajaran (online, offline, sertifikasi, dll)
   - Budget dan waktu yang tersedia untuk pengembangan

PROSES INTERAKSI:
1. Mulai dengan sapaan hangat dan tanyakan tujuan karir mereka
2. Ajukan pertanyaan follow-up yang spesifik berdasarkan jawaban mereka
3. Pastikan kamu memahami situasi mereka dengan lengkap
4. Konfirmasi pemahaman kamu sebelum membuat roadmap
5. Baru setelah yakin, buat roadmap yang detail dan personal

FORMAT ROADMAP (hanya buat setelah informasi lengkap):
- Timeline yang realistis (3-6-12 bulan)
- Skill yang harus dipelajari (prioritas)
- Sumber pembelajaran yang direkomendasikan
- Sertifikasi yang relevan
- Project atau portfolio yang perlu dibuat
- Milestone dan target pencapaian
- Tips networking dan job hunting

GAYA KOMUNIKASI:
- Ramah, supportif, dan encouraging
- Ajukan pertanyaan yang thoughtful
- Berikan insight berdasarkan tren industri Indonesia
- Gunakan bahasa Indonesia yang natural
- Jangan terburu-buru, pastikan pemahaman yang mendalam

Ingat: Kualitas roadmap tergantung pada seberapa baik kamu memahami kebutuhan pengguna!
''';

  static String? get _apiKey => dotenv.env['GROQ_API_KEY'];

  static Future<String> sendMessage(List<ChatMessage> messages) async {
    if (_apiKey == null || _apiKey!.isEmpty) {
      throw Exception('GROQ_API_KEY tidak ditemukan. Pastikan sudah mengatur API key di file .env');
    }

    try {
      final List<Map<String, String>> formattedMessages = [
        {'role': 'system', 'content': _systemPrompt},
        ...messages.map((msg) => msg.toGroqMessage()).cast<Map<String, String>>(),
      ];

      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'model': _model,
          'messages': formattedMessages,
          'max_tokens': 1000,
          'temperature': 0.7,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'];
      } else {
        throw Exception('Gagal menghubungi AI: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
