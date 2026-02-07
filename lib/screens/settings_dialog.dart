import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsDialog extends StatefulWidget {
  final double initialPitch;
  final double initialRate;
  final Function(double, double) onSettingsChanged;

  const SettingsDialog({
    super.key,
    required this.initialPitch,
    required this.initialRate,
    required this.onSettingsChanged,
  });

  @override
  State<SettingsDialog> createState() => _SettingsDialogState();
}

class _SettingsDialogState extends State<SettingsDialog> {
  late double _pitch;
  late double _rate;

  @override
  void initState() {
    super.initState();
    _pitch = widget.initialPitch;
    _rate = widget.initialRate;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF2E2E3E), // Dark dialog bg
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      title: Text(
        'Settings',
        style: GoogleFonts.fredoka(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildSliderRow(
            'Pitch',
            _pitch,
            0.5,
            2.0,
            (val) => setState(() => _pitch = val),
          ),
          const SizedBox(height: 24),
          _buildSliderRow(
            'Speed',
            _rate,
            0.0,
            1.0,
            (val) => setState(() => _rate = val),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            'Cancel',
            style: GoogleFonts.fredoka(fontSize: 18, color: Colors.white60),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            widget.onSettingsChanged(_pitch, _rate);
            Navigator.of(context).pop();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF6C63FF), // Vibrant action color
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
          child: Text(
            'Save',
            style: GoogleFonts.fredoka(fontSize: 18, color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _buildSliderRow(
    String label,
    double value,
    double min,
    double max,
    ValueChanged<double> onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: GoogleFonts.fredoka(fontSize: 18, color: Colors.white),
            ),
            Text(
              value.toStringAsFixed(1),
              style: GoogleFonts.fredoka(fontSize: 16, color: Colors.white60),
            ),
          ],
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: const Color(0xFF6C63FF),
            inactiveTrackColor: Colors.white24,
            thumbColor: const Color(0xFF6C63FF),
            overlayColor: const Color(0x296C63FF),
          ),
          child: Slider(
            value: value,
            min: min,
            max: max,
            divisions: 10,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
