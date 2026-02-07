import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/emotion.dart';

class EmotionCard extends StatefulWidget {
  final Emotion emotion;
  final VoidCallback onTap;

  const EmotionCard({super.key, required this.emotion, required this.onTap});

  @override
  State<EmotionCard> createState() => _EmotionCardState();
}

class _EmotionCardState extends State<EmotionCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
      lowerBound: 0.0,
      upperBound: 1.0,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.92,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() async {
    await _controller.forward();
    widget.onTap();
    await _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(scale: _scaleAnimation.value, child: child);
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          color: widget.emotion.color, // Solid color
          boxShadow: [
            BoxShadow(
              color: widget.emotion.color.withOpacity(0.4),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: _handleTap,
            borderRadius: BorderRadius.circular(32),
            splashColor: Colors.white24,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Emoji with subtle shadow
                    Text(
                      widget.emotion.emoji,
                      style: const TextStyle(
                        fontSize: 80,
                        shadows: [
                          Shadow(
                            offset: Offset(0, 4),
                            blurRadius: 8.0,
                            color: Colors.black12,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Label with high contrast
                    Text(
                      widget.emotion.label,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.fredoka(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          const Shadow(
                            offset: Offset(0, 2),
                            blurRadius: 4.0,
                            color: Colors.black26,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
