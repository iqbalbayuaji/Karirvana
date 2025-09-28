import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:archive/archive.dart';

class PDFAnalysisService {
  static const String _groqApiUrl = 'https://api.groq.com/openai/v1/chat/completions';
  
  /// Extract text from a file (PDF, DOCX, DOC)
  static Future<String> extractTextFromFile(File file) async {
    final path = file.path.toLowerCase();
    if (path.endsWith('.pdf')) {
      return extractTextFromPDF(file);
    } else if (path.endsWith('.docx')) {
      return extractTextFromDOCX(file);
    } else if (path.endsWith('.doc')) {
      // Legacy .doc (binary) is not supported without native conversion tools
      throw Exception('Format DOC (Word lama) belum didukung. Silakan konversi ke PDF atau DOCX.');
    } else {
      throw Exception('Format file tidak didukung. Gunakan PDF atau DOCX.');
    }
  }

  /// Extract text from PDF file using Syncfusion
  static Future<String> extractTextFromPDF(File pdfFile) async {
    try {
      // Read PDF file as bytes
      Uint8List pdfBytes = await pdfFile.readAsBytes();
      
      // Load the PDF document
      PdfDocument document = PdfDocument(inputBytes: pdfBytes);
      
      if (document.pages.count == 0) {
        document.dispose();
        throw Exception('PDF file is empty or corrupted');
      }
      
      String fullText = '';
      
      // Create PdfTextExtractor instance for the document
      PdfTextExtractor textExtractor = PdfTextExtractor(document);
      
      // Extract text from all pages
      for (int i = 0; i < document.pages.count; i++) {
        String pageText = textExtractor.extractText(startPageIndex: i, endPageIndex: i);
        fullText += pageText + '\n';
      }
      
      // Dispose the document to free memory
      document.dispose();
      
      if (fullText.trim().isEmpty) {
        throw Exception('No readable text found in PDF');
      }
      
      return fullText.trim();
    } catch (e) {
      debugPrint('Error extracting PDF text: $e');
      throw Exception('Failed to extract text from PDF: ${e.toString()}');
    }
  }

  /// Extract text from DOCX file by reading word/document.xml and concatenating all w:t runs
  static Future<String> extractTextFromDOCX(File docxFile) async {
    try {
      final bytes = await docxFile.readAsBytes();
      // DOCX is a ZIP file; quick sanity check for 'PK' header
      if (bytes.length < 2 || bytes[0] != 0x50 || bytes[1] != 0x4B) {
        throw Exception('File DOCX tidak valid (bukan arsip ZIP)');
      }

      final archive = ZipDecoder().decodeBytes(bytes, verify: false);
      ArchiveFile? documentXml;
      for (final f in archive.files) {
        final name = f.name.replaceAll('\\', '/');
        if (name.endsWith('word/document.xml')) {
          documentXml = f;
          break;
        }
      }

      if (documentXml == null) {
        throw Exception('Dokumen DOCX tidak memiliki word/document.xml');
      }

      final xmlContent = utf8.decode(documentXml.content as List<int>);

      // Extract all text inside <w:t> ... </w:t>
      final reg = RegExp(r'<w:t[^>]*>(.*?)<\/w:t>', multiLine: true, dotAll: true);
      final matches = reg.allMatches(xmlContent);
      if (matches.isEmpty) {
        throw Exception('Tidak ditemukan teks yang dapat dibaca dalam DOCX');
      }

      final buffer = StringBuffer();
      for (final m in matches) {
        var t = m.group(1) ?? '';
        t = _unescapeXml(t);
        if (t.isNotEmpty) {
          buffer.writeln(t);
        }
      }

      final result = buffer.toString().trim();
      if (result.isEmpty) {
        throw Exception('Tidak ditemukan teks yang dapat dibaca dalam DOCX');
      }
      return result;
    } catch (e) {
      debugPrint('Error extracting DOCX text: $e');
      throw Exception('Gagal mengekstrak teks dari DOCX: ${e.toString()}');
    }
  }
  
