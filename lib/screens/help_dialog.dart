import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HelpDialog extends StatelessWidget {
  const HelpDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF2E2E3E),
      title: Text(
        'How to Use',
        style: GoogleFonts.fredoka(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildSection(
              'Speak an Emotion',
              'Tap any card to hear the phrase.',
              Icons.touch_app,
            ),
            const SizedBox(height: 20),
            _buildSection(
              'Stop Speaking',
              'Tap the "STOP" button in the top-right corner or press ESC.',
              Icons.stop_circle_outlined,
            ),
            const SizedBox(height: 20),
            _buildSection(
              'Keyboard Shortcuts',
              'Press 1-6 to trigger emotions quickly.',
              Icons.keyboard,
            ),
            const SizedBox(height: 20),
            _buildSection(
              'Settings',
              'Tap the gear icon to adjust voice speed and pitch.',
              Icons.settings,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            'Got it!',
            style: GoogleFonts.fredoka(
              fontSize: 18,
              color: const Color(0xFF6C63FF),
            ),
          ),
        ),
      ],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
    );
  }

  Widget _buildSection(String title, String description, IconData icon) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white10,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: const Color(0xFF6C63FF), size: 24),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.fredoka(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                description,
                style: GoogleFonts.fredoka(fontSize: 14, color: Colors.white70),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
