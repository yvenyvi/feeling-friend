import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui'; // For ImageFilter
import '../models/emotion.dart';
import '../services/tts_service.dart';
import '../services/preferences_service.dart';
import '../widgets/emotion_card.dart';
import 'settings_dialog.dart';
import 'help_dialog.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TtsService _ttsService = TtsService();
  final PreferencesService _preferencesService = PreferencesService();
  double _pitch = 1.0;
  double _rate = 0.5;
  final FocusNode _focusNode = FocusNode();
  bool _isSpeaking = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
    _setupTtsHandlers();
  }

  void _setupTtsHandlers() {
    _ttsService.setHandlers(
      onStart: () {
        setState(() {
          _isSpeaking = true;
        });
      },
      onCompletion: () {
        setState(() {
          _isSpeaking = false;
        });
      },
      onCancel: () {
        setState(() {
          _isSpeaking = false;
        });
      },
      onError: (err) {
        setState(() {
          _isSpeaking = false;
        });
      },
    );
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _loadSettings() async {
    final settings = await _preferencesService.loadSettings();
    setState(() {
      _pitch = settings['pitch']!;
      _rate = settings['rate']!;
    });
    await _ttsService.setPitch(_pitch);
    await _ttsService.setRate(_rate);
  }

  Future<void> _updateSettings(double pitch, double rate) async {
    setState(() {
      _pitch = pitch;
      _rate = rate;
    });
    await _ttsService.setPitch(pitch);
    await _ttsService.setRate(rate);
    await _preferencesService.saveSettings(pitch, rate);
  }

  void _speak(Emotion emotion) {
    _ttsService.speak(emotion.phrase);
  }

  void _stopSpeaking() {
    _ttsService.stop();
  }

  void _handleKeyEvent(KeyEvent event) {
    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.escape) {
        _stopSpeaking();
        return;
      }

      // 1-6 keys for emotions
      if (event.logicalKey.keyId >= LogicalKeyboardKey.digit1.keyId &&
          event.logicalKey.keyId <= LogicalKeyboardKey.digit6.keyId) {
        int index = event.logicalKey.keyId - LogicalKeyboardKey.digit1.keyId;
        if (index < Emotion.emotions.length) {
          _speak(Emotion.emotions[index]);
        }
      }
    }
  }

  void _openSettings() {
    showDialog(
      context: context,
      builder: (context) => SettingsDialog(
        initialPitch: _pitch,
        initialRate: _rate,
        onSettingsChanged: _updateSettings,
      ),
    );
  }

  void _openHelp() {
    showDialog(context: context, builder: (context) => const HelpDialog());
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: _handleKeyEvent,
      child: Scaffold(
        backgroundColor: const Color(0xFFFAFAFA), // Soft off-white background
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: Text(
            'Feeling Friend',
            style: GoogleFonts.fredoka(
              fontWeight: FontWeight.bold,
              fontSize: 28,
              color: const Color(0xFF333333),
            ),
          ),
          centerTitle: false,
          elevation: 0,
          backgroundColor: Colors.transparent,
          flexibleSpace: ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                color: Colors.white.withOpacity(0.5),
              ), // lighter glass
            ),
          ),
          actions: [
            _buildGlassIconButton(Icons.help_outline, 'Help', _openHelp),
            const SizedBox(width: 12),
            _buildGlassIconButton(Icons.settings, 'Settings', _openSettings),
            const SizedBox(width: 16),
          ],
        ),
        body: Container(
          // No gradient, just the background color
          child: Padding(
            padding: const EdgeInsets.only(
              top: 100.0,
              left: 20,
              right: 20,
              bottom: 20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "How are you feeling?",
                  style: GoogleFonts.fredoka(
                    fontSize: 24,
                    color: const Color(0xFF555555), // Softer dark gray
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      int crossAxisCount = constraints.maxWidth > 600 ? 3 : 2;
                      int rowCount = (Emotion.emotions.length / crossAxisCount)
                          .ceil();

                      // Calculate available height for the grid
                      // Ensure there's enough space, fall back to a reasonable aspect ratio if height is very small
                      double totalVerticalSpacing = (rowCount - 1) * 24.0;
                      double cardHeight =
                          (constraints.maxHeight - totalVerticalSpacing) /
                          rowCount;

                      double totalHorizontalSpacing =
                          (crossAxisCount - 1) * 20.0;
                      double cardWidth =
                          (constraints.maxWidth - totalHorizontalSpacing) /
                          crossAxisCount;

                      double childAspectRatio = cardHeight > 0
                          ? (cardWidth / cardHeight)
                          : 0.85;

                      return GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.zero,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 24,
                          childAspectRatio: childAspectRatio,
                        ),
                        itemCount: Emotion.emotions.length,
                        itemBuilder: (context, index) {
                          return EmotionCard(
                            emotion: Emotion.emotions[index],
                            onTap: () => _speak(Emotion.emotions[index]),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: _isSpeaking
            ? FloatingActionButton.extended(
                onPressed: _stopSpeaking,
                icon: const Icon(
                  Icons.stop_circle_outlined,
                  size: 32,
                  color: Colors.white,
                ),
                label: Text(
                  'STOP',
                  style: GoogleFonts.fredoka(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
                backgroundColor: Colors.redAccent.shade400,
                elevation: 4,
                tooltip: 'Stop Speaking (Esc)',
              )
            : null,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }

  Widget _buildGlassIconButton(
    IconData icon,
    String tooltip,
    VoidCallback onPressed,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(
          0.05,
        ), // Subtle dark tint for light mode
        borderRadius: BorderRadius.circular(12),
      ),
      child: IconButton(
        icon: Icon(icon, size: 24, color: const Color(0xFF333333)),
        tooltip: tooltip,
        onPressed: onPressed,
      ),
    );
  }
}