  /// Analyze CV text using Groq API
  static Future<Map<String, dynamic>> analyzeCV(String cvText) async {
    try {
      final String? apiKey = dotenv.env['GROQ_API_KEY'];
      
      if (apiKey == null || apiKey.isEmpty) {
        throw Exception('GROQ_API_KEY not found in environment variables');
      }
      
      final String systemPrompt = '''
Anda adalah seorang HR expert dan career consultant profesional dengan pengalaman 15+ tahun. 
Analisis CV berikut dan berikan feedback yang konstruktif dalam bahasa Indonesia.

SANGAT PENTING: 
1. Response HARUS berupa JSON yang valid tanpa teks tambahan
2. Jangan gunakan markdown code blocks atau backticks
3. Langsung berikan JSON object saja

Format JSON yang WAJIB diikuti:
{
  "profileSummary": "Ringkasan profil kandidat dalam 2-3 kalimat yang menggambarkan latar belakang dan keahlian utama",
  "strengths": [
    "Kekuatan 1 dengan penjelasan spesifik",
    "Kekuatan 2 dengan penjelasan spesifik", 
    "Kekuatan 3 dengan penjelasan spesifik"
  ],
  "improvements": [
    "Area perbaikan 1 dengan saran actionable",
    "Area perbaikan 2 dengan saran actionable",
    "Area perbaikan 3 dengan saran actionable"
  ],
  "overallScore": 85,
  "careerRecommendations": "Rekomendasi karir berdasarkan skill, pengalaman, dan tren industri saat ini"
}

Berikan analisis yang objektif, konstruktif, dan actionable. Skor 1-100 berdasarkan kelengkapan CV, relevansi pengalaman, dan presentasi.
INGAT: Hanya berikan JSON object, tidak ada teks lain!
''';

      final Map<String, dynamic> requestBody = {
        'model': 'llama-3.1-8b-instant',
        'messages': [
          {
            'role': 'system',
            'content': systemPrompt,
          },
          {
            'role': 'user',
            'content': 'Analisis CV berikut:\n\n$cvText',
          }
        ],
        'temperature': 0.7,
        'max_tokens': 2000,
      };

      final response = await http.post(
        Uri.parse(_groqApiUrl),
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json',
        },
        body: json.encode(requestBody),
      ).timeout(const Duration(seconds: 60));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        
        if (responseData['choices'] != null && 
            responseData['choices'].isNotEmpty) {
          
          String content = responseData['choices'][0]['message']['content'];
          
          debugPrint('Raw Groq response: $content');
          
          // Clean up the response to extract JSON
          content = content.trim();
          
          // Handle different markdown code block formats
          if (content.startsWith('```json')) {
            content = content.substring(7);
          } else if (content.startsWith('```')) {
            content = content.substring(3);
          }
          
          if (content.endsWith('```')) {
            content = content.substring(0, content.length - 3);
          }
          
          content = content.trim();
          
          // Try to find JSON object if it's embedded in text
          int jsonStart = content.indexOf('{');
          int jsonEnd = content.lastIndexOf('}');
          
          if (jsonStart != -1 && jsonEnd != -1 && jsonEnd > jsonStart) {
            content = content.substring(jsonStart, jsonEnd + 1);
          }
          
          debugPrint('Cleaned content for parsing: $content');
          
          try {
            Map<String, dynamic> analysisResult = json.decode(content);
            
            debugPrint('Parsed analysis result keys: ${analysisResult.keys.toList()}');
            
            // Validate required fields
            List<String> missingFields = [];
            if (!analysisResult.containsKey('profileSummary')) missingFields.add('profileSummary');
            if (!analysisResult.containsKey('strengths')) missingFields.add('strengths');
            if (!analysisResult.containsKey('improvements')) missingFields.add('improvements');
            if (!analysisResult.containsKey('overallScore')) missingFields.add('overallScore');
            if (!analysisResult.containsKey('careerRecommendations')) missingFields.add('careerRecommendations');
            
            if (missingFields.isNotEmpty) {
              debugPrint('Missing required fields: $missingFields');
              throw Exception('Invalid response format from Groq API. Missing fields: ${missingFields.join(", ")}');
            }
            
            // Add metadata
            analysisResult['analyzedAt'] = DateTime.now().toIso8601String();
            
            return analysisResult;
          } catch (e) {
            debugPrint('JSON parsing error: $e');
            debugPrint('Content that failed to parse: $content');
            debugPrint('Content length: ${content.length}');
            
            // Fallback: Create a basic analysis result if parsing fails
            debugPrint('Creating fallback analysis result due to parsing error');
            
            return {
              'profileSummary': 'Analisis CV tidak dapat diproses sepenuhnya karena format response yang tidak sesuai. Silakan coba lagi.',
              'strengths': [
                'CV telah berhasil diupload dan diproses',
                'File PDF dapat dibaca dengan baik',
                'Sistem deteksi teks berfungsi normal'
              ],
              'improvements': [
                'Coba upload ulang CV dengan format yang lebih standar',
                'Pastikan CV memiliki struktur yang jelas dan mudah dibaca',
                'Gunakan font yang umum dan mudah dikenali sistem'
              ],
              'overallScore': 70,
              'careerRecommendations': 'Silakan coba upload CV kembali atau hubungi support jika masalah berlanjut.',
              'analyzedAt': DateTime.now().toIso8601String(),
              'fallbackUsed': true,
              'originalError': e.toString(),
            };
          }
        } else {
          throw Exception('No response content from Groq API');
        }
      } else {
        debugPrint('Groq API error: ${response.statusCode} - ${response.body}');
        throw Exception('Groq API request failed: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error in CV analysis: $e');
      if (e.toString().contains('TimeoutException')) {
        throw Exception('Request timeout. Please try again.');
      } else if (e.toString().contains('SocketException')) {
        throw Exception('Network error. Please check your internet connection.');
      } else {
        throw Exception('Analysis failed: ${e.toString()}');
      }
    }
  }
  
  /// Validate file (PDF/DOCX/DOC) before processing
  static Future<bool> validateFile(File file) async {
    try {
      // Check file size (max 5MB)
      final fileSizeInBytes = await file.length();
      final fileSizeInMB = fileSizeInBytes / (1024 * 1024);
      if (fileSizeInMB > 5) {
        throw Exception('Ukuran file melebihi 5MB');
      }

      final lower = file.path.toLowerCase();
      if (lower.endsWith('.pdf')) {
        return await validatePDFFile(file);
      } else if (lower.endsWith('.docx')) {
        // Quick check: must be a ZIP
        final bytes = await file.readAsBytes();
        if (bytes.length < 2 || bytes[0] != 0x50 || bytes[1] != 0x4B) {
          throw Exception('File DOCX tidak valid');
        }
        return true;
      } else if (lower.endsWith('.doc')) {
        // We don't support parsing .doc; allow selection but warn later during extraction
        return true;
      } else {
        throw Exception('Format file tidak didukung. Gunakan PDF atau DOCX.');
      }
    } catch (e) {
      debugPrint('General file validation error: $e');
      rethrow;
    }
  }

  /// Validate PDF file before processing
  static Future<bool> validatePDFFile(File pdfFile) async {
    try {
      // Check file size (max 5MB)
      int fileSizeInBytes = await pdfFile.length();
      double fileSizeInMB = fileSizeInBytes / (1024 * 1024);
      
      if (fileSizeInMB > 5) {
        throw Exception('File size exceeds 5MB limit');
      }
      
      // Check if file is actually a PDF by trying to load it
      try {
        Uint8List pdfBytes = await pdfFile.readAsBytes();
        PdfDocument document = PdfDocument(inputBytes: pdfBytes);
        document.dispose(); // Clean up immediately after validation
      } catch (e) {
        throw Exception('File is not a valid PDF or is corrupted');
      }
      
      return true;
    } catch (e) {
      debugPrint('PDF validation error: $e');
      rethrow;
    }
  }

  /// Unescape common XML entities
  static String _unescapeXml(String text) {
    return text
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&quot;', '"')
        .replaceAll('&apos;', "'");
  }
}
