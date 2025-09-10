import 'package:speech_to_text/speech_to_text.dart';
import 'package:permission_handler/permission_handler.dart';

class SpeechService {
  static final SpeechToText _speechToText = SpeechToText();
  static bool _isInitialized = false;

  // Initialize speech recognition
  static Future<bool> initialize() async {
    if (_isInitialized) return true;

    try {
      // Request microphone permission
      final permissionStatus = await Permission.microphone.request();
      if (!permissionStatus.isGranted) {
        return false;
      }

      // Initialize speech to text
      _isInitialized = await _speechToText.initialize(
        onError: (error) => print('Speech recognition error: $error'),
        onStatus: (status) => print('Speech recognition status: $status'),
      );

      return _isInitialized;
    } catch (e) {
      print('Error initializing speech recognition: $e');
      return false;
    }
  }

  // Check if speech recognition is available
  static bool get isAvailable => _speechToText.isAvailable;

  // Check if currently listening
  static bool get isListening => _speechToText.isListening;

  // Start listening for speech
  static Future<void> startListening({
    required Function(String) onResult,
    Function(String)? onPartialResult,
  }) async {
    if (!_isInitialized) {
      final initialized = await initialize();
      if (!initialized) return;
    }

    if (!_speechToText.isListening) {
      await _speechToText.listen(
        onResult: (result) {
          if (result.finalResult) {
            onResult(result.recognizedWords);
          } else if (onPartialResult != null) {
            onPartialResult(result.recognizedWords);
          }
        },
        listenFor: const Duration(seconds: 30),
        pauseFor: const Duration(seconds: 3),
        partialResults: true,
        localeId: 'id_ID', // Indonesian language
        cancelOnError: true,
        listenMode: ListenMode.confirmation,
      );
    }
  }

  // Stop listening
  static Future<void> stopListening() async {
    if (_speechToText.isListening) {
      await _speechToText.stop();
    }
  }

  // Cancel listening
  static Future<void> cancelListening() async {
    if (_speechToText.isListening) {
      await _speechToText.cancel();
    }
  }

  // Get available locales
  static Future<List<LocaleName>> getLocales() async {
    if (!_isInitialized) {
      await initialize();
    }
    return _speechToText.locales();
  }

  // Check microphone permission
  static Future<bool> checkMicrophonePermission() async {
    final status = await Permission.microphone.status;
    return status.isGranted;
  }

  // Request microphone permission
  static Future<bool> requestMicrophonePermission() async {
    final status = await Permission.microphone.request();
    return status.isGranted;
  }
}
