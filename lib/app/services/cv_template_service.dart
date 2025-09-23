import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:share_plus/share_plus.dart';
import 'package:cross_file/cross_file.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firestore_service.dart';

class CVTemplateService {
  static const String _groqApiUrl = 'https://api.groq.com/openai/v1/chat/completions';
  
  /// Generate CV content using Groq API with Firebase user data integration
  static Future<Map<String, dynamic>> generateCVContentWithUserData(String userPrompt, {bool useCurrentUser = true}) async {
    try {
      final String? apiKey = dotenv.env['GROQ_API_KEY'];
      
      if (apiKey == null || apiKey.isEmpty) {
        throw Exception('GROQ_API_KEY not found');
      }
      
      // Get user data from Firebase if requested
      Map<String, dynamic>? userData;
      if (useCurrentUser) {
        userData = await FirestoreService.instance.getUserProfile();
      }
      
      // Calculate age from birth date if available
      int? age;
      if (userData?['birthDate'] != null && userData!['birthDate'].toString().isNotEmpty) {
        try {
          DateTime birthDate = DateTime.parse(userData['birthDate']);
          age = DateTime.now().year - birthDate.year;
          if (DateTime.now().month < birthDate.month || 
              (DateTime.now().month == birthDate.month && DateTime.now().day < birthDate.day)) {
            age--;
          }
        } catch (e) {
          debugPrint('Error calculating age: $e');
        }
      }
      
      // Get current user's email from Firebase Auth
      String? userEmail = FirebaseAuth.instance.currentUser?.email;
      
      // Build enhanced system prompt with user data
      String systemPrompt = '''
Buat CV profesional dalam format JSON berdasarkan prompt pengguna.

${useCurrentUser && userData != null ? '''
DATA PENGGUNA YANG TERSEDIA:
- Nama: ${userData['name'] ?? userData['username'] ?? 'Tidak tersedia'}
- Email: ${userEmail ?? userData['email'] ?? 'Tidak tersedia'}
- Tanggal Lahir: ${userData['birthDate'] ?? 'Tidak tersedia'}
- Umur: ${age != null ? '$age tahun' : 'Tidak tersedia'}
- Jenis Kelamin: ${userData['gender'] ?? 'Tidak tersedia'}
- Bio: ${userData['bio'] ?? 'Tidak tersedia'}

GUNAKAN data pengguna di atas untuk mengisi informasi personal CV. Jika ada data yang tidak tersedia, buat contoh yang realistis berdasarkan prompt.
''' : '''
CATATAN: Ini adalah CV untuk orang lain. Buat informasi personal yang realistis berdasarkan prompt pengguna.
'''}

Format JSON:
{
  "personalInfo": {
    "fullName": "Nama Lengkap",
    "title": "Posisi",
    "email": "email@example.com",
    "phone": "+62 812-3456-7890",
    "location": "Jakarta, Indonesia",
    "age": ${age ?? 25},
    "dateOfBirth": "${userData?['birthDate'] ?? '1999-01-01'}"
  },
  "summary": "Ringkasan profesional 2-3 kalimat",
  "experience": [
    {
      "position": "Posisi",
      "company": "Perusahaan",
      "duration": "Jan 2020 - Sekarang",
      "description": "Deskripsi pekerjaan"
    }
  ],
  "education": [
    {
      "degree": "Sarjana",
      "institution": "Universitas",
      "year": "2018-2022"
    }
  ],
  "skills": ["Skill 1", "Skill 2", "Skill 3"]
}

Hanya berikan JSON, tanpa teks lain!
''';

      final response = await http.post(
        Uri.parse(_groqApiUrl),
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'model': 'llama-3.1-8b-instant',
          'messages': [
            {'role': 'system', 'content': systemPrompt},
            {'role': 'user', 'content': 'Buat CV: $userPrompt'}
          ],
          'temperature': 0.7,
          'max_tokens': 2000,
        }),
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        String content = responseData['choices'][0]['message']['content'];
        
        // Clean JSON
        content = content.trim();
        if (content.startsWith('```')) content = content.substring(3);
        if (content.endsWith('```')) content = content.substring(0, content.length - 3);
        if (content.startsWith('json')) content = content.substring(4);
        content = content.trim();
        
        // Extract JSON object
        int start = content.indexOf('{');
        int end = content.lastIndexOf('}');
        if (start != -1 && end != -1) {
          content = content.substring(start, end + 1);
        }
        
        try {
          Map<String, dynamic> cvData = json.decode(content);
          cvData['generatedAt'] = DateTime.now().toIso8601String();
          cvData['createdForCurrentUser'] = useCurrentUser;
          
          // Override with actual user data if available
          if (useCurrentUser && userData != null) {
            cvData['personalInfo'] = cvData['personalInfo'] ?? {};
            if (userData['name'] != null || userData['username'] != null) {
              cvData['personalInfo']['fullName'] = userData['name'] ?? userData['username'];
            }
            if (userEmail != null) {
              cvData['personalInfo']['email'] = userEmail;
            }
            if (age != null) {
              cvData['personalInfo']['age'] = age;
            }
            if (userData['birthDate'] != null) {
              cvData['personalInfo']['dateOfBirth'] = userData['birthDate'];
            }
          }
          
          return cvData;
        } catch (e) {
          return _createFallbackCVWithUserData(userPrompt, userData, userEmail, age, useCurrentUser);
        }
      }
      
