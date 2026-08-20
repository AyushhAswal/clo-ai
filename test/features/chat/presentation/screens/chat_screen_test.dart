import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:clo_ai/features/chat/cubit/chat_cubit.dart';
import 'package:clo_ai/features/chat/presentation/screens/chat_screen.dart';

import '../../cubit/chat_cubit_test.dart';

void main() {
  group('ChatScreen Widget Tests', () {
    late MockChatRepository mockRepository;

    setUp(() {
      mockRepository = MockChatRepository();
    });

    Widget createWidgetUnderTest({ChatCubit? customCubit}) {
      final cubit = customCubit ?? ChatCubit(repository: mockRepository);
      return ScreenUtilInit(
        designSize: const Size(390, 844),
        builder: (context, child) => MaterialApp(
          home: ChatScreen(
            relationshipId: 'rel-1',
            personName: 'Rahul',
            relationshipType: 'Friendship',
            cubit: cubit,
          ),
        ),
      );
    }

    testWidgets('Renders header and loads conversation messages', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1170, 2532);
      tester.view.devicePixelRatio = 3.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.text('Chat'), findsOneWidget);
      expect(find.text('Rahul'), findsOneWidget);
      expect(find.text('Initial message'), findsOneWidget);
    });

    testWidgets('Empty message send is ignored', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1170, 2532);
      tester.view.devicePixelRatio = 3.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      // Tap send button without text input
      final sendButton = find.byKey(const Key('send_message_button'));
      await tester.tap(sendButton);
      await tester.pump();

      // Only initial message exists
      expect(find.text('Initial message'), findsOneWidget);
    });

    testWidgets('Enters text and sends user message', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1170, 2532);
      tester.view.devicePixelRatio = 3.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      // Enter message "Hello Rahul"
      await tester.enterText(find.byType(TextField), 'Hello Rahul');
      await tester.pump();

      final sendButton = find.byKey(const Key('send_message_button'));
      await tester.tap(sendButton);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.text('Hello Rahul'), findsOneWidget);
    });

    testWidgets('Shows error view and triggers retry', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1170, 2532);
      tester.view.devicePixelRatio = 3.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      mockRepository.shouldThrowError = true;

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.text('Failed to connect'), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);

      // Fix error and tap Retry
      mockRepository.shouldThrowError = false;
      await tester.tap(find.text('Retry'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.text('Initial message'), findsOneWidget);
    });

    testWidgets('Opens overflow menu and shows Delete confirmation dialog', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1170, 2532);
      tester.view.devicePixelRatio = 3.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      // Tap overflow menu
      await tester.tap(find.byIcon(Icons.more_vert_rounded));
      await tester.pumpAndSettle();

      // Tap "Delete Chat"
      await tester.tap(find.text('Delete Chat'));
      await tester.pumpAndSettle();

      // Verify AlertDialog elements
      expect(find.text('Delete Chat?'), findsOneWidget);
      expect(
        find.text('Are you sure you want to delete this chat?'),
        findsOneWidget,
      );

      // Tap Delete action button
      await tester.tap(find.text('Delete'));
      await tester.pumpAndSettle();

      // Conversation cleared
      expect(
        find.text('No messages yet. Send a message to start conversing!'),
        findsOneWidget,
      );
    });
  });
}
