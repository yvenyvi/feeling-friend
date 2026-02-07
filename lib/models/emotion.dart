import 'package:flutter/material.dart';

class Emotion {
  final String label;
  final String emoji;
  final Color color; // Keep for fallback or shadow
  final List<Color> gradientColors;
  final String phrase;

  const Emotion({
    required this.label,
    required this.emoji,
    required this.color,
    required this.gradientColors,
    required this.phrase,
  });

  static const List<Emotion> emotions = [
    Emotion(
      label: 'Happy',
      emoji: '😊',
      color: Colors.green,
      gradientColors: [Color(0xFF43E97B), Color(0xFF38F9D7)],
      phrase: 'I am happy',
    ),
    Emotion(
      label: 'Sad',
      emoji: '😢',
      color: Colors.blue,
      gradientColors: [Color(0xFF4FACFE), Color(0xFF00F2FE)],
      phrase: 'I am sad',
    ),
    Emotion(
      label: 'Hungry',
      emoji: '🍔',
      color: Colors.orange,
      gradientColors: [Color(0xFFFA709A), Color(0xFFFEE140)],
      phrase: 'I am hungry',
    ),
    Emotion(
      label: 'Thirsty',
      emoji: '💧',
      color: Colors.lightBlueAccent,
      gradientColors: [Color(0xFF30CFD0), Color(0xFF330867)],
      phrase: 'I am thirsty',
    ),
    Emotion(
      label: 'Pain',
      emoji: '🤕',
      color: Colors.red,
      gradientColors: [Color(0xFFFF0844), Color(0xFFFFB199)],
      phrase: 'I am in pain',
    ),
    Emotion(
      label: 'Tired',
      emoji: '😴',
      color: Colors.purple,
      gradientColors: [Color(0xFF667EEA), Color(0xFF764BA2)],
      phrase: 'I am tired',
    ),
  ];
}
