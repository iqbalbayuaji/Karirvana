import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../app/modules/career_assistant/models/chat_message.dart';
import '../app/modules/jadwal_manage/models/task_model.dart';

class GroqScheduleService {
  static const String _baseUrl = 'https://api.groq.com/openai/v1/chat/completions';
  static const String _model = 'llama3-8b-8192';

  static String get _apiKey => dotenv.env['GROQ_API_KEY'] ?? '';

  static const String _systemPrompt = '''
Anda adalah Schedule Assistant yang ahli dalam membuat jadwal belajar yang terstruktur dan realistis dalam bahasa Indonesia.

TUGAS ANDA:
- Membuat jadwal belajar yang praktis dan dapat diikuti
- Menyesuaikan dengan kebutuhan dan preferensi pengguna
- Memberikan estimasi waktu yang realistis
- Fokus pada pembelajaran yang efektif

ATURAN RESPONSE:
1. Jika user meminta jadwal belajar, WAJIB response dalam format JSON yang valid
2. Gunakan format JSON berikut:

{
  "type": "schedule",
  "title": "Judul Jadwal",
  "description": "Deskripsi singkat jadwal",
  "duration": "3 hari", 
  "tasks": [
    {
      "title": "Judul Task",
      "description": "Deskripsi detail task",
      "date": "2024-01-01",
      "time": "09:00",
      "endTime": "11:00",
      "priority": "medium",
      "category": "study"
    }
  ]
}

3. Untuk date gunakan format YYYY-MM-DD (mulai dari hari ini)
4. Untuk time dan endTime gunakan format HH:MM (24 jam)
5. Priority: "low", "medium", "high", "urgent"
6. Category: "study", "work", "personal", "other"
7. Default durasi 3 hari jika tidak disebutkan
8. Waktu belajar realistis: 1-3 jam per sesi
9. Berikan jeda istirahat yang cukup
10. Sesuaikan dengan roadmap/course yang ada jika disebutkan

CONTOH PERMINTAAN YANG HARUS DIJAWAB DENGAN JSON:
- "Buatkan jadwal belajar"
- "Generate schedule untuk belajar React"
- "Saya butuh jadwal belajar 1 minggu"
- "Buatkan jadwal untuk course HTML CSS"

JIKA BUKAN PERMINTAAN JADWAL:
Response normal dalam bahasa Indonesia tanpa JSON.
''';

  /// Send message to Groq API for schedule generation
  static Future<String> sendMessage(List<ChatMessage> messages) async {
    if (_apiKey.isEmpty) {
      throw Exception('GROQ_API_KEY tidak ditemukan. Pastikan file .env sudah dikonfigurasi dengan benar.');
    }

    try {
      print('🔄 GroqScheduleService: Sending request to Groq API...');
      
      // Convert messages to Groq format
      final groqMessages = [
        {'role': 'system', 'content': _systemPrompt},
        ...messages.map((msg) => msg.toGroqMessage()).toList(),
      ];

      print('📤 Request messages count: ${groqMessages.length}');

      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'model': _model,
          'messages': groqMessages,
          'max_tokens': 2000,
          'temperature': 0.7,
        }),
      );

      print('📥 Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final content = data['choices'][0]['message']['content'] as String;
        
        print('✅ GroqScheduleService: Response received successfully');
        print('📄 Response length: ${content.length}');
        
        return content;
      } else {
        print('❌ GroqScheduleService Error: ${response.statusCode}');
        print('📄 Error body: ${response.body}');
        throw Exception('Groq API Error: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('❌ GroqScheduleService Exception: $e');
      rethrow;
    }
  }

  /// Check if response contains a schedule
  static bool isScheduleResponse(String response) {
    try {
      final trimmed = response.trim();
      if (!trimmed.startsWith('{') || !trimmed.endsWith('}')) {
        return false;
      }
      
      final json = jsonDecode(trimmed);
      return json is Map<String, dynamic> && 
             json['type'] == 'schedule' && 
             json.containsKey('tasks');
    } catch (e) {
      print('⚠️ Error checking schedule response: $e');
      return false;
    }
  }

  /// Parse schedule response to TaskModel list
  static List<TaskModel> parseScheduleResponse(String response) {
    try {
      print('🔄 Parsing schedule response...');
      
      final json = jsonDecode(response.trim());
      final tasks = json['tasks'] as List<dynamic>;
      
      final now = DateTime.now();
      final userId = 'current_user'; // TODO: Get actual user ID
      
      return tasks.map<TaskModel>((taskJson) {
        final taskMap = taskJson as Map<String, dynamic>;
        
        // Parse date
        final dateStr = taskMap['date'] as String;
        final date = DateTime.parse(dateStr);
        
        // Parse time
        DateTime? time;
        DateTime? endTime;
        
        if (taskMap['time'] != null) {
          final timeStr = taskMap['time'] as String;
          final timeParts = timeStr.split(':');
          time = DateTime(date.year, date.month, date.day, 
                         int.parse(timeParts[0]), int.parse(timeParts[1]));
        }
        
        if (taskMap['endTime'] != null) {
          final endTimeStr = taskMap['endTime'] as String;
          final endTimeParts = endTimeStr.split(':');
          endTime = DateTime(date.year, date.month, date.day, 
                           int.parse(endTimeParts[0]), int.parse(endTimeParts[1]));
        }
        
        // Parse priority
        final priorityStr = taskMap['priority'] as String? ?? 'medium';
        final priority = TaskPriority.values.firstWhere(
          (p) => p.name == priorityStr,
          orElse: () => TaskPriority.medium,
        );
        
        // Parse category
        final categoryStr = taskMap['category'] as String? ?? 'study';
        final category = TaskCategory.values.firstWhere(
          (c) => c.name == categoryStr,
          orElse: () => TaskCategory.study,
        );
        
        return TaskModel(
          id: DateTime.now().millisecondsSinceEpoch.toString() + 
              tasks.indexOf(taskJson).toString(),
          userId: userId,
          title: taskMap['title'] as String,
          description: taskMap['description'] as String,
          date: date,
          time: time,
          endTime: endTime,
          priority: priority,
          category: category,
          isCompleted: false,
          createdAt: now,
          updatedAt: now,
        );
      }).toList();
      
    } catch (e) {
      print('❌ Error parsing schedule response: $e');
      throw Exception('Gagal memparse jadwal: $e');
    }
  }

  /// Get schedule metadata from response
  static Map<String, String> getScheduleMetadata(String response) {
    try {
      final json = jsonDecode(response.trim());
      return {
        'title': json['title'] as String? ?? 'Jadwal Belajar',
        'description': json['description'] as String? ?? '',
        'duration': json['duration'] as String? ?? '3 hari',
      };
    } catch (e) {
      print('⚠️ Error getting schedule metadata: $e');
      return {
        'title': 'Jadwal Belajar',
        'description': '',
        'duration': '3 hari',
      };
    }
  }

  /// Test connection to Groq API
  static Future<bool> testConnection() async {
    try {
      final testMessages = [
        ChatMessage.user('Test connection'),
      ];
      
      await sendMessage(testMessages);
      return true;
    } catch (e) {
      print('❌ Connection test failed: $e');
      return false;
    }
  }
}
