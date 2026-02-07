import 'package:flutter_tts/flutter_tts.dart';

class TtsService {
  late FlutterTts _flutterTts;

  TtsService() {
    _flutterTts = FlutterTts();
    _initTts();
  }

  void _initTts() async {
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.setVolume(1.0);
    await _flutterTts.setPitch(1.0);
  }

  void setHandlers({
    required Function() onStart,
    required Function() onCompletion,
    required Function() onCancel,
    required Function(dynamic) onError,
  }) {
    _flutterTts.setStartHandler(onStart);
    _flutterTts.setCompletionHandler(onCompletion);
    _flutterTts.setCancelHandler(onCancel);
    _flutterTts.setErrorHandler(onError);
  }

  Future<void> speak(String text) async {
    await _flutterTts.speak(text);
  }

  Future<void> stop() async {
    await _flutterTts.stop();
  }

  Future<void> setRate(double rate) async {
    await _flutterTts.setSpeechRate(rate);
  }

  Future<void> setPitch(double pitch) async {
    await _flutterTts.setPitch(pitch);
  }
}