      return _createFallbackCVWithUserData(userPrompt, userData, userEmail, age, useCurrentUser);
    } catch (e) {
      debugPrint('CV generation error: $e');
      return _createFallbackCVWithUserData(userPrompt, null, null, null, useCurrentUser);
    }
  }

  /// Generate CV content using Groq API (legacy method for backward compatibility)
  static Future<Map<String, dynamic>> generateCVContent(String userPrompt) async {
    try {
      final String? apiKey = dotenv.env['GROQ_API_KEY'];
      
      if (apiKey == null || apiKey.isEmpty) {
        throw Exception('GROQ_API_KEY not found');
      }
      
      final String systemPrompt = '''
Buat CV profesional dalam format JSON berdasarkan prompt pengguna.

Format JSON:
{
  "personalInfo": {
    "fullName": "Nama Lengkap",
    "title": "Posisi",
    "email": "email@example.com",
    "phone": "+62 812-3456-7890",
    "location": "Jakarta, Indonesia"
  },
  "summary": "Ringkasan profesional 2-3 kalimat",
  "experience": [
    {
      "position": "Posisi",
      "company": "Perusahaan",
      "duration": "Jan 2020 - Sekarang",
      "description": "Deskripsi pekerjaan"
    }
  ],
  "education": [
    {
      "degree": "Sarjana",
      "institution": "Universitas",
      "year": "2018-2022"
    }
  ],
  "skills": ["Skill 1", "Skill 2", "Skill 3"]
}

Hanya berikan JSON, tanpa teks lain!
''';

      final response = await http.post(
        Uri.parse(_groqApiUrl),
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'model': 'llama-3.1-8b-instant',
          'messages': [
            {'role': 'system', 'content': systemPrompt},
            {'role': 'user', 'content': 'Buat CV: $userPrompt'}
          ],
          'temperature': 0.7,
          'max_tokens': 2000,
        }),
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        String content = responseData['choices'][0]['message']['content'];
        
        // Clean JSON
        content = content.trim();
        if (content.startsWith('```')) content = content.substring(3);
        if (content.endsWith('```')) content = content.substring(0, content.length - 3);
        if (content.startsWith('json')) content = content.substring(4);
        content = content.trim();
        
        // Extract JSON object
        int start = content.indexOf('{');
        int end = content.lastIndexOf('}');
        if (start != -1 && end != -1) {
          content = content.substring(start, end + 1);
        }
        
        try {
          Map<String, dynamic> cvData = json.decode(content);
          cvData['generatedAt'] = DateTime.now().toIso8601String();
          return cvData;
        } catch (e) {
          return _createFallbackCV(userPrompt);
        }
      }
      
      return _createFallbackCV(userPrompt);
    } catch (e) {
      debugPrint('CV generation error: $e');
      return _createFallbackCV(userPrompt);
    }
  }
  
  static Map<String, dynamic> _createFallbackCV(String prompt) {
    return {
      'personalInfo': {
        'fullName': 'Nama Lengkap',
        'title': 'Posisi yang Diinginkan',
        'email': 'email@example.com',
        'phone': '+62 812-3456-7890',
        'location': 'Jakarta, Indonesia'
      },
      'summary': 'Profesional berpengalaman dengan keahlian yang relevan dan orientasi pada hasil.',
      'experience': [
        {
          'position': 'Posisi Terakhir',
          'company': 'Nama Perusahaan',
          'duration': 'Jan 2022 - Sekarang',
          'description': 'Mengelola proyek dan tim dengan fokus pada pencapaian target.'
        }
      ],
      'education': [
        {
          'degree': 'Sarjana (S1)',
          'institution': 'Universitas Terkemuka',
          'year': '2018-2022'
        }
      ],
      'skills': ['Komunikasi', 'Manajemen Proyek', 'Analisis Data', 'Problem Solving'],
      'generatedAt': DateTime.now().toIso8601String(),
      'fallbackUsed': true
    };
  }
  
  static Map<String, dynamic> _createFallbackCVWithUserData(
    String prompt, 
    Map<String, dynamic>? userData, 
    String? userEmail, 
    int? age, 
    bool useCurrentUser
  ) {
    return {
      'personalInfo': {
        'fullName': useCurrentUser && userData != null 
            ? (userData['name'] ?? userData['username'] ?? 'Nama Lengkap')
            : 'Nama Lengkap',
        'title': 'Posisi yang Diinginkan',
        'email': useCurrentUser && userEmail != null 
            ? userEmail 
            : 'email@example.com',
        'phone': '+62 812-3456-7890',
        'location': 'Jakarta, Indonesia',
        'age': age ?? 25,
        'dateOfBirth': useCurrentUser && userData?['birthDate'] != null 
            ? userData!['birthDate'] 
            : '1999-01-01'
      },
      'summary': useCurrentUser && userData?['bio'] != null && userData!['bio'].toString().isNotEmpty
          ? userData['bio']
          : 'Profesional berpengalaman dengan keahlian yang relevan dan orientasi pada hasil.',
      'experience': [
        {
          'position': 'Posisi Terakhir',
          'company': 'Nama Perusahaan',
          'duration': 'Jan 2022 - Sekarang',
          'description': 'Mengelola proyek dan tim dengan fokus pada pencapaian target.'
        }
      ],
      'education': [
        {
          'degree': 'Sarjana (S1)',
          'institution': 'Universitas Terkemuka',
          'year': '2018-2022'
        }
      ],
      'skills': ['Komunikasi', 'Manajemen Proyek', 'Analisis Data', 'Problem Solving'],
      'generatedAt': DateTime.now().toIso8601String(),
      'createdForCurrentUser': useCurrentUser,
      'fallbackUsed': true
    };
  }
  
  /// Generate PDF from CV data
  static Future<File> generateCVPDF(Map<String, dynamic> cvData) async {
    PdfDocument document = PdfDocument();
    PdfPage page = document.pages.add();
    PdfGraphics graphics = page.graphics;
    
    // Fonts
    PdfFont titleFont = PdfStandardFont(PdfFontFamily.helvetica, 18, style: PdfFontStyle.bold);
    PdfFont headerFont = PdfStandardFont(PdfFontFamily.helvetica, 12, style: PdfFontStyle.bold);
    PdfFont normalFont = PdfStandardFont(PdfFontFamily.helvetica, 10);
    
    double yPosition = 50;
    
    // Personal Info
    final personalInfo = cvData['personalInfo'] ?? {};
    graphics.drawString(personalInfo['fullName'] ?? 'Nama Lengkap', titleFont, 
        bounds: const Rect.fromLTWH(50, 50, 500, 30));
    yPosition += 25;
    
    graphics.drawString(personalInfo['title'] ?? 'Posisi', headerFont,
        bounds: Rect.fromLTWH(50, yPosition, 500, 20));
    yPosition += 20;
    
    // Contact info with age if available
    String contactInfo = '${personalInfo['email'] ?? ''} | ${personalInfo['phone'] ?? ''}';
    if (personalInfo['age'] != null) {
      contactInfo += ' | Umur: ${personalInfo['age']} tahun';
    }
    graphics.drawString(contactInfo, normalFont,
        bounds: Rect.fromLTWH(50, yPosition, 500, 15));
    yPosition += 15;
    
    // Location and date of birth
    String locationInfo = personalInfo['location'] ?? 'Jakarta, Indonesia';
    if (personalInfo['dateOfBirth'] != null) {
      locationInfo += ' | Tanggal Lahir: ${personalInfo['dateOfBirth']}';
    }
    graphics.drawString(locationInfo, normalFont,
        bounds: Rect.fromLTWH(50, yPosition, 500, 15));
    yPosition += 30;
    
    // Summary
    graphics.drawString('RINGKASAN', headerFont,
        bounds: Rect.fromLTWH(50, yPosition, 500, 20));
    yPosition += 20;
    
    graphics.drawString(cvData['summary'] ?? '', normalFont,
        bounds: Rect.fromLTWH(50, yPosition, 500, 40));
    yPosition += 50;
    
    // Experience
    graphics.drawString('PENGALAMAN KERJA', headerFont,
        bounds: Rect.fromLTWH(50, yPosition, 500, 20));
    yPosition += 20;
    
    final experience = cvData['experience'] as List? ?? [];
    for (var exp in experience) {
      graphics.drawString('${exp['position']} - ${exp['company']}', normalFont,
          bounds: Rect.fromLTWH(50, yPosition, 500, 15));
      yPosition += 15;
      
      graphics.drawString(exp['duration'] ?? '', normalFont,
          bounds: Rect.fromLTWH(50, yPosition, 500, 15));
      yPosition += 15;
      
      graphics.drawString(exp['description'] ?? '', normalFont,
          bounds: Rect.fromLTWH(50, yPosition, 500, 30));
      yPosition += 40;
    }
    
    // Education
    graphics.drawString('PENDIDIKAN', headerFont,
        bounds: Rect.fromLTWH(50, yPosition, 500, 20));
    yPosition += 20;
    
    final education = cvData['education'] as List? ?? [];
    for (var edu in education) {
      graphics.drawString('${edu['degree']} - ${edu['institution']}', normalFont,
          bounds: Rect.fromLTWH(50, yPosition, 500, 15));
      yPosition += 15;
      
      graphics.drawString(edu['year'] ?? '', normalFont,
          bounds: Rect.fromLTWH(50, yPosition, 500, 15));
      yPosition += 25;
    }
    
    // Skills
    graphics.drawString('KEAHLIAN', headerFont,
        bounds: Rect.fromLTWH(50, yPosition, 500, 20));
    yPosition += 20;
    
    final skills = cvData['skills'] as List? ?? [];
    String skillsText = skills.join(', ');
    graphics.drawString(skillsText, normalFont,
        bounds: Rect.fromLTWH(50, yPosition, 500, 30));
    
    // Save PDF
    List<int> bytes = await document.save();
    document.dispose();
    
    // Save to Downloads folder
    return await _saveToDownloads(bytes, cvData);
  }
  
  /// Save PDF to Downloads folder
  static Future<File> _saveToDownloads(List<int> bytes, Map<String, dynamic> cvData) async {
    try {
      // Request storage permission
      await _requestStoragePermission();
      
      // Generate filename
      final personalInfo = cvData['personalInfo'] ?? {};
      String fileName = 'CV_${personalInfo['fullName'] ?? 'Template'}_${DateTime.now().millisecondsSinceEpoch}.pdf';
      fileName = fileName.replaceAll(' ', '_').replaceAll(RegExp(r'[^\w\-_\.]'), '');
      
      Directory? directory;
      
      if (Platform.isAndroid) {
        directory = Directory('/storage/emulated/0/Download');
        if (!await directory.exists()) {
          directory = await getExternalStorageDirectory();
        }
      } else {
        directory = await getApplicationDocumentsDirectory();
      }
      
      final file = File('${directory!.path}/$fileName');
      await file.writeAsBytes(bytes);
      
      debugPrint('PDF saved to: ${file.path}');
      return file;
    } catch (e) {
      debugPrint('Error saving to downloads: $e');
      // Fallback
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/cv_template_${DateTime.now().millisecondsSinceEpoch}.pdf');
      await file.writeAsBytes(bytes);
      return file;
    }
  }
  
  /// Request storage permission
  static Future<void> _requestStoragePermission() async {
    if (Platform.isAndroid) {
      await Permission.storage.request();
    }
  }
  
  /// Open PDF file with default app
  static Future<void> openPDF(String filePath) async {
    try {
      final result = await OpenFile.open(filePath);
      debugPrint('Open file result: ${result.message}');
      
      if (result.type != ResultType.done) {
        throw Exception('Gagal membuka file: ${result.message}');
      }
    } catch (e) {
      debugPrint('Error opening PDF: $e');
      
      // Fallback: Show file path to user
      if (e.toString().contains('MissingPluginException')) {
        throw Exception('Plugin belum siap. Silakan restart aplikasi dan coba lagi.\n\nFile tersimpan di: $filePath');
      } else {
        throw Exception('Tidak dapat membuka file PDF: ${e.toString()}');
      }
    }
  }
  
  /// Share PDF file
  static Future<void> sharePDF(String filePath) async {
    try {
      await Share.shareXFiles([XFile(filePath)], text: 'Template CV saya');
    } catch (e) {
      debugPrint('Error sharing PDF: $e');
      throw Exception('Tidak dapat membagikan file PDF');
    }
  }
}
