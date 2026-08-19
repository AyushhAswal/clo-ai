import 'package:clo_ai/features/ai/presentation/screens/ai_vent_screen.dart';
import 'package:clo_ai/features/profile/presentation/screens/profile_screen.dart';
import 'package:clo_ai/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Full onboarding, login, home, AI vent, and profile tab test', (
    WidgetTester tester,
  ) async {
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

    // Tap AI Tab (Tab 1) in bottom navigation
    await tester.tap(find.byIcon(Icons.explore_outlined));
    await tester.pump(const Duration(milliseconds: 500));

    // Verify AI Vent Screen elements
    expect(find.text('Vent to CLO'), findsWidgets);
    expect(find.text('Analyzing your Relationship'), findsOneWidget);
    expect(
      find.textContaining('Unlock Deeper Understanding', findRichText: true),
      findsOneWidget,
    );

    // Tap Profile Tab (Tab 2) in bottom navigation
    await tester.tap(find.byIcon(Icons.person_outline_rounded));
    await tester.pump(const Duration(milliseconds: 500));

    // Verify Profile Screen elements
    expect(find.text('Profile'), findsWidgets);
    expect(find.text('Relationships'), findsOneWidget);
    expect(find.text('Edit Profile'), findsOneWidget);
  });

  testWidgets('AIVentScreen standalone rendering test', (
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
        child: const AIVentScreen(),
      ),
    );
    await tester.pump(const Duration(milliseconds: 500));

    // Verify AIVentScreen widgets
    expect(find.text('Vent to CLO'), findsOneWidget);
    expect(find.text('Analyzing your Relationship'), findsOneWidget);
    expect(find.text('Ayush'), findsOneWidget);
    expect(find.text('Professional'), findsOneWidget);
    expect(
      find.textContaining('Unlock Deeper Understanding', findRichText: true),
      findsOneWidget,
    );
    expect(find.text('Take your time—no wrong answers'), findsOneWidget);
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
