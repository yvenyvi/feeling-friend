import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static const String _keyPitch = 'voice_pitch';
  static const String _keyRate = 'voice_rate';

  Future<void> saveSettings(double pitch, double rate) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_keyPitch, pitch);
    await prefs.setDouble(_keyRate, rate);
  }

  Future<Map<String, double>> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    double pitch = prefs.getDouble(_keyPitch) ?? 1.0;
    double rate = prefs.getDouble(_keyRate) ?? 0.5;
    return {'pitch': pitch, 'rate': rate};
  }
}
