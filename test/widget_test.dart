import 'package:clo_ai/features/ai/presentation/screens/ai_vent_screen.dart';
import 'package:clo_ai/features/home/presentation/screens/my_circle_screen.dart';
import 'package:clo_ai/features/profile/presentation/screens/profile_screen.dart';
import 'package:clo_ai/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
    'Full onboarding, login, home, My Circle tab, and profile tab test',
    (WidgetTester tester) async {
      // Set portrait mobile screen viewport (390x844 logical pixels)
      tester.view.physicalSize = const Size(1170, 2532);
      tester.view.devicePixelRatio = 3.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      // Build our app and trigger a frame.
      await tester.pumpWidget(const CloApp());
      await tester.pump(const Duration(milliseconds: 500));

      // Page 1 Verification
      expect(find.textContaining("CLO AI", findRichText: true), findsWidgets);

      // Navigate through onboarding to Page 4
      await tester.tap(find.byIcon(Icons.chevron_right_rounded));
      await tester.pump(const Duration(milliseconds: 500));
      await tester.tap(find.byIcon(Icons.chevron_right_rounded));
      await tester.pump(const Duration(milliseconds: 500));
      await tester.tap(find.byIcon(Icons.chevron_right_rounded));
      await tester.pump(const Duration(milliseconds: 500));

      // Tap Get Started on Page 4 (triggers pushReplacement to LoginScreen)
      await tester.tap(find.text('Get Started'));
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pump(const Duration(milliseconds: 500));

      // Verify Login Screen
      expect(find.text('Welcome Back!'), findsOneWidget);

      // Tap Login to navigate to HomeScreen
      await tester.tap(find.text('Login'));
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pump(const Duration(milliseconds: 500));

      // Verify Home Screen elements (Tab 0)
      expect(
        find.textContaining("ayushaswal", findRichText: true),
        findsOneWidget,
      );
      expect(find.text('Tap to speak'), findsOneWidget);

      // Tap My Circle Tab (Tab 1) in bottom navigation
      await tester.tap(find.byIcon(Icons.bubble_chart_outlined));
      await tester.pump(const Duration(milliseconds: 500));

      // Verify Full My Circle Screen elements
      expect(find.text('My Circle'), findsWidgets);
      expect(find.text('Ayush'), findsOneWidget);
      expect(find.text('Ayduh'), findsOneWidget);

      // Tap Profile Tab (Tab 2) in bottom navigation
      await tester.tap(find.byIcon(Icons.person_outline_rounded));
      await tester.pump(const Duration(milliseconds: 500));

      // Verify Profile Screen elements
      expect(find.text('Profile'), findsWidgets);
      expect(find.text('Relationships'), findsOneWidget);
      expect(find.text('Edit Profile'), findsOneWidget);
    },
  );

  testWidgets('Full Add Relationship and Questionnaire flow test', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(390, 844),
        builder: (context, child) => const MaterialApp(home: MyCircleScreen()),
      ),
    );
    await tester.pump(const Duration(milliseconds: 500));

    // Verify initial cards
    expect(find.text('Ayush'), findsOneWidget);
    expect(find.text('Ayduh'), findsOneWidget);

    // Tap Floating Add button (+)
    await tester.tap(find.byIcon(Icons.add_rounded).last);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    // Verify Add Relationship Name screen
    expect(find.text('Add Relationship'), findsOneWidget);
    expect(find.text('Add Photo'), findsOneWidget);

    // Enter name "Sarah"
    await tester.enterText(find.byType(TextField), 'Sarah');
    await tester.pump();

    // Tap Next
    await tester.tap(find.text('Next'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    // Verify Choose Relationship Type screen
    expect(
      find.textContaining('Choose Your Relationship', findRichText: true),
      findsOneWidget,
    );

    // Tap "Friend"
    await tester.tap(find.text('Friend'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 700));
    await tester.pump(const Duration(milliseconds: 500));

    // Verify Questionnaire Q1 for Sarah
    expect(find.text("Where's your friendship with Sarah at?"), findsOneWidget);

    // Select Q1 Option 1
    await tester.tap(find.text('Close, and it feels solid.'));
    await tester.pump();

    // Tap Next to go to Q2
    await tester.tap(find.text('Next'));
    await tester.pump(const Duration(milliseconds: 500));

    // Verify Questionnaire Q2
    expect(
      find.text('What comes up most strongly around Sarah?'),
      findsOneWidget,
    );

    // Select Q2 Option 1
    await tester.tap(find.text('Ease — I can be myself.'));
    await tester.pump();

    // Tap Next to go to Q3
    await tester.tap(find.text('Next'));
    await tester.pump(const Duration(milliseconds: 500));

    // Verify Questionnaire Q3
    expect(find.text('What do you most want from Sarah?'), findsOneWidget);

    // Select Q3 Option
    await tester.tap(find.text('More honesty — no more pretending.'));
    await tester.pump();

    // Tap Complete
    await tester.tap(find.text('Complete'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    // Verify return to MyCircleScreen with newly added "Sarah"
    expect(find.text('My Circle'), findsWidgets);
    expect(find.text('Sarah'), findsOneWidget);

    // Tap Sarah card to push AIVentScreen
    await tester.tap(find.text('Sarah'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    // Verify AIVentScreen opened with Sarah & Friendship
    expect(find.text('Vent to CLO'), findsOneWidget);
    expect(find.text('Sarah'), findsOneWidget);
  });

  testWidgets('AIVentScreen to ChatScreen navigation test', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(390, 844),
        builder: (context, child) => MaterialApp(home: child),
        child: const AIVentScreen(
          personName: 'Ayduh',
          relationshipType: 'Friendship',
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 500));

    // Verify AIVentScreen
    expect(find.text('Vent to CLO'), findsOneWidget);

    // Tap Chat button (Icons.sms_outlined)
    await tester.tap(find.byIcon(Icons.sms_outlined));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    // Verify ChatScreen opened with Ayduh and Friendship
    expect(find.text('Chat'), findsOneWidget);
    expect(find.text('Ayduh'), findsOneWidget);
    expect(find.text('Friendship'), findsOneWidget);
    expect(find.text('Ask anything'), findsOneWidget);

    // Enter message "Hello Ayduh" and tap send button key
    final sendButton = find.byKey(const Key('send_message_button'));
    await tester.enterText(find.byType(TextField), 'Hello Ayduh');
    await tester.pump();
    await tester.tap(sendButton);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    // Drag list up to ensure newly appended message at bottom is built in ListView
    await tester.drag(find.byType(ListView), const Offset(0, -600));
    await tester.pumpAndSettle();

    // Verify new user message appended
    expect(find.text('Hello Ayduh'), findsOneWidget);

    // Tap Back Arrow
    await tester.tap(find.byIcon(Icons.arrow_back_rounded));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    // Verify back navigation returns to AIVentScreen
    expect(find.text('Vent to CLO'), findsOneWidget);
  });

  testWidgets('ProfileScreen standalone rendering test', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(390, 844),
        builder: (context, child) => MaterialApp(home: child),
        child: const ProfileScreen(),
      ),
    );
    await tester.pump();

    // Verify Profile Screen widgets
    expect(find.text('Profile'), findsOneWidget);
    expect(find.text('ayushaswal'), findsOneWidget);
    expect(find.text('Relationships'), findsOneWidget);
  });
}
