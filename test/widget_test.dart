import 'package:clo_ai/core/network/api_client.dart';
import 'package:clo_ai/features/chat/presentation/screens/chat_screen.dart';
import 'package:clo_ai/features/auth/cubit/auth_cubit.dart';
import 'package:clo_ai/features/auth/data/repositories/auth_repository.dart';
import 'package:clo_ai/features/login/presentation/widgets/google_sign_in_button.dart';
import 'package:clo_ai/features/profile/presentation/screens/profile_screen.dart';
import 'package:clo_ai/features/relationship/presentation/screens/questionnaire_screen.dart';
import 'package:clo_ai/main.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

import 'features/auth/auth_cubit_test.dart';
import 'features/chat/cubit/chat_cubit_test.dart';
import 'features/home/cubit/my_circle_cubit_test.dart';

void main() {
  testWidgets(
    'Full onboarding, login, home, My Circle tab, and profile tab test',
    (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1170, 2532);
      tester.view.devicePixelRatio = 3.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final fakeAdapter = FakeAdapter();
      final dio = Dio(BaseOptions(baseUrl: 'http://localhost:3000'));
      dio.httpClientAdapter = fakeAdapter;
      final apiClient = ApiClient(dio: dio);
      final mockTokenStorage = MockTokenStorage();
      final authRepository = AuthRepository(
        apiClient: apiClient,
        tokenStorage: mockTokenStorage,
      );
      final authCubit = AuthCubit(repository: authRepository);

      await tester.pumpWidget(CloApp(authCubit: authCubit));
      await tester.pump(const Duration(milliseconds: 500));
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

      // Tap Google Sign-In to navigate to HomeScreen
      await tester.tap(find.byType(GoogleSignInButton));
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pump(const Duration(milliseconds: 500));

      // Verify Home Screen elements (Tab 0) - expects Title Cased full name "Ayush Aswal"
      expect(
        find.textContaining("Ayush Aswal", findRichText: true),
        findsOneWidget,
      );
      expect(find.text('Tap to speak'), findsOneWidget);

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

    final mockRepo = MockRelationshipRepository();

    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(390, 844),
        builder: (context, child) => MaterialApp(
          home: QuestionnaireScreen(
            personName: 'Sarah',
            relationshipType: 'Friendship',
            repository: mockRepo,
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    // Verify Questionnaire for Sarah
    expect(find.text("Where's your friendship at?"), findsOneWidget);

    // Select Option 1
    await tester.tap(find.text('Close, and it feels solid.'));
    await tester.pump();

    // Tap Complete / Next
    await tester.tap(find.text('Complete'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
  });

  testWidgets('ChatScreen rendering and sending message test', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    final mockChatRepo = MockChatRepository();

    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(390, 844),
        builder: (context, child) => MaterialApp(home: child),
        child: ChatScreen(
          relationshipId: 'rel-1',
          personName: 'Rahul',
          relationshipType: 'Friendship',
          repository: mockChatRepo,
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pump(const Duration(milliseconds: 500));

    // Verify ChatScreen opened with Rahul and Friendship
    expect(find.text('Chat'), findsOneWidget);
    expect(find.text('Rahul'), findsOneWidget);
    expect(find.text('Friendship'), findsOneWidget);
    expect(find.text('Ask anything'), findsOneWidget);

    // Enter message "Hello Rahul" and tap send button key
    final sendButton = find.byKey(const Key('send_message_button'));
    await tester.enterText(find.byType(TextField), 'Hello Rahul');
    await tester.pump();
    await tester.tap(sendButton);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    // Drag list up to ensure newly appended message at bottom is built in ListView
    await tester.drag(find.byType(ListView), const Offset(0, -600));
    await tester.pumpAndSettle();

    // Verify new user message appended
    expect(find.text('Hello Rahul'), findsOneWidget);
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
    expect(find.text('Relationships'), findsOneWidget);
  });
}
