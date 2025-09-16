import 'package:flutter_tts/flutter_tts.dart';

class TextToSpeechService {
  static FlutterTts? _flutterTts;
  static bool _isInitialized = false;

  static Future<void> _initialize() async {
    if (_isInitialized) return;
    
    _flutterTts = FlutterTts();
    
    try {
      // Set language to Indonesian
      await _flutterTts!.setLanguage("id-ID");
      
      // Set speech rate (0.0 to 1.0)
      await _flutterTts!.setSpeechRate(0.5);
      
      // Set volume (0.0 to 1.0)
      await _flutterTts!.setVolume(0.8);
      
      // Set pitch (0.5 to 2.0)
      await _flutterTts!.setPitch(1.0);
      
      _isInitialized = true;
      print('TextToSpeechService initialized successfully');
    } catch (e) {
      print('Error initializing TextToSpeechService: $e');
    }
  }

  static Future<void> speak(String text) async {
    try {
      await _initialize();
      
      if (_flutterTts != null && text.isNotEmpty) {
        // Stop any ongoing speech
        await _flutterTts!.stop();
        
        // Speak the text
        await _flutterTts!.speak(text);
      }
    } catch (e) {
      print('Error speaking text: $e');
      throw Exception('Failed to speak text: $e');
    }
  }

  static Future<void> stop() async {
    try {
      if (_flutterTts != null) {
        await _flutterTts!.stop();
      }
    } catch (e) {
      print('Error stopping TTS: $e');
    }
  }

  static Future<void> pause() async {
    try {
      if (_flutterTts != null) {
        await _flutterTts!.pause();
      }
    } catch (e) {
      print('Error pausing TTS: $e');
    }
  }

  static Future<bool> get isPlaying async {
    try {
      if (_flutterTts != null) {
        return await _flutterTts!.isLanguageAvailable("id-ID");
      }
      return false;
    } catch (e) {
      print('Error checking TTS status: $e');
      return false;
    }
  }

  static Future<void> setSpeechRate(double rate) async {
    try {
      await _initialize();
      if (_flutterTts != null) {
        await _flutterTts!.setSpeechRate(rate.clamp(0.0, 1.0));
      }
    } catch (e) {
      print('Error setting speech rate: $e');
    }
  }

  static Future<void> setVolume(double volume) async {
    try {
      await _initialize();
      if (_flutterTts != null) {
        await _flutterTts!.setVolume(volume.clamp(0.0, 1.0));
      }
    } catch (e) {
      print('Error setting volume: $e');
    }
  }

  static Future<void> setPitch(double pitch) async {
    try {
      await _initialize();
      if (_flutterTts != null) {
        await _flutterTts!.setPitch(pitch.clamp(0.5, 2.0));
      }
    } catch (e) {
      print('Error setting pitch: $e');
    }
  }

  static void dispose() {
    _flutterTts = null;
    _isInitialized = false;
  }
}
