import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class InterviewGroqService {
  static const String _baseUrl = 'https://api.groq.com/openai/v1/chat/completions';
  static const String _model = 'llama-3.1-8b-instant';
  
  static String get _apiKey => dotenv.env['GROQ_API_KEY'] ?? '';

  static String _buildSystemPrompt({
    required String difficulty,
    required String style,
    String? additionalPrompt,
  }) {
    String basePrompt = '''Anda adalah seorang pewawancara HR profesional yang berpengalaman. Tugas Anda adalah melakukan wawancara kerja dalam bahasa Indonesia dengan kandidat.

INSTRUKSI PENTING:
- Berikan pertanyaan yang relevan dan menantang sesuai tingkat kesulitan: $difficulty
- Gunakan gaya wawancara: $style
- Berikan feedback profesional
- Ajukan pertanyaan follow-up berdasarkan jawaban kandidat
- Fokus pada kompetensi, pengalaman, dan kesesuaian kandidat
- Gunakan bahasa Indonesia yang formal namun ramah
- Tidak boleh menjawab lebih dari 1 kalimat
- Jangan terlalu panjang dalam merespons, maksimal 1 kalimat per pertanyaan

AKHIRI INTERVIEW:
- Jika sudah menanyakan 5-7 pertanyaan yang cukup komprehensif, akhiri interview
- Untuk mengakhiri interview, awali respons Anda dengan "[END_INTERVIEW]"
- Contoh: "[END_INTERVIEW] Terima kasih atas waktu Anda. Berdasarkan diskusi kita, Anda menunjukkan potensi yang baik untuk posisi ini."
- Berikan kesimpulan singkat dan profesional saat mengakhiri''';

    if (additionalPrompt != null && additionalPrompt.isNotEmpty) {
      basePrompt += '\n\nINSTRUKSI TAMBAHAN: $additionalPrompt';
    }

    return basePrompt;
  }

  static Future<String> generateResponse({
    required List<Map<String, String>> conversationHistory,
    required String difficulty,
    required String style,
    String? additionalPrompt,
  }) async {
    try {
      if (_apiKey.isEmpty) {
        throw Exception('GROQ_API_KEY tidak ditemukan dalam file .env');
      }

      // Build system prompt
      String systemPrompt = _buildSystemPrompt(
        difficulty: difficulty,
        style: style,
        additionalPrompt: additionalPrompt,
      );

      // Prepare messages for API
      List<Map<String, String>> messages = [
        {'role': 'system', 'content': systemPrompt},
        ...conversationHistory,
      ];

      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'model': _model,
          'messages': messages,
          'temperature': 0.7,
          'max_tokens': 500,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final content = data['choices'][0]['message']['content'];
        return content?.toString() ?? 'Maaf, saya tidak dapat memberikan respons saat ini.';
      } else {
        print('Groq API Error: ${response.statusCode} - ${response.body}');
        throw Exception('Gagal mendapatkan respons dari AI: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in InterviewGroqService: $e');
      if (e.toString().contains('GROQ_API_KEY')) {
        rethrow;
      }
      return 'Maaf, terjadi kesalahan dalam sistem. Silakan coba lagi.';
    }
  }

  static Future<String> startInterview({
    required String difficulty,
    required String style,
    String? additionalPrompt,
  }) async {
    try {
      // Generate opening question
      return await generateResponse(
        conversationHistory: [
          {
            'role': 'user',
            'content': 'Mulai wawancara kerja dengan memberikan salam pembuka dan pertanyaan pertama.'
          }
        ],
        difficulty: difficulty,
        style: style,
        additionalPrompt: additionalPrompt,
      );
    } catch (e) {
      print('Error starting interview: $e');
      return 'Selamat datang di sesi wawancara kerja. Mari kita mulai dengan pertanyaan pertama: Bisakah Anda memperkenalkan diri dan menceritakan latar belakang Anda?';
    }
  }
}
