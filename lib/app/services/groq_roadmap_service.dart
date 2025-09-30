import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../modules/career_assistant/models/chat_message.dart';
import '../modules/roadmap_manage/models/roadmap_models.dart';

class GroqRoadmapService {
  static const String _baseUrl = 'https://api.groq.com/openai/v1/chat/completions';
  static const String _model = 'llama-3.1-8b-instant';
  
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

KETIKA MEMBUAT ROADMAP:
Jika kamu sudah mengumpulkan informasi yang cukup dan siap membuat roadmap, WAJIB gunakan format JSON berikut:

```json
{
  "type": "roadmap",
  "title": "Roadmap Karir [Nama Karir]",
  "description": "Deskripsi singkat roadmap",
  "steps": [
    {
      "id": "step_1",
      "title": "Judul Step Utama",
      "description": "Deskripsi step utama",
      "estimatedDuration": "2-3 bulan",
      "subSteps": [
        {
          "id": "substep_1_1",
          "title": "Judul Sub-Step",
          "description": "Deskripsi sub-step",
          "estimatedDuration": "2 minggu",
          "resources": [
            {
              "type": "course",
              "title": "Nama Course",
              "provider": "Platform/Provider"
            }
          ]
        }
      ]
    }
  ]
}
```

ATURAN PENTING:
- Gunakan format JSON HANYA ketika membuat roadmap final
- Untuk percakapan biasa, gunakan teks normal
- Pastikan JSON valid dan sesuai struktur - JANGAN sampai ada string yang tidak tertutup
- Buat 3-4 step utama dengan 2-3 sub-step per step (jangan terlalu banyak)
- Resource types: course, certificate, job, tool (JANGAN gunakan guide atau type lainnya)
- PASTIKAN semua string dalam JSON tertutup dengan benar dengan tanda kutip
- JANGAN buat JSON yang terlalu panjang - fokus pada hal-hal penting saja

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
    print('🔑 Checking API key...');
    if (_apiKey == null || _apiKey!.isEmpty) {
      print('❌ API key not found');
      throw Exception('GROQ_API_KEY tidak ditemukan. Pastikan sudah mengatur API key di file .env');
    }
    print('✅ API key found');

