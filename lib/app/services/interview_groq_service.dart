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

  static Future<Map<String, dynamic>> generateInterviewFeedback({
    required List<Map<String, String>> conversationHistory,
    required String difficulty,
    required String style,
    String? additionalPrompt,
  }) async {
    try {
      if (_apiKey.isEmpty) {
        throw Exception('GROQ_API_KEY tidak ditemukan dalam file .env');
      }

      // Create detailed system prompt for feedback analysis
      String feedbackSystemPrompt = '''Anda adalah seorang HR Expert dan Interview Analyst yang berpengalaman. Tugas Anda adalah menganalisis percakapan wawancara kerja dan memberikan feedback yang detail dan konstruktif dalam bahasa Indonesia.

INSTRUKSI ANALISIS:
- Analisis setiap jawaban kandidat berdasarkan: struktur, kejelasan, relevansi, kepercayaan diri, dan profesionalisme
- Berikan penilaian objektif berdasarkan tingkat kesulitan: $difficulty dan gaya: $style
- Fokus pada aspek: Fluency, Confidence, Structure, Content Quality, Communication Skills

FORMAT OUTPUT (HARUS JSON VALID):
{
  "overallScore": [nilai 0-100],
  "detailedScores": {
    "fluency": [nilai 0-100],
    "confidence": [nilai 0-100], 
    "structure": [nilai 0-100],
    "content": [nilai 0-100],
    "communication": [nilai 0-100]
  },
  "strengths": [
    "Kekuatan spesifik 1 berdasarkan jawaban",
    "Kekuatan spesifik 2 berdasarkan jawaban",
    "Kekuatan spesifik 3 berdasarkan jawaban"
  ],
  "improvements": [
    "Saran perbaikan spesifik 1",
    "Saran perbaikan spesifik 2", 
    "Saran perbaikan spesifik 3"
  ],
  "performanceBreakdown": {
    "Excellent": [persentase 0-100],
    "Good": [persentase 0-100],
    "Needs Improvement": [persentase 0-100]
  },
  "detailedAnalysis": "Analisis mendalam tentang performa kandidat dalam 2-3 kalimat",
  "recommendedActions": [
    "Aksi konkret 1 untuk improvement",
    "Aksi konkret 2 untuk improvement"
  ]
}

PENTING: 
- Berikan feedback yang SPESIFIK berdasarkan jawaban kandidat
- Jangan gunakan template umum
- Nilai harus realistis berdasarkan kualitas jawaban
- Strengths dan improvements harus relevan dengan percakapan
- Output HARUS dalam format JSON yang valid''';

      // Prepare conversation for analysis
      String conversationSummary = conversationHistory
          .where((msg) => msg['role'] != 'system')
          .map((msg) => '${msg['role'] == 'user' ? 'KANDIDAT' : 'INTERVIEWER'}: ${msg['content']}')
          .join('\n\n');

      List<Map<String, String>> feedbackMessages = [
        {'role': 'system', 'content': feedbackSystemPrompt},
        {
          'role': 'user',
          'content': 'Analisis percakapan wawancara berikut dan berikan feedback dalam format JSON:\n\n$conversationSummary'
        },
      ];

      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'model': _model,
          'messages': feedbackMessages,
          'temperature': 0.3, // Lower temperature for consistent analysis
          'max_tokens': 1500, // Enough tokens for detailed feedback
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final content = data['choices'][0]['message']['content'];
        
        try {
          // Parse the JSON response from Groq
          final feedbackJson = jsonDecode(content);
          
          // Validate and return the feedback
          return {
            'overallScore': feedbackJson['overallScore'] ?? 75,
            'detailedScores': feedbackJson['detailedScores'] ?? {
              'fluency': 75,
              'confidence': 75,
              'structure': 75,
              'content': 75,
              'communication': 75,
            },
            'strengths': List<String>.from(feedbackJson['strengths'] ?? [
              'Menunjukkan antusiasme dalam menjawab pertanyaan',
              'Mampu memberikan contoh yang relevan',
              'Komunikasi cukup jelas dan terstruktur'
            ]),
            'improvements': List<String>.from(feedbackJson['improvements'] ?? [
              'Tingkatkan kepercayaan diri saat berbicara',
              'Berikan detail lebih spesifik dalam jawaban',
              'Latih struktur jawaban yang lebih sistematis'
            ]),
            'performanceBreakdown': feedbackJson['performanceBreakdown'] ?? {
              'Excellent': 30.0,
              'Good': 45.0,
              'Needs Improvement': 25.0,
            },
            'detailedAnalysis': feedbackJson['detailedAnalysis'] ?? 'Kandidat menunjukkan potensi yang baik dengan beberapa area yang perlu ditingkatkan.',
            'recommendedActions': List<String>.from(feedbackJson['recommendedActions'] ?? [
              'Latih presentasi diri dengan lebih percaya diri',
              'Pelajari teknik storytelling untuk jawaban yang lebih menarik'
            ]),
          };
        } catch (jsonError) {
          print('Error parsing JSON feedback: $jsonError');
          print('Raw content: $content');
          // Return fallback feedback if JSON parsing fails
          return _getFallbackFeedback();
        }
      } else {
        print('Groq API Error for feedback: ${response.statusCode} - ${response.body}');
        return _getFallbackFeedback();
      }
    } catch (e) {
      print('Error generating interview feedback: $e');
      return _getFallbackFeedback();
    }
  }

  // Fallback feedback when AI generation fails
  static Map<String, dynamic> _getFallbackFeedback() {
    return {
      'overallScore': 75,
      'detailedScores': {
        'fluency': 75,
        'confidence': 70,
        'structure': 80,
        'content': 75,
        'communication': 75,
      },
      'strengths': [
        'Menunjukkan antusiasme dalam menjawab pertanyaan',
        'Mampu memberikan contoh yang relevan',
        'Komunikasi cukup jelas dan terstruktur'
      ],
      'improvements': [
        'Tingkatkan kepercayaan diri saat berbicara',
        'Berikan detail lebih spesifik dalam jawaban',
        'Latih struktur jawaban yang lebih sistematis'
      ],
      'performanceBreakdown': {
        'Excellent': 30.0,
        'Good': 45.0,
        'Needs Improvement': 25.0,
      },
      'detailedAnalysis': 'Kandidat menunjukkan potensi yang baik dengan beberapa area yang perlu ditingkatkan untuk mencapai performa optimal.',
      'recommendedActions': [
        'Latih presentasi diri dengan lebih percaya diri',
        'Pelajari teknik storytelling untuk jawaban yang lebih menarik'
      ],
    };
  }
}
