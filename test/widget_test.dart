import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:feeling_friend/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const MethodChannel channel = MethodChannel('flutter_tts');

  setUp(() {
    // Mock SharedPreferences
    SharedPreferences.setMockInitialValues({});

    // Mock FlutterTts channel
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
          if (methodCall.method == 'speak') {
            return 1;
          }
          return 1;
        });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  testWidgets('Feeling Friend smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the title is present (in AppBar)
    expect(find.text('Feeling Friend'), findsOneWidget);

    // Verify that emotion labels are present
    expect(find.text('Happy'), findsOneWidget);
    expect(find.text('Sad'), findsOneWidget);

    // Verify Settings and Help buttons exist
    expect(find.byIcon(Icons.settings), findsOneWidget);
    expect(find.byIcon(Icons.help_outline), findsOneWidget);

    // Verify Stop button is initially HIDDEN (FAB removed, AppBar action hidden)
    expect(find.text('STOP'), findsNothing);
  });
}