    try {
      final List<Map<String, dynamic>> formattedMessages = [
        {'role': 'system', 'content': _systemPrompt},
        ...messages.map((msg) => msg.toGroqMessage()),
      ];

      print('📤 Sending request to Groq API...');
      print('📊 Message count: ${formattedMessages.length}');
      print('🤖 Model: $_model');

      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'model': _model,
          'messages': formattedMessages,
          'max_tokens': 4000,  // Further increased for complete roadmaps
          'temperature': 0.5,  // Lower temperature for more consistent JSON
        }),
      );

      print('📥 Response received - Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final content = data['choices'][0]['message']['content'];
        print('✅ Content extracted - Length: ${content.length}');
        return content;
      } else {
        print('❌ API Error: ${response.statusCode}');
        print('📄 Response body: ${response.body}');
        throw Exception('Gagal menghubungi AI: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('❌ Exception in GroqRoadmapService: ${e.toString()}');
      if (e.toString().contains('GROQ_API_KEY')) {
        throw Exception('GROQ_API_KEY tidak ditemukan. Pastikan sudah mengatur API key di file .env');
      }
      throw Exception('Network/API Error: $e');
    }
  }

  // Parse JSON roadmap from Groq response
  static Map<String, dynamic>? extractRoadmapJson(String response) {
    try {
      print('🔍 EXTRACTING JSON from response...');
      print('📄 Response preview: ${response.length > 300 ? response.substring(0, 300) + "..." : response}');
      
      // Look for JSON content between ```json and ``` - use greedy matching for complete JSON
      final jsonMatch = RegExp(r'```json\s*([\s\S]*)\s*```', multiLine: true, dotAll: true).firstMatch(response);
      if (jsonMatch != null) {
        print('✅ Found JSON in code block');
        final jsonString = jsonMatch.group(1)!;
        print('📊 JSON string length: ${jsonString.length}');
        print('🔍 JSON string preview: ${jsonString.length > 200 ? jsonString.substring(0, 200) + "..." : jsonString}');
        
        try {
          final parsed = jsonDecode(jsonString) as Map<String, dynamic>;
          print('🎯 JSON parsed successfully');
          return parsed;
        } catch (e) {
          print('❌ Failed to parse extracted JSON: $e');
          print('📄 Full JSON string: $jsonString');
          return null;
        }
      }
      
      print('⚠️ No JSON code block found, trying alternative patterns...');
      
      // Try to find any JSON object that contains "type": "roadmap"
      final patterns = [
        r'\{\s*"type"\s*:\s*"roadmap"[\s\S]*',  // Original pattern
        r'\{[\s\S]*?"type"\s*:\s*"roadmap"[\s\S]*',  // Type field anywhere in JSON
        r'\{[\s\S]*?"type"[\s\S]*?"roadmap"[\s\S]*',  // More flexible pattern
      ];
      
      for (int i = 0; i < patterns.length; i++) {
        final altMatch = RegExp(patterns[i], multiLine: true, dotAll: true).firstMatch(response);
        if (altMatch != null) {
          print('✅ Found JSON with pattern ${i + 1}');
          final jsonString = altMatch.group(0)!;
          print('📊 Alt JSON string length: ${jsonString.length}');
          
          // Try to find the end of JSON by counting braces
          String cleanedJson = _findCompleteJson(jsonString);
          print('🧹 Cleaned JSON length: ${cleanedJson.length}');
          
          try {
            final parsed = jsonDecode(cleanedJson) as Map<String, dynamic>;
            print('🎯 Alternative JSON parsed successfully');
            return parsed;
          } catch (e) {
            print('❌ Failed to parse alternative JSON: $e');
            print('🔧 Trying to fix incomplete JSON...');
            
            // Try to fix incomplete JSON by adding closing braces
            final fixedJson = _tryFixIncompleteJson(cleanedJson);
            if (fixedJson != null) {
              try {
                final parsed = jsonDecode(fixedJson) as Map<String, dynamic>;
                print('✅ Fixed JSON parsed successfully');
                return parsed;
              } catch (e2) {
                print('❌ Failed to parse fixed JSON: $e2');
              }
            }
          }
        }
      }
      
      
      // Try to parse the entire response as JSON
      try {
        final parsed = jsonDecode(response) as Map<String, dynamic>;
        print('✅ Entire response parsed as JSON');
        return parsed;
      } catch (e) {
        print('❌ Failed to parse entire response as JSON: $e');
        return null;
      }
    } catch (e) {
      print('❌ Exception in extractRoadmapJson: $e');
      return null;
    }
  }

  // Convert JSON to RoadmapMainStep objects
  static List<RoadmapMainStep> parseRoadmapSteps(Map<String, dynamic> roadmapJson) {
    final steps = roadmapJson['steps'] as List<dynamic>? ?? [];
    
    return steps.map((stepData) {
      final stepMap = stepData as Map<String, dynamic>;
      final subStepsData = stepMap['subSteps'] as List<dynamic>? ?? [];
      
      final subSteps = subStepsData.map((subStepData) {
        final subStepMap = subStepData as Map<String, dynamic>;
        final resourcesData = subStepMap['resources'] as List<dynamic>? ?? [];
        
        final resources = resourcesData.map((resourceData) {
          final resourceMap = resourceData as Map<String, dynamic>;
          return RoadmapResource(
            type: resourceMap['type'] as String? ?? 'guide',
            title: resourceMap['title'] as String? ?? 'Untitled Resource',
            provider: resourceMap['provider'] as String? ?? 'Unknown Provider',
            location: resourceMap['location'] as String?,
          );
        }).toList();
        
        return RoadmapSubStep(
          id: subStepMap['id'] as String? ?? 'substep_${DateTime.now().millisecondsSinceEpoch}',
          title: subStepMap['title'] as String? ?? 'Untitled Sub-Step',
          description: subStepMap['description'] as String? ?? '',
          isCompleted: false,
          estimatedDuration: subStepMap['estimatedDuration'] as String? ?? '1 minggu',
          resources: resources,
        );
      }).toList();
      
      return RoadmapMainStep(
        id: stepMap['id'] as String? ?? 'step_${DateTime.now().millisecondsSinceEpoch}',
        title: stepMap['title'] as String? ?? 'Untitled Step',
        description: stepMap['description'] as String? ?? '',
        isCompleted: false,
        estimatedDuration: stepMap['estimatedDuration'] as String? ?? '1 bulan',
        subSteps: subSteps,
      );
    }).toList();
  }

  // Check if response contains a roadmap
  static bool isRoadmapResponse(String response) {
    print('🔎 CHECKING if response is roadmap...');
    
    final roadmapJson = extractRoadmapJson(response);
    
    if (roadmapJson == null) {
      print('❌ No JSON found - NOT a roadmap');
      return false;
    }
    
    final hasTypeField = roadmapJson.containsKey('type');
    final typeValue = roadmapJson['type'];
    final isRoadmapType = typeValue == 'roadmap';
    
    print('📋 JSON keys: ${roadmapJson.keys.toList()}');
    print('🏷️ Has type field: $hasTypeField');
    print('🎯 Type value: $typeValue');
    print('✅ Is roadmap: $isRoadmapType');
    
    return hasTypeField && isRoadmapType;
  }

  // Get roadmap title and description
  static Map<String, String> getRoadmapInfo(String response) {
    final roadmapJson = extractRoadmapJson(response);
    if (roadmapJson != null) {
      return {
        'title': roadmapJson['title'] as String? ?? 'Roadmap Karir',
        'description': roadmapJson['description'] as String? ?? '',
      };
    }
    return {
      'title': 'Roadmap Karir',
      'description': '',
    };
  }

  // Try to fix incomplete JSON by adding missing closing braces and fixing unterminated strings
  static String? _tryFixIncompleteJson(String jsonString) {
    try {
      print('🔧 Attempting to fix JSON: ${jsonString.substring(0, jsonString.length > 100 ? 100 : jsonString.length)}...');
      
      String fixedJson = jsonString;
      
      // Fix unterminated strings by finding the last incomplete string and closing it
      fixedJson = _fixUnterminatedStrings(fixedJson);
      
      // Count opening and closing braces
      int openBraces = 0;
      int closeBraces = 0;
      int openBrackets = 0;
      int closeBrackets = 0;
      
      for (int i = 0; i < fixedJson.length; i++) {
        switch (fixedJson[i]) {
          case '{':
            openBraces++;
            break;
          case '}':
            closeBraces++;
            break;
          case '[':
            openBrackets++;
            break;
          case ']':
            closeBrackets++;
            break;
        }
      }
      
      print('📊 Braces: open=$openBraces, close=$closeBraces');
      print('📊 Brackets: open=$openBrackets, close=$closeBrackets');
      
      // Add missing closing brackets
      for (int i = 0; i < (openBrackets - closeBrackets); i++) {
        fixedJson += ']';
      }
      
      // Add missing closing braces
      for (int i = 0; i < (openBraces - closeBraces); i++) {
        fixedJson += '}';
      }
      
      print('🔧 Fixed JSON length: ${fixedJson.length}');
      return fixedJson;
    } catch (e) {
      print('❌ Error fixing JSON: $e');
      return null;
    }
  }

  // Fix unterminated strings in JSON
  static String _fixUnterminatedStrings(String jsonString) {
    try {
      // Find the last occurrence of an opening quote that's not closed
      int lastQuoteIndex = -1;
      bool inString = false;
      bool escaped = false;
      
      for (int i = 0; i < jsonString.length; i++) {
        if (escaped) {
          escaped = false;
          continue;
        }
        
        if (jsonString[i] == '\\') {
          escaped = true;
          continue;
        }
        
        if (jsonString[i] == '"') {
          if (inString) {
            inString = false;
          } else {
            inString = true;
            lastQuoteIndex = i;
          }
        }
      }
      
      // If we're still in a string at the end, close it
      if (inString && lastQuoteIndex >= 0) {
        print('🔧 Fixing unterminated string at position $lastQuoteIndex');
        return jsonString + '"';
      }
      
      return jsonString;
    } catch (e) {
      print('❌ Error fixing unterminated strings: $e');
      return jsonString;
    }
  }

  // Try to find complete JSON by balancing braces
  static String _findCompleteJson(String jsonString) {
    int braceCount = 0;
    int lastValidIndex = -1;
    
    for (int i = 0; i < jsonString.length; i++) {
      if (jsonString[i] == '{') {
        braceCount++;
      } else if (jsonString[i] == '}') {
        braceCount--;
        if (braceCount == 0) {
          lastValidIndex = i;
          break;
        }
      }
    }
    
    if (lastValidIndex > 0) {
      return jsonString.substring(0, lastValidIndex + 1);
    }
    
    return jsonString;
  }

}
